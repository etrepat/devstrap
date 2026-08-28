#!/usr/bin/env bash
# prepare-config.sh — Pre-flight helper for the devstrap archinstall flow.
#
# Run this from the archinstall live environment, inside the directory where you
# downloaded user_configuration.json / user_credentials.json. It inspects the
# machine, rewrites both files with sane values and asks for the account
# credentials so archinstall can run unattended:
#
#   bash prepare-config.sh [--config PATH] [--creds PATH] [options]
#
# Detection:
#   * target disk   — the only non-removable disk, excluding the live medium
#   * graphics      — from lspci, mapped onto archinstall's GfxDriver values
#
# Overrides:
#   --disk /dev/X        force the target disk
#   --gfx "driver name"  force the graphics driver string
#   --user NAME          skip the username prompt
#   --non-interactive    read passwords from DEVSTRAP_USER_PASSWORD /
#                        DEVSTRAP_ROOT_PASSWORD (implies --user)

set -euo pipefail

CONFIG="user_configuration.json"
CREDS="user_credentials.json"
DISK=""
GFX=""
USERNAME=""
NON_INTERACTIVE=false

usage() {
    sed -n '2,20p' "${0}" | sed 's/^# \{0,1\}//'
    exit 0
}

die() {
    echo -e "\e[31;1mError:\e[0m ${1}" >&2
    exit 1
}

info() {
    echo -e "\e[33;1m~>\e[0m ${1}"
}

while [[ $# -gt 0 ]]; do
    case "${1}" in
        --config) CONFIG="${2}"; shift 2 ;;
        --creds) CREDS="${2}"; shift 2 ;;
        --disk) DISK="${2}"; shift 2 ;;
        --gfx) GFX="${2}"; shift 2 ;;
        --user) USERNAME="${2}"; shift 2 ;;
        --non-interactive) NON_INTERACTIVE=true; shift ;;
        -h|--help) usage ;;
        *) die "Unknown option: ${1}" ;;
    esac
done

[[ -f "${CONFIG}" ]] || die "Config file not found: ${CONFIG} (download it first)"
[[ -f "${CREDS}" ]] || die "Credentials file not found: ${CREDS} (download it first)"

command -v jq >/dev/null 2>&1 || {
    info "jq not found, installing it..."
    pacman -Sy --noconfirm --needed jq >/dev/null
}

# --------------------------------------------------------------------------
# Disk detection
# --------------------------------------------------------------------------
detect_disk() {
    local live_src live_node="" parent candidates

    live_src="$(findmnt -nr -o SOURCE /run/archiso/airootfs 2>/dev/null || true)"
    if [[ -n "${live_src}" ]]; then
        live_node="${live_src##*/}"
        while [[ -n "${live_node}" ]]; do
            parent="$(lsblk -rno PKNAME "/dev/${live_node}" 2>/dev/null | tr -d '[:space:]' || true)"
            [[ -z "${parent}" ]] && break
            live_node="${parent}"
        done
        info "Excluding live medium: /dev/${live_node}"
    fi

    candidates="$(lsblk -dpno NAME,TYPE,RM | awk '$2=="disk" && $3==0 && $1 !~ /\/dev\/zram/ {print $1}' | grep -v "^/dev/${live_node}$" || true)"
    candidates="$(echo "${candidates}" | grep . || true)"

    mapfile -t candidates <<<"${candidates}"
    case "${#candidates[@]}" in
        0) die "No non-removable disks found. Use --disk /dev/X to force a target." ;;
        1) DISK="${candidates[0]}" ;;
        *)
            echo "Multiple disks detected. Pick the install target:"
            local i=1
            for c in "${candidates[@]}"; do echo "  ${i}) ${c}"; i=$((i + 1)); done
            local pick
            read -rp "Choice [1-${#candidates[@]}]: " pick
            if [[ "${pick}" =~ ^[0-9]+$ ]] && (( pick >= 1 )) && (( pick <= ${#candidates[@]} )); then
                DISK="${candidates[$((pick - 1))]}"
            else
                die "Invalid choice: ${pick}"
            fi
            ;;
    esac
}

if [[ -z "${DISK}" ]]; then
    detect_disk
fi
[[ -b "${DISK}" ]] || die "Disk not found: ${DISK}"
info "Target disk: ${DISK}"

disk_bytes="$(lsblk -bdno SIZE "${DISK}")"
if (( disk_bytes < 110 * 1024 * 1024 * 1024 )); then
    echo -e "\e[31;1mWarning:\e[0m ${DISK} is under ~110 GiB; the layout needs a 100 GiB root partition."
fi

# --------------------------------------------------------------------------
# Graphics driver detection
# --------------------------------------------------------------------------
detect_gfx() {
    local line
    if ! command -v lspci >/dev/null 2>&1; then
        GFX=""
        return
    fi
    line="$(lspci 2>/dev/null | grep -E 'VGA|3D' | head -1)"
    case "${line}" in
        *VMware*|*QXL*|*VirtualBox*|*Red\ Hat*|*virtio*) GFX="VirtualBox (open-source)" ;;
        *AMD*|*ATI*|*Radeon*) GFX="AMD / ATI (open-source)" ;;
        *Intel*) GFX="Intel (open-source)" ;;
        *NVIDIA*|*nvidia*) GFX="Nvidia (open kernel module for newer GPUs, Turing+)" ;;
        *) GFX="" ;;
    esac
    [[ -n "${GFX}" ]] && info "Detected graphics: ${GFX}"
}

