#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ROOT="${HOME}/.config"
CODEX_ROOT="${HOME}/.codex"
NEW_CONFIG="${REPO_ROOT}/config"

CONFIG_DIRS=(aerospace ghostty nvim zed opencode codexbar linearmouse)
CONFIG_FILES=(starship.toml)
CODEX_DIRS=(agents rules)
CODEX_FILES=(AGENTS.md config.toml)
CODEX_NESTED_FILES=(browser/config.toml computer-use/config.json)
usage() {
  cat <<'EOF'
Usage: ./dotfiles.sh [sync|link|both]

  sync  Copy the live authored configuration into config/
  link  Link config/ back into the live configuration paths
  both  Run sync, then link
EOF
}

is_canonical_link() {
  local src="$1"
  local dst="$2"
  [[ -L "$src" && "$(readlink "$src")" == "$dst" ]]
}

trash_existing() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    /usr/bin/trash "$path"
  fi
}

sync_dir() {
  local name="$1"
  local src="${CONFIG_ROOT}/${name}"
  local dst="${NEW_CONFIG}/${name}"

  if [[ ! -d "$src" && ! -L "$src" ]]; then
    echo "skip sync: ${src} not found"
    return
  fi

  if is_canonical_link "$src" "$dst"; then
    echo "skip sync: ${name} already canonical"
    return
  fi

  mkdir -p "$dst"
  rsync -aL --delete --exclude 'node_modules/' --exclude 'prompts/' --exclude '*.mdb' "$src/" "$dst/"
  echo "synced ${name}"
}

sync_file() {
  local name="$1"
  local src="${CONFIG_ROOT}/${name}"
  local dst="${NEW_CONFIG}/${name}"

  if [[ ! -f "$src" && ! -L "$src" ]]; then
    echo "skip sync: ${src} not found"
    return
  fi

  if is_canonical_link "$src" "$dst"; then
    echo "skip sync: ${name} already canonical"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  rsync -aL "$src" "$dst"
  echo "synced ${name}"
}

sync_codex_dir() {
  local name="$1"
  local src="${CODEX_ROOT}/${name}"
  local dst="${NEW_CONFIG}/codex/${name}"

  if [[ ! -d "$src" && ! -L "$src" ]]; then
    echo "skip sync: ${src} not found"
    return
  fi

  if is_canonical_link "$src" "$dst"; then
    echo "skip sync: codex/${name} already canonical"
    return
  fi

  mkdir -p "$dst"
  rsync -aL --delete "$src/" "$dst/"
  echo "synced codex/${name}"
}

sync_codex_file() {
  local name="$1"
  local src="${CODEX_ROOT}/${name}"
  local dst="${NEW_CONFIG}/codex/${name}"

  if [[ ! -f "$src" && ! -L "$src" ]]; then
    echo "skip sync: ${src} not found"
    return
  fi

  if is_canonical_link "$src" "$dst"; then
    echo "skip sync: codex/${name} already canonical"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  rsync -aL "$src" "$dst"
  echo "synced codex/${name}"
}

link_path() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    echo "skip link: ${src} not found"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  trash_existing "$dst"
  ln -s "$src" "$dst"
  echo "linked ${dst} -> ${src}"
}

run_sync() {
  local name
  mkdir -p "$NEW_CONFIG"
  for name in "${CONFIG_DIRS[@]}"; do
    sync_dir "$name"
  done
  for name in "${CONFIG_FILES[@]}"; do
    sync_file "$name"
  done

  if [[ -f "${CONFIG_ROOT}/gh/config.yml" ]]; then
    if is_canonical_link "${CONFIG_ROOT}/gh/config.yml" "${NEW_CONFIG}/gh/config.yml"; then
      echo "skip sync: gh/config.yml already canonical"
    else
      mkdir -p "${NEW_CONFIG}/gh"
      rsync -aL "${CONFIG_ROOT}/gh/config.yml" "${NEW_CONFIG}/gh/config.yml"
      echo "synced gh/config.yml"
    fi
  fi

  for name in "${CODEX_DIRS[@]}"; do
    sync_codex_dir "$name"
  done
  for name in "${CODEX_FILES[@]}" "${CODEX_NESTED_FILES[@]}"; do
    sync_codex_file "$name"
  done
}

run_link() {
  local name
  for name in "${CONFIG_DIRS[@]}"; do
    link_path "${NEW_CONFIG}/${name}" "${CONFIG_ROOT}/${name}"
  done
  for name in "${CONFIG_FILES[@]}"; do
    link_path "${NEW_CONFIG}/${name}" "${CONFIG_ROOT}/${name}"
  done
  if [[ -f "${NEW_CONFIG}/gh/config.yml" ]]; then
    link_path "${NEW_CONFIG}/gh/config.yml" "${CONFIG_ROOT}/gh/config.yml"
  fi

  for name in "${CODEX_DIRS[@]}"; do
    link_path "${NEW_CONFIG}/codex/${name}" "${CODEX_ROOT}/${name}"
  done
  for name in "${CODEX_FILES[@]}" "${CODEX_NESTED_FILES[@]}"; do
    link_path "${NEW_CONFIG}/codex/${name}" "${CODEX_ROOT}/${name}"
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
