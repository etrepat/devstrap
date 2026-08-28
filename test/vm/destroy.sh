#!/usr/bin/env bash
# destroy.sh — Tear down the devstrap test VM and its transient network.
# Removes the VM definition, the disk image and the NAT network, leaving no
# host-side footprint.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$(dirname "${SCRIPT_DIR}")")"

VM="${VM:-devstrap-vm}"
NET="devstrap-vm-net"
URI="qemu:///system"
VIRSH="virsh -c ${URI}"
IMG="${REPO_ROOT}/.vmtest/images/${VM}.qcow2"

if ${VIRSH} dominfo "${VM}" >/dev/null 2>&1; then
    echo "~> Destroying VM ${VM}..."
    ${VIRSH} destroy "${VM}" >/dev/null 2>&1 || true
    ${VIRSH} undefine "${VM}" --nvram >/dev/null 2>&1 || true
fi

if ${VIRSH} net-info "${NET}" >/dev/null 2>&1; then
    echo "~> Destroying network ${NET}..."
    ${VIRSH} net-destroy "${NET}" >/dev/null 2>&1 || true
fi

[[ -f "${IMG}" ]] && rm -f "${IMG}" && echo "~> Removed ${IMG}"

echo "~> Done."