#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# run.sh — setup, preview, and build your Quarto + static dashboard site
# =============================================================================

# Configuration
VENV_DIR=".venv"
REQ_FILE="requirements.txt"

# Absolute path to this script’s directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Usage helper
usage() {
  cat <<EOF
Usage: $0 <command>

Commands:
  setup      Create a project‐local venv and install Python deps
  preview    Spin up Quarto’s live preview server
  build      Render the entire site to static HTML

Examples:
  $0 setup
  $0 preview
  $0 build
EOF
  exit 1
}

# =============================================================================
# Commands
# =============================================================================

do_setup() {
  echo "🛠  Setting up Python venv in '${VENV_DIR}'…"
  python3 -m venv "${VENV_DIR}"
  source "${VENV_DIR}/bin/activate"
  if [[ -f "${REQ_FILE}" ]]; then
    echo "📦 Installing Python dependencies from ${REQ_FILE}…"
    pip install --upgrade pip
    pip install -r "${REQ_FILE}"
    pip install jupyter ipykernel
  else
    echo "⚠️  No ${REQ_FILE} found—skipping pip install"
  fi
  echo "✅  Setup complete. Activate with 'source ${VENV_DIR}/bin/activate'"
}

do_preview() {
  if [[ ! -d "${VENV_DIR}" ]]; then
    echo "❗ venv not found. Please run '$0 setup' first." >&2
    exit 1
  fi
  echo "👀  Launching Quarto preview…"
  source "${VENV_DIR}/bin/activate"
  quarto preview
}

do_build() {
  if [[ ! -d "${VENV_DIR}" ]]; then
    echo "❗ venv not found. Please run '$0 setup' first." >&2
    exit 1
  fi
  echo "📦  Rendering site to static HTML…"
  source "${VENV_DIR}/bin/activate"
  quarto render
  echo "✅  Build complete. Check the output directory (by default '_site' or 'docs')."
}

# =============================================================================
# Dispatch
# =============================================================================

if [[ $# -ne 1 ]]; then
  usage
fi

case "$1" in
  setup)   do_setup    ;;
  preview) do_preview  ;;
  build)   do_build    ;;
  *)        usage      ;;
esac
