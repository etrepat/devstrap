#!/usr/bin/env bash
# setup.sh — Provision the devstrap test VM (KVM/libvirt).
#
# Everything user-facing lives under $REPO/.vmtest/ (gitignored). The only
# host-side footprint is a transient NAT network and the VM definition, both
# removed by destroy.sh.
#
# Usage: bash test/vm/setup.sh [--ram MiB] [--vcpus N] [--disk GiB] [--name NAME]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "${SCRIPT_DIR}")")"

VM="${VM:-devstrap-vm}"
NET="devstrap-vm-net"
URI="qemu:///system"
VIRSH="virsh -c ${URI}"
RAM=8192
VCPUS=4
DISK_SIZE=120

while [[ $# -gt 0 ]]; do
    case "${1}" in
        --ram) RAM="${2}"; shift 2 ;;
        --vcpus) VCPUS="${2}"; shift 2 ;;
        --disk) DISK_SIZE="${2}"; shift 2 ;;
        --name) VM="${2}"; shift 2 ;;
        *) echo "Unknown option: ${1}" >&2; exit 1 ;;
    esac
done

ISO_DIR="${REPO_ROOT}/.vmtest/iso"
IMG_DIR="${REPO_ROOT}/.vmtest/images"
ISO="${ISO_DIR}/archlinux-x86_64.iso"
IMG="${IMG_DIR}/${VM}.qcow2"

mkdir -p "${ISO_DIR}" "${IMG_DIR}"

for cmd in virt-install virsh curl; do
    command -v "${cmd}" >/dev/null 2>&1 || { echo "Missing dependency: ${cmd}" >&2; exit 1; }
done

# virt-install's shebang is `#!/usr/bin/env python3`; make sure the interpreter
# that provides `gi` (python-gobject) wins over any user virtualenv.
if ! python3 -c 'import gi' >/dev/null 2>&1; then
    if /usr/bin/python3 -c 'import gi' >/dev/null 2>&1; then
        export PATH="/usr/bin:${PATH}"
    else
        echo "python-gobject (gi) not available; cannot run virt-install" >&2
        exit 1
    fi
fi

[[ -e /dev/kvm ]] || { echo "/dev/kvm not available" >&2; exit 1; }

# --- ISO -------------------------------------------------------------------
if [[ ! -f "${ISO}" ]]; then
    echo "~> Downloading Arch Linux ISO (~1 GiB)..."
    curl -fLo "${ISO}" 'https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso' \
        || curl -fLo "${ISO}" 'https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso' \
        || { rm -f "${ISO}"; echo "ISO download failed" >&2; exit 1; }
else
    echo "~> ISO present: ${ISO}"
fi

# --- Network ---------------------------------------------------------------
if ! ${VIRSH} net-info "${NET}" >/dev/null 2>&1; then
    echo "~> Creating transient NAT network: ${NET}"
    ${VIRSH} net-create "${SCRIPT_DIR}/net.xml" >/dev/null
else
    echo "~> Network already present: ${NET}"
fi

# --- VM --------------------------------------------------------------------
if ${VIRSH} dominfo "${VM}" >/dev/null 2>&1; then
    echo "~> VM already exists: ${VM}"
else
    echo "~> Creating VM ${VM} (${RAM} MiB, ${VCPUS} vCPU, ${DISK_SIZE} GiB SATA, UEFI)..."
    virt-install \
        --connect "${URI}" \
        --name "${VM}" \
        --memory "${RAM}" \
        --vcpus "${VCPUS}" \
        --cpu host-passthrough \
        --os-variant archlinux \
        --disk path="${IMG}",size="${DISK_SIZE}",format=qcow2,bus=sata \
        --cdrom "${ISO}" \
        --network network="${NET}",model=virtio \
        --graphics spice,listen=127.0.0.1 \
        --video qxl \
        --boot uefi,firmware_feature0.name=secure-boot,firmware_feature0.enabled=no \
        --noautoconsole \
        >/dev/null
fi

echo
echo "======================================================================"
echo " VM ready. Next steps:"
echo "   1) Open the console:  bash ${SCRIPT_DIR}/open.sh"
echo "   2) Inside the live ISO, fetch the published configs + helper:"
echo "      curl -sSfO https://raw.githubusercontent.com/etrepat/devstrap/master/archinstall/user_configuration.json"
echo "      curl -sSfO https://raw.githubusercontent.com/etrepat/devstrap/master/archinstall/user_credentials.json"
echo "      curl -sSfO https://raw.githubusercontent.com/etrepat/devstrap/master/archinstall/prepare-config.sh"
echo "   3) bash prepare-config.sh  ->  archinstall --config user_configuration.json --creds user_credentials.json"
echo "======================================================================"