#!/usr/bin/env bash

# Optional desktop apps (user-selectable at install time, grouped by category)
devstrap_prompt_optional_apps

# The selection is newline-delimited; read line-by-line so names containing
# spaces (e.g. "OBS Studio") match the case branches below.
while IFS= read -r app; do
    [[ -z "${app}" ]] && continue
    case ${app} in
    Cursor)
        echo "=> Installing Cursor (AppImage)..."
        # Keep Cursor self-contained under ~/Applications (no system Electron)
        apps_dir="${HOME}/Applications"
        mkdir -p "${apps_dir}"

        # Resolve the latest AppImage URL via Cursor's update API
        cursor_url="$(curl -sIL -o /dev/null -w '%{url_effective}' \
            'https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/latest')"
        curl -fL --retry 3 -o "${apps_dir}/cursor.AppImage" "${cursor_url}"
        chmod +x "${apps_dir}/cursor.AppImage"

        # Pull the bundled icon out of the AppImage (self-extracts, no FUSE needed)
        cursor_tmp="$(mktemp -d)"
        (
            cd "${cursor_tmp}" || exit 1
            "${apps_dir}/cursor.AppImage" --appimage-extract \
                'usr/share/icons/hicolor/512x512/apps/cursor.png' >/dev/null
        )
        if [[ -f "${cursor_tmp}/squashfs-root/usr/share/icons/hicolor/512x512/apps/cursor.png" ]]; then
            install -Dm644 "${cursor_tmp}/squashfs-root/usr/share/icons/hicolor/512x512/apps/cursor.png" \
                "${HOME}/.local/share/icons/hicolor/512x512/apps/co.anysphere.cursor.png"
            cursor_icon="co.anysphere.cursor"
        else
            cursor_icon="application-x-executable"
        fi
        rm -rf "${cursor_tmp}"

        # Register the launcher entry
        mkdir -p "${HOME}/.local/share/applications"
        cat > "${HOME}/.local/share/applications/cursor.desktop" <<EOF
[Desktop Entry]
Name=Cursor
Comment=The AI Code Editor.
GenericName=Text Editor
Exec=${apps_dir}/cursor.AppImage %F
Icon=${cursor_icon}
Type=Application
StartupNotify=false
StartupWMClass=Cursor
Categories=TextEditor;Development;IDE;
MimeType=application/x-cursor-workspace;
EOF
        # Refresh the icon theme cache so the launcher picks up the new icon
        if command -v gtk-update-icon-cache >/dev/null 2>&1; then
            gtk-update-icon-cache -f -t "${HOME}/.local/share/icons/hicolor" >/dev/null 2>&1 || true
        fi
        ;;
    "LM Studio")
        echo "=> Installing LM Studio (AppImage)..."
        yay -S --noconfirm --needed lmstudio-bin
        ;;
    "OBS Studio")
        echo "=> Installing OBS Studio..."
        yay -S --noconfirm --needed obs-studio
        ;;
    Inkscape)
        echo "=> Installing Inkscape..."
        yay -S --noconfirm --needed inkscape
        ;;
    Steam)
        echo "=> Installing Steam (enabling multilib)..."
        # Steam needs the multilib repo for its 32-bit runtime
        if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
            if grep -q '^#\[multilib\]' /etc/pacman.conf; then
                sudo sed -i 's/^#\[multilib\]/[multilib]/; s|^#Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist|' /etc/pacman.conf
            else
                printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' | sudo tee -a /etc/pacman.conf >/dev/null
            fi
            sudo pacman -Sy --noconfirm
        fi
        yay -S --noconfirm --needed steam
        ;;
    esac
done <<<"${DEVSTRAP_SELECTED_OPTIONAL_APPS}"
