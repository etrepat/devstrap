#!/usr/bin/env bash
# Shared trap handlers
# Used by devstrap.sh (ERR/EXIT/INT/TERM traps) for cleanup & error reporting.
# shellcheck disable=SC2154

cleanup_handler() {
    kill "${DEVSTRAP_SUDO_KEEPALIVE}" 2>/dev/null || true
    restore_gnome_session_settings
}

error_handler() {
    echo -e "\e[31;1mInstall failed\e[0m"
    echo -e "You may run the install scripts individually or retry by running: \e[33;1m$DEVSTRAP_PATH/install.sh\e[0m"
}
