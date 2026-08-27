#!/usr/bin/env bash

# Exit inmediately
set -e

# Reset sudo credentials & ask for password preemptively
sudo -K && sudo -v

# Sudo keep-alive (re-authenticate on expiry instead of dying)
(while true; do sudo -n true 2>/dev/null; sleep 60; done) &
export DEVSTRAP_SUDO_KEEPALIVE=$!

# Setup
export DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
export DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"

# Inform on if something failed
restore_gnome_session_settings() {
    if [[ "${DEVSTRAP_USING_GNOME:-false}" != "true" ]]; then
        return 0
    fi

    if [[ -n "${DEVSTRAP_GNOME_LOCK_ENABLED:-}" ]]; then
        gsettings set org.gnome.desktop.screensaver lock-enabled "${DEVSTRAP_GNOME_LOCK_ENABLED}" || true
    fi

    if [[ -n "${DEVSTRAP_GNOME_IDLE_DELAY:-}" ]]; then
        gsettings set org.gnome.desktop.session idle-delay "${DEVSTRAP_GNOME_IDLE_DELAY}" || true
    fi
}

cleanup_handler() {
    kill "${DEVSTRAP_SUDO_KEEPALIVE}" 2>/dev/null || true
    restore_gnome_session_settings
}

error_handler() {
    echo -e "\e[31;1mInstall failed\e[0m"
    echo -e "You may run the install scripts individually or retry by running: \e[33;1m$DEVSTRAP_PATH/install.sh\e[0m"
}

trap error_handler ERR
trap cleanup_handler EXIT INT TERM

# Perform os-specific checks here
. ${DEVSTRAP_PATH}/os-checks.sh

