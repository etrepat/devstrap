#!/usr/bin/env bash
# Shared editor-selection helpers (single source of truth)
# Used by devstrap.sh (interactive prompt) and 20-dev-editor-*.sh (fallback).

DEVSTRAP_AVAILABLE_EDITORS=("Visual Studio Code" "Zed" "NeoVim")
DEVSTRAP_DEFAULT_EDITORS=("Visual Studio Code")

devstrap_prompt_editors() {
    if [[ ! -v DEVSTRAP_SELECTED_EDITORS ]]; then
        local selected
        selected="$(gum choose "None" "${DEVSTRAP_AVAILABLE_EDITORS[@]}" \
            --no-limit --selected "${DEVSTRAP_DEFAULT_EDITORS[@]}" --height 10 \
            --header "Please, select the editor(s) to install (or 'None' to skip editors)")"
        if [[ " ${selected} " == *" None "* ]]; then
            selected=""
        fi
        export DEVSTRAP_SELECTED_EDITORS="${selected}"
    fi
}

devstrap_editor_selected() {
    local editor="$1"
    [[ -n "${DEVSTRAP_SELECTED_EDITORS}" && " ${DEVSTRAP_SELECTED_EDITORS} " == *" ${editor} "* ]]
}
