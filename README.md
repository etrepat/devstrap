# DevStrap - Ubuntu 24.04 LTS (Jammy Jellyfish)

DevStrap is a bash script that rapidly sets up a fresh Ubuntu box system with a fully-configured development environment.

## ✅ Compatibility

DevStrap currently supports the following 64-bit Linux distributions. Each version is maintained in its own branch 
with a dedicated installation script. **We strongly recommend reviewing the script before executing it on your system.**

* **Ubuntu 24.04 LTS (Jammy Jellyfish)**
    → [View installation script](https://github.com/etrepat/devstrap/tree/ubuntu/install.sh)
    → [Go to the `ubuntu` branch](https://github.com/etrepat/devstrap/tree/ubuntu)
* Arch Linux (x64, GNOME desktop)
    → [View installation script](https://github.com/etrepat/devstrap/tree/archlinux/install.sh)
    → [Go to the `archlinux` branch](https://github.com/etrepat/devstrap/tree/archlinux)

## 🚀 Installation

1. Download the [Ubuntu 24.04 LTS ISO](https://releases.ubuntu.com/24.04/) and install the **Desktop** edition.
2. Once installation is complete, open a terminal and run:

```bash
curl -sSf 'https://raw.githubusercontent.com/etrepat/devstrap/ubuntu/install.sh' | bash
```

## 🛠 What It Does

DevStrap automates the process of turning a clean Ubuntu installation into a well-equipped development machine. It 
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
