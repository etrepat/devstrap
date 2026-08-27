#!/usr/bin/env bash
# Shared GNOME session helpers
# Used by devstrap.sh (cleanup) to restore the lock/idle settings that are
# temporarily disabled while installing.

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
