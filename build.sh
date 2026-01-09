#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/.build"

# Check we're in nix shell
if [[ -z "${QMK_SOURCE:-}" ]]; then
    echo "Error: Run this from 'nix develop' shell or use direnv"
    echo "  cd ${SCRIPT_DIR}"
    echo "  direnv allow  # or: nix develop"
    echo "  ./build.sh"
    exit 1
fi

# Clean previous build
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# Copy QMK source
echo "==> Copying QMK source..."
cp -r "${QMK_SOURCE}"/* "${BUILD_DIR}/"
chmod -R u+w "${BUILD_DIR}"

# Copy keymap from local directory (not Nix store)
echo "==> Copying finger_zones keymap..."
mkdir -p "${BUILD_DIR}/keyboards/framework/ansi/keymaps/finger_zones"
cp "${SCRIPT_DIR}/keymaps/finger_zones"/* "${BUILD_DIR}/keyboards/framework/ansi/keymaps/finger_zones/"

# Build
echo "==> Building firmware..."
cd "${BUILD_DIR}"
export QMK_HOME="${BUILD_DIR}"
make framework/ansi:finger_zones SKIP_GIT=1

# Copy result
cp framework_ansi_finger_zones.uf2 "${SCRIPT_DIR}/"
echo ""
echo "==> Success: ${SCRIPT_DIR}/framework_ansi_finger_zones.uf2"
