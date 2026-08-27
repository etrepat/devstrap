#!/usr/bin/env bash
# Shared optional-apps selection helpers (single source of truth)
# Used by devstrap.sh (interactive prompt) and 35-apps-optional.sh (fallback).

# Optional apps are grouped by category. gum has no grouped multi-select, so
# each category gets its own prompt; the app names (not the category) are what
# 35-apps-optional.sh matches on.
DEVSTRAP_OPTIONAL_APP_CATEGORIES=("Dev" "Media" "Gaming")
DEVSTRAP_OPTIONAL_APPS_BY_CATEGORY=(
    "Cursor LM Studio"
    "Inkscape OBS Studio"
    "Steam"
)
DEVSTRAP_DEFAULT_OPTIONAL_APPS=("Inkscape" "OBS Studio")

devstrap_prompt_optional_apps() {
    if [[ ! -v DEVSTRAP_SELECTED_OPTIONAL_APPS ]]; then
        local -a selected=()
        local i cat apps opts app pre choice
        for i in "${!DEVSTRAP_OPTIONAL_APP_CATEGORIES[@]}"; do
            cat="${DEVSTRAP_OPTIONAL_APP_CATEGORIES[i]}"
            read -ra opts <<<"${DEVSTRAP_OPTIONAL_APPS_BY_CATEGORY[i]}"

            # Pre-select the defaults that belong to this category
            pre=()
            for app in "${opts[@]}"; do
                if [[ " ${DEVSTRAP_DEFAULT_OPTIONAL_APPS[*]} " == *" ${app} "* ]]; then
                    pre+=("${app}")
                fi
            done

            local -a args=("None" "${opts[@]}" --no-limit --height 10
                --header "Optional ${cat} apps (or 'None' to skip this category)")
            if ((${#pre[@]} > 0)); then
                args+=(--selected "${pre[@]}")
            fi

            choice="$(gum choose "${args[@]}")"
            if [[ -n "${choice}" && " ${choice} " != *" None "* ]]; then
                local -a chosen=()
                readarray -t chosen <<<"${choice}"
                selected+=("${chosen[@]}")
            fi
        done
        # Newline-delimited so names containing spaces (e.g. "OBS Studio")
        # survive later word splitting intact
        export DEVSTRAP_SELECTED_OPTIONAL_APPS="$(printf '%s\n' "${selected[@]}")"
    fi
}

devstrap_optional_app_selected() {
    local app="$1"
    [[ -n "${DEVSTRAP_SELECTED_OPTIONAL_APPS}" && " ${DEVSTRAP_SELECTED_OPTIONAL_APPS} " == *" ${app} "* ]]
}
