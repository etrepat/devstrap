#!/usr/bin/env bash
# open.sh — Open the devstrap test VM console in virt-manager.

set -euo pipefail

VM="${VM:-devstrap-vm}"

virsh -c qemu:///system dominfo "${VM}" >/dev/null 2>&1 || { echo "VM not found: ${VM}. Run setup.sh first." >&2; exit 1; }

virt-manager --connect qemu:///system --show-domain-console "${VM}"