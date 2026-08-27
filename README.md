# DevStrap - Arch Linux (x64, GNOME desktop)

DevStrap is a bash script that rapidly sets up a fresh Arch (GNOME desktop) system with a fully-configured development environment.

## ✅ Compatibility

DevStrap currently supports the following 64-bit Linux distributions. The active version is maintained on the `master`
branch with a dedicated installation script. **We strongly recommend reviewing the script before executing it on your system.**

* **Arch Linux (x64, GNOME desktop)** — actively maintained
    → [View installation script](https://github.com/etrepat/devstrap/tree/master/install.sh)
    → [Go to the `master` branch](https://github.com/etrepat/devstrap/tree/master)

## 🚀 Installation

### Option 1 — classic post-install script (recommended)

1. Download the latest [Arch Linux ISO](https://archlinux.org/download/) and boot into it.
2. Run `archinstall`, selecting the **Desktop profile** and choosing **GNOME** as the desktop environment. Feel free to
customize the installation as needed.
3. Once the system is installed and running, open a terminal and execute:

```bash
curl -sSf 'https://raw.githubusercontent.com/etrepat/devstrap/master/install.sh' | bash
```

### Option 2 — archinstall

DevStrap ships a ready-made [archinstall](https://wiki.archlinux.org/title/Archinstall) configuration
(`archinstall/user_configuration.json`) pre-filled with modern defaults: **GNOME**, **NetworkManager**, **btrfs** with
`@`/`@home`/`@log`/`@pkg` subvolumes and **Timeshift** snapshots, systemd-boot, PipeWire, zram swap, and more. On the
first login after install it automatically launches the devstrap bootstrap TUI.

1. Download the latest [Arch Linux ISO](https://archlinux.org/download/) and boot into it.
2. Fetch the configuration and the credentials template:

   ```bash
   curl -sSfO 'https://raw.githubusercontent.com/etrepat/devstrap/master/archinstall/user_configuration.json'
   curl -sSfO 'https://raw.githubusercontent.com/etrepat/devstrap/master/archinstall/user_credentials.json'
   ```

3. Edit both files:
   - `user_credentials.json` — set your `username` (must match the one used in `custom_commands`, default `etrepat`)
     and replace the `CHANGE_ME` passwords.
   - `user_configuration.json` — adjust the `disk_config` device (default `/dev/sda`) and root partition size to your
     machine. The custom commands reference the username; keep it in sync with your credentials.
4. Run the installer:

   ```bash
   archinstall --config user_configuration.json --creds user_credentials.json
   ```

5. Review the pre-filled answers in the archinstall menu (especially the disk layout) and confirm. When the system
   boots and you log in for the first time, devstrap opens a terminal and runs itself automatically. Reboot at the end
   when it's done.

## 🛠 What It Does

DevStrap automates the process of turning a clean Linux installation into a well-equipped development machine. It
applies a number of opinionated configurations and installs a curated set of tools and applications.

### Included by default

* **Terminal emulators:** [ghostty](https://github.com/ghostty/ghostty)
* **Shell:** Bash with an opinionated custom configuration & [starship.rs](https://starship.rs/) prompt.
* **Languages & build tools:** Ruby, Go, Java, PHP, Rust, and more
* **Core utilities:** curl, git, wl-clipboard, imagemagick, etc.
* **Editor:** pick at install time between [Visual Studio Code](https://code.visualstudio.com/), [Zed](https://zed.dev/) and [Neovim](https://neovim.io/). Each is preconfigured with a matching theme (Catppuccin Mocha), base tooling and language support for your selected languages.
* **Desktop apps:** Albert launcher, Dropbox, Flameshot, Google Chrome / Firefox, and others
* **SSH setup:** Generates a public/private key pair if one doesn't already exist

🔍 For a complete list of installed packages and applied configurations, see the `install.d` directory.

## License

DevStrap is released under the [MIT License](https://opensource.org/licenses/MIT).