if [[ -z "${GFX}" ]]; then
    detect_gfx
fi
if [[ -z "${GFX}" ]]; then
    GFX="$(jq -r '.profile_config.gfx_driver // "All open-source"' "${CONFIG}")"
    info "Could not map GPU to a driver; keeping '${GFX}'."
fi
info "Graphics driver: ${GFX}"

# --------------------------------------------------------------------------
# Credentials
# --------------------------------------------------------------------------
prompt_secret() {
    local label="${1}" value confirm
    while :; do
        read -rsp "${label}: " value; echo
        read -rsp "Confirm ${label}: " confirm; echo
        [[ "${value}" == "${confirm}" && -n "${value}" ]] && break
        echo "Mismatch or empty, try again."
    done
    echo "${value}"
}

if ${NON_INTERACTIVE}; then
    [[ -n "${USERNAME}" ]] || die "--non-interactive requires --user NAME"
    local_pw="${DEVSTRAP_USER_PASSWORD:-}"
    root_pw="${DEVSTRAP_ROOT_PASSWORD:-}"
    [[ -n "${local_pw}" ]] || die "--non-interactive requires DEVSTRAP_USER_PASSWORD"
    [[ -n "${root_pw}" ]] || die "--non-interactive requires DEVSTRAP_ROOT_PASSWORD"
else
    if [[ -z "${USERNAME}" ]]; then
        read -rp "Username [etrepat]: " USERNAME
        USERNAME="${USERNAME:-etrepat}"
    fi
    local_pw="$(prompt_secret "Password for ${USERNAME}")"
    root_pw="$(prompt_secret "Root password")"
fi

[[ "${USERNAME}" =~ ^[a-z_][a-z0-9_-]*$ ]] || die "Invalid username: ${USERNAME}"
info "Account: ${USERNAME} (sudo)"

# --------------------------------------------------------------------------
# Rewrite the configuration files
# --------------------------------------------------------------------------
tmp_cfg="$(mktemp)"
trap 'rm -f "${tmp_cfg}"' EXIT

jq \
    --arg u "${USERNAME}" \
    --arg disk "${DISK}" \
    --arg gfx "${GFX}" \
    '.disk_config.device_modifications[0].device = $disk
     | .profile_config.gfx_driver = $gfx
     | .custom_commands = (.custom_commands | map(
         gsub("/home/etrepat"; ("/home/" + $u))
         | gsub("runuser -u etrepat"; ("runuser -u " + $u))
         | gsub("-o etrepat -g etrepat"; ("-o " + $u + " -g " + $u))
       ))' \
    "${CONFIG}" > "${tmp_cfg}"
mv "${tmp_cfg}" "${CONFIG}"

jq -n \
    --arg u "${USERNAME}" \
    --arg lpw "${local_pw}" \
    --arg rpw "${root_pw}" \
    '{users: [{username: $u, "!password": $lpw, sudo: true}], "!root-password": $rpw}' \
    > "${CREDS}"

info "Config ready: ${CONFIG} / ${CREDS}"
info "Next: archinstall --config ${CONFIG} --creds ${CREDS}"