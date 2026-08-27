#!/usr/bin/env bash
# First-boot devstrap launcher.
#
# Installed by archinstall's `custom_commands` into ~/.config/devstrap/ and
# triggered once via a GNOME autostart entry on the very first login. It opens
# the devstrap bootstrap TUI inside a terminal, then removes itself so it never
# runs again.

set -u

repo="${HOME}/devstrap"
state_dir="${HOME}/.local/state/devstrap"
autostart_entry="${HOME}/.config/autostart/devstrap-first-boot.desktop"

if [[ -f "${state_dir}/first-boot.done" ]]; then
    rm -f "${autostart_entry}"
    exit 0
fi

mkdir -p "${state_dir}"

# Ensure the repo is present (it's normally pre-cloned by custom_commands)
if [[ ! -d "${repo}/.git" ]]; then
    git clone --depth 1 https://github.com/etrepat/devstrap.git "${repo}" || true
fi

rm -f "${autostart_entry}"

cmd="DEVSTRAP_PATH='${repo}' bash '${repo}/devstrap.sh'; touch '${state_dir}/first-boot.done'"

# Prefer a real terminal for the interactive TUI; fall back to the current session
for term in ghostty kgx gnome-terminal konsole x-terminal-emulator; do
    if command -v "${term}" >/dev/null 2>&1; then
        "${term}" -e bash -lc "${cmd}" &
        exit 0
    fi
done

bash -lc "${cmd}"