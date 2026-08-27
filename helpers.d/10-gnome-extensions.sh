#!/usr/bin/env bash
# Shared GNOME extension helpers (single source of truth)
# Installs a GNOME extension directly from extensions.gnome.org (no AUR / gext).

ext_install() {
    local uuid="$1"
    local shell_version
    shell_version="$(gnome-shell --version | grep -oE '[0-9]+' | head -1)"
    local pk
    pk="$(curl -sLf "https://extensions.gnome.org/extension-info/?uuid=${uuid}&shell_version=${shell_version}" |
        jq -r --arg sv "${shell_version}" '.shell_version_map[$sv].pk // empty' || true)"
    if [[ -z "${pk}" ]]; then
        echo "  (skipping ${uuid}: no build for GNOME ${shell_version})"
        return 0
    fi
    echo "  Installing ${uuid}..."
    curl -sLf "https://extensions.gnome.org/download-extension/${uuid}.shell-extension.zip?version_tag=${pk}" \
        -o "${DEVSTRAP_TMP}/${uuid}.zip"
    gnome-extensions install --force "${DEVSTRAP_TMP}/${uuid}.zip"
    gnome-extensions enable "${uuid}"
    rm -f "${DEVSTRAP_TMP}/${uuid}.zip"
}
