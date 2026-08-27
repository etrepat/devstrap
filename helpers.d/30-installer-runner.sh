#!/usr/bin/env bash
# Installer runner — each installer runs in its own subshell with a dedicated log,
# so one failure doesn't abort the whole run. Completion state is tracked
# persistently (~/.local/state/devstrap) so re-runs skip finished steps and can
# pick a subset. Used by devstrap.sh.

run_installers() {
    local state_dir="${DEVSTRAP_STATE_DIR:-${HOME}/.local/state/devstrap}/steps"
    mkdir -p "${state_dir}" "${DEVSTRAP_TMP}/logs"

    # Key completion markers by the install-time selections so that a later re-run
    # with different language/editor/app choices re-runs the affected installers.
    local selection_key
    selection_key="$(printf '%s|%s|%s|%s' "${DEVSTRAP_SELECTED_LANGS}" "${DEVSTRAP_SELECTED_EDITORS}" \
        "${DEVSTRAP_SELECTED_OPTIONAL_APPS}" "${DEVSTRAP_GNOME_CUSTOMIZE}" | md5sum | cut -d' ' -f1)"

    # The git step is additionally keyed by the user identity, so re-running with
    # a different name/email re-applies the git config without forcing a full re-run.
    step_key() {
        local name="$1"
        if [[ "${name}" == "10-utils-git.sh" ]]; then
            printf '%s|%s|%s' "${selection_key}" "${DEVSTRAP_USERNAME}" "${DEVSTRAP_USER_EMAIL}" |
                md5sum | cut -d' ' -f1
        else
            printf '%s' "${selection_key}"
        fi
    }

    local pending=()
    local installer name
    for installer in "${DEVSTRAP_PATH}"/install.d/*.sh; do
        name="$(basename "${installer}")"
        if [[ -n "${DEVSTRAP_FORCE}" ]] || [[ ! -f "${state_dir}/${name}.$(step_key "${name}").done" ]]; then
            pending+=("${name}")
        fi
    done

    if ((${#pending[@]} == 0)); then
        echo "=> All installers already completed for these selections."
        return 0
    fi

    # Offer a subset picker when resuming after failures or when explicitly requested
    local chosen=()
    if [[ -n "${DEVSTRAP_SELECT_STEPS}" ]] || compgen -G "${state_dir}/*.failed" >/dev/null; then
        mapfile -t chosen < <(gum choose "${pending[@]}" --no-limit \
            --selected "$(
                IFS=,
                echo "${pending[*]}"
            )" --height 10 \
            --header "Installers to run (completed steps are excluded)")
        ((${#chosen[@]} == 0)) && chosen=("${pending[@]}")
    else
        chosen=("${pending[@]}")
    fi

    local DEVSTRAP_FAILED=()
    local log
    for name in "${chosen[@]}"; do
        log="${DEVSTRAP_TMP}/logs/${name}.log"
        echo "  => ${name}"
        # shellcheck disable=SC1090
        if (. "${DEVSTRAP_PATH}/install.d/${name}") >"${log}" 2>&1; then
            touch "${state_dir}/${name}.$(step_key "${name}").done"
            rm -f "${state_dir}/${name}.failed"
            echo "  [ok]   ${name}"
        else
            touch "${state_dir}/${name}.failed"
            echo "  [FAIL] ${name} (log: ${log})"
            DEVSTRAP_FAILED+=("${name}")
        fi
    done

    if ((${#DEVSTRAP_FAILED[@]} > 0)); then
        echo -e "\e[31;1m${#DEVSTRAP_FAILED[@]} step(s) failed:\e[0m ${DEVSTRAP_FAILED[*]}"
        echo -e "\e[31;1mLogs: ${DEVSTRAP_TMP}/logs/\e[0m"
    fi
}
