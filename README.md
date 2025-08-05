# DevStrap - Manjaro (x64, GNOME desktop)

DevStrap is a bash script that rapidly sets up a fresh Manjaro (GNOME desktop) system with a fully-configured development environment.

## ✅ Compatibility

DevStrap currently supports the following 64-bit Linux distributions. Each version is maintained in its own branch
with a dedicated installation script. **We strongly recommend reviewing the script before executing it on your system.**

* **Manjaro (x64, GNOME desktop)**
    → [View installation script](https://github.com/etrepat/devstrap/tree/manjaro/install.sh)
    → [Go to the `manjaro` branch](https://github.com/etrepat/devstrap/tree/manjaro)
* Arch Linux (x64, GNOME desktop)
    → [View installation script](https://github.com/etrepat/devstrap/tree/archlinux/install.sh)
    → [Go to the `archlinux` branch](https://github.com/etrepat/devstrap/tree/archlinux)
* Ubuntu 24.04 LTS (Jammy Jellyfish)
    → [View installation script](https://github.com/etrepat/devstrap/tree/ubuntu/install.sh)
    → [Go to the `ubuntu` branch](https://github.com/etrepat/devstrap/tree/ubuntu)

## 🚀 Installation

1. Download the latest [Manjaro Linux GNOME ISO](https://manjaro.org/products/download/x86) and boot into it.
2. Perform the installation process. Feel free to customize the installation as needed.
3. Once the system is installed and running, open a terminal and execute:

```bash
curl -sSf 'https://raw.githubusercontent.com/etrepat/devstrap/manjaro/install.sh' | bash
```

## 🛠 What It Does

DevStrap automates the process of turning a clean Linux installation into a well-equipped development machine. It
applies a number of opinionated configurations and installs a curated set of tools and applications.

### Included by default

* **Terminal emulators:** [kitty](https://sw.kovidgoyal.net/kitty/) or [ghostty](https://github.com/ghostty/ghostty)
* **Shell:** Bash with an opinionated custom configuration & [starship.rs](https://starship.rs/) prompt.
* **Languages & build tools:** Ruby, Go, Java, PHP, Rust, and more
* **Core utilities:** curl, git, xclip, imagemagick, etc.
* **Editor:** Visual Studio Code, preconfigured with a theme and a basic extension set
* **Desktop apps:** Albert launcher, Dropbox, Flameshot, Google Chrome / Firefox, and others
* **SSH setup:** Generates a public/private key pair if one doesn't already exist

🔍 For a complete list of installed packages and applied configurations, see the `install.d` directory.

## License

DevStrap is released under the [MIT License](https://opensource.org/licenses/MIT).
