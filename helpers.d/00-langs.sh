#!/usr/bin/env bash
# Shared language-selection helpers (single source of truth)
# Used by devstrap.sh (interactive prompt) and 20-dev-select-langs.sh (fallback).

DEVSTRAP_AVAILABLE_LANGS=("Elixir" "Go" "Java" "Node.js" "PHP" "Python" "Ruby" "Rust")
DEVSTRAP_DEFAULT_LANGS="Node.js,PHP"

devstrap_prompt_langs() {
    if [[ ! -v DEVSTRAP_SELECTED_LANGS ]]; then
        DEVSTRAP_SELECTED_LANGS=$(gum choose "${DEVSTRAP_AVAILABLE_LANGS[@]}" \
            --no-limit --selected "${DEVSTRAP_DEFAULT_LANGS}" --height 10 \
            --header "Please, select the programming languages to install") || true
        export DEVSTRAP_SELECTED_LANGS
    fi
}

devstrap_lang_selected() {
    local lang="$1"
    [[ -n "${DEVSTRAP_SELECTED_LANGS}" && " ${DEVSTRAP_SELECTED_LANGS} " == *" ${lang} "* ]]
}
