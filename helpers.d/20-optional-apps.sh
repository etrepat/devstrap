#!/usr/bin/env bash
# Shared optional-apps selection helpers
# Used by devstrap.sh (interactive prompt) and 30-apps-optional.sh (fallback).

DEVSTRAP_AVAILABLE_OPTIONAL_APPS=("OBS Studio" "GIMP" "Inkscape" "Steam")
DEVSTRAP_DEFAULT_OPTIONAL_APPS=("OBS Studio" "GIMP" "Inkscape")

devstrap_prompt_optional_apps() {
    if [[ ! -v DEVSTRAP_SELECTED_OPTIONAL_APPS ]]; then
        local selected
        selected="$(gum choose "None" "${DEVSTRAP_AVAILABLE_OPTIONAL_APPS[@]}" \
            --no-limit --selected "${DEVSTRAP_DEFAULT_OPTIONAL_APPS[@]}" --height 10 \
            --header "Please, select optional desktop apps (or 'None' to skip)")"
        if [[ " ${selected} " == *" None "* ]]; then
            selected=""
        fi
        export DEVSTRAP_SELECTED_OPTIONAL_APPS="${selected}"
    fi
}

devstrap_optional_app_selected() {
    local app="$1"
    [[ -n "${DEVSTRAP_SELECTED_OPTIONAL_APPS}" && " ${DEVSTRAP_SELECTED_OPTIONAL_APPS} " == *" ${app} "* ]]
}