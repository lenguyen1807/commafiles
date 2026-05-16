#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ROOT="${HOME}/.config"
TARGETS=(nvim aerospace ghostty)

usage() {
  cat <<'EOF'
Usage: ./dotfiles.sh [sync|link|both]

  sync  Copy ~/.config/{nvim,aerospace,ghostty} -> new_config/
  link  Symlink new_config/{nvim,aerospace,ghostty} -> ~/.config/
  both  Run sync, then link
EOF
}

sync_one() {
  local name="$1"
  local src="${CONFIG_ROOT}/${name}/"
  local dst="${REPO_ROOT}/new_config/${name}/"

  if [[ ! -d "$src" ]]; then
    echo "skip sync: ${src} not found"
    return
  fi

  mkdir -p "$dst"
  rsync -a --delete "$src" "$dst"
  echo "synced ${name}"
}

link_one() {
  local name="$1"
  local src="${REPO_ROOT}/new_config/${name}"
  local dst="${CONFIG_ROOT}/${name}"
  local ts

  if [[ ! -d "$src" ]]; then
    echo "skip link: ${src} not found"
    return
  fi

  mkdir -p "$CONFIG_ROOT"

  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    ts="$(date +%Y%m%d-%H%M%S)"
    mv "$dst" "${dst}.bak.${ts}"
    echo "backed up ${dst} -> ${dst}.bak.${ts}"
  fi

  ln -s "$src" "$dst"
  echo "linked ${dst} -> ${src}"
}

run_sync() {
  local name
  for name in "${TARGETS[@]}"; do
    sync_one "$name"
  done
}

run_link() {
  local name
  for name in "${TARGETS[@]}"; do
    link_one "$name"
  done
}

case "${1:-}" in
sync)
  run_sync
  ;;
link)
  run_link
  ;;
both)
  run_sync
  run_link
  ;;
*)
  usage
  exit 1
  ;;
esac