# Load shared helpers
for helper in ${DEVSTRAP_PATH}/helpers.d/*.sh; do . $helper; done

# Bootstrap required tooling
echo -e "\e[33;1m~>\e[0m Initializing..."
for req in ${DEVSTRAP_PATH}/requirements.d/*.sh; do . $req; done

# Installation
clear; echo -e "\n\e[36;1mdevstrap\e[0m\n"
if ! gum confirm "This script will bootstrap a freshly installed machine w/several configuration choices. Proceed?"; then
    echo -e "\e[33;1m~>\e[0m Installation cancelled."
    exit 0
fi

# Identify user (for git config)
export DEVSTRAP_USERNAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export DEVSTRAP_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

# Ask the user to select which programming languages to install
devstrap_prompt_langs

# Ask the user to select the editor(s) to install
devstrap_prompt_editors

# Ask the user to select optional desktop apps
devstrap_prompt_optional_apps

# Ask the user it it wants to apply GNOME settings & customizations (if using gnome) ?
DEVSTRAP_USING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
export DEVSTRAP_GNOME_CUSTOMIZE=$(${DEVSTRAP_USING_GNOME} && gum confirm "Apply GNOME theme & customizations (including extensions)?" && echo 'y')

if [ "$DEVSTRAP_USING_GNOME" = true ]; then
    export DEVSTRAP_GNOME_LOCK_ENABLED="$(gsettings get org.gnome.desktop.screensaver lock-enabled || true)"
    export DEVSTRAP_GNOME_IDLE_DELAY="$(gsettings get org.gnome.desktop.session idle-delay || true)"

    # Ensure computer doesn't go to sleep or lock while installing
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.session idle-delay 0
fi

# Update & upgrade packages before installing anything
gum spin --title "Upgrading base system, this may take a while..." -- yay -Syu --noconfirm > /dev/null

# Run installers — each isolated in its own subshell with a dedicated log, so one
# failure doesn't abort the whole run. Completion state is tracked persistently
# (~/.local/state/devstrap) so re-runs skip finished steps and can pick a subset.
run_installers() {
    local state_dir="${DEVSTRAP_STATE_DIR:-${HOME}/.local/state/devstrap}/steps"
    mkdir -p "${state_dir}" "${DEVSTRAP_TMP}/logs"

    # Key completion markers by the install-time selections so that a later re-run
    # with different language/editor/app choices re-runs the affected installers.
    local selection_key
    selection_key="$(printf '%s|%s|%s|%s' "${DEVSTRAP_SELECTED_LANGS}" "${DEVSTRAP_SELECTED_EDITORS}" \
        "${DEVSTRAP_SELECTED_OPTIONAL_APPS}" "${DEVSTRAP_GNOME_CUSTOMIZE}" | md5sum | cut -d' ' -f1)"

    local pending=()
    local installer name
    for installer in ${DEVSTRAP_PATH}/install.d/*.sh; do
        name="$(basename "${installer}")"
        if [[ -n "${DEVSTRAP_FORCE}" ]] || [[ ! -f "${state_dir}/${name}.${selection_key}.done" ]]; then
            pending+=("${name}")
        fi
    done

    if (( ${#pending[@]} == 0 )); then
        echo "=> All installers already completed for these selections."
        return 0
    fi

    # Offer a subset picker when resuming after failures or when explicitly requested
    local chosen=()
    if [[ -n "${DEVSTRAP_SELECT_STEPS}" ]] || compgen -G "${state_dir}/*.failed" > /dev/null; then
        chosen=($(gum choose "${pending[@]}" --no-limit \
            --selected "$(IFS=,; echo "${pending[*]}")" --height 10 \
            --header "Installers to run (completed steps are excluded)"))
        (( ${#chosen[@]} == 0 )) && chosen=("${pending[@]}")
    else
        chosen=("${pending[@]}")
    fi

    local DEVSTRAP_FAILED=()
    local log
    for name in "${chosen[@]}"; do
        log="${DEVSTRAP_TMP}/logs/${name}.log"
        echo "  => ${name}"
        if ( . "${DEVSTRAP_PATH}/install.d/${name}" ) >"${log}" 2>&1; then
            touch "${state_dir}/${name}.${selection_key}.done"
            rm -f "${state_dir}/${name}.failed"
            echo "  [ok]   ${name}"
        else
            touch "${state_dir}/${name}.failed"
            echo "  [FAIL] ${name} (log: ${log})"
            DEVSTRAP_FAILED+=("${name}")
        fi
    done

    if (( ${#DEVSTRAP_FAILED[@]} > 0 )); then
        echo -e "\e[31;1m${#DEVSTRAP_FAILED[@]} step(s) failed:\e[0m ${DEVSTRAP_FAILED[*]}"
        echo -e "\e[31;1mLogs: ${DEVSTRAP_TMP}/logs/\e[0m"
    fi
}

run_installers

if [ "$DEVSTRAP_USING_GNOME" = true ]; then
    # Revert to normal idle and lock settings
    gsettings set org.gnome.desktop.screensaver lock-enabled "${DEVSTRAP_GNOME_LOCK_ENABLED:-false}"
    gsettings set org.gnome.desktop.session idle-delay "${DEVSTRAP_GNOME_IDLE_DELAY:-300}"
fi

echo -e "\e[33;1m~>\e[0m Doing cleanup..."

orphaned="$(yay -Qdtq || true)"
if [[ -n "${orphaned}" ]]; then
    yay -Rns --noconfirm ${orphaned}
fi
yay -Sc --noconfirm
yay -Syu --noconfirm

echo -e "\e[33;1m~>\e[0m Removing artifacts..."
rm -fr ${DEVSTRAP_PATH}

unset DEVSTRAP_GNOME_LOCK_ENABLED
unset DEVSTRAP_GNOME_IDLE_DELAY
unset DEVSTRAP_GNOME_CUSTOMIZE
unset DEVSTRAP_SELECTED_LANGS
unset DEVSTRAP_SELECTED_EDITORS
unset DEVSTRAP_SELECTED_OPTIONAL_APPS
unset DEVSTRAP_USER_EMAIL
unset DEVSTRAP_USERNAME
unset DEVSTRAP_PATH
unset DEVSTRAP_TMP

echo -e "\e[32;1m~>\e[0m All done."
gum confirm "It is recommended to reboot the system to apply all the changes. Reboot now?" && sudo shutdown -r now
