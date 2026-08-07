#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ROOT="${HOME}/.config"
CODEX_ROOT="${HOME}/.codex"
PI_AGENT_ROOT="${HOME}/.pi/agent"
NEW_CONFIG="${REPO_ROOT}/config"
ZSHRC_SRC="${REPO_ROOT}/.zshrc"
ZSHRC_DST="${HOME}/.zshrc"
LOCAL_BIN="${HOME}/.local/bin"
STARSHIP_PRESET="gruvbox-rainbow"

CONFIG_DIRS=(aerospace ghostty nvim zed opencode codexbar linearmouse)
CONFIG_FILES=(starship.toml)
CODEX_DIRS=(agents rules)
CODEX_FILES=(AGENTS.md config.toml)
CODEX_NESTED_FILES=(browser/config.toml computer-use/config.json)
PI_DIRS=(skills extensions)
PI_FILES=(settings.json zentui.json subagents.json pi-latex.json)

usage() {
  cat <<'EOF'
Usage: ./dotfiles.sh [install|sync|link|both]

  install  Bootstrap tools (oh-my-zsh, starship, Cursor CLI, Codex, Rust,
           Xcode components), wire .zshrc, apply starship preset, then link
  sync     Copy the live authored configuration into config/
  link     Link config/ (and .zshrc) back into the live configuration paths
  both     Run sync, then link
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

ensure_path_dirs() {
  mkdir -p "${HOME}/bin" "$LOCAL_BIN" "$CONFIG_ROOT"
}

install_oh_my_zsh() {
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    echo "skip install: oh-my-zsh already present"
    return
  fi

  echo "installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_starship() {
  ensure_path_dirs
  export PATH="${LOCAL_BIN}:${PATH}"

  if command -v starship >/dev/null 2>&1; then
    echo "skip install: starship already present ($(command -v starship))"
    return
  fi

  echo "installing starship into ${LOCAL_BIN}"
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$LOCAL_BIN"
}

install_cursor_cli() {
  ensure_path_dirs
  export PATH="${LOCAL_BIN}:${PATH}"

  if [[ -x "${LOCAL_BIN}/agent" ]]; then
    echo "skip install: Cursor CLI already present (${LOCAL_BIN}/agent)"
    return
  fi

  echo "installing Cursor CLI"
  curl https://cursor.com/install -fsS | bash
}

install_codex() {
  ensure_path_dirs
  export PATH="${LOCAL_BIN}:${PATH}"

  if [[ -x "${LOCAL_BIN}/codex" ]]; then
    echo "skip install: Codex already present (${LOCAL_BIN}/codex)"
    return
  fi

  echo "installing Codex into ${LOCAL_BIN}"
  CODEX_NON_INTERACTIVE=1 CODEX_INSTALL_DIR="$LOCAL_BIN" \
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
}

install_rust() {
  ensure_path_dirs
  export PATH="${HOME}/.cargo/bin:${PATH}"

  if command -v rustup >/dev/null 2>&1; then
    echo "skip install: Rust already present ($(command -v rustup))"
    return
  fi

  echo "installing Rust (rustup)"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}

install_xcode_components() {
  local xcode_dev="/Applications/Xcode.app/Contents/Developer"
  local metal_status

  if [[ ! -d "$xcode_dev" ]]; then
    echo "skip install: Xcode.app not found at /Applications/Xcode.app"
    echo "  install Xcode from the App Store, then re-run: ./dotfiles.sh install"
    return
  fi

  if [[ "$(xcode-select -p 2>/dev/null || true)" != "$xcode_dev" ]]; then
    echo "selecting Xcode developer directory"
    sudo xcode-select -s "$xcode_dev"
  fi

  echo "accepting Xcode license / running first-launch tasks"
  sudo xcodebuild -license accept >/dev/null
  xcodebuild -runFirstLaunch

  metal_status="$(xcodebuild -showComponent metalToolchain 2>/dev/null | awk -F': ' '/^Status:/{print $2; exit}' || true)"
  if [[ "$metal_status" == "installed" ]]; then
    echo "skip install: Metal Toolchain already installed"
  else
    echo "installing Metal Toolchain"
    xcodebuild -downloadComponent MetalToolchain
  fi

  echo "checking for newer Xcode device-support components"
  xcodebuild -runFirstLaunch -checkForNewerComponents || true
}

apply_starship_preset() {
  ensure_path_dirs
  export PATH="${LOCAL_BIN}:${PATH}"

  if ! command -v starship >/dev/null 2>&1; then
    echo "error: starship not found on PATH" >&2
    exit 1
  fi

  # Write into the repo canonical file, then link will expose it at ~/.config.
  mkdir -p "$NEW_CONFIG"
  starship preset "$STARSHIP_PRESET" -f -o "${NEW_CONFIG}/starship.toml"
  echo "applied starship preset ${STARSHIP_PRESET} -> ${NEW_CONFIG}/starship.toml"
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

sync_pi_dir() {
  local name="$1"
  local src="${PI_AGENT_ROOT}/${name}"
  local dst="${NEW_CONFIG}/pi/.pi/${name}"

  if [[ ! -d "$src" && ! -L "$src" ]]; then
    echo "skip sync: pi ${name} not found at ${src}"
    return
  fi

  if is_canonical_link "$src" "$dst"; then
    echo "skip sync: pi/${name} already canonical"
    return
  fi

  mkdir -p "$dst"
  rsync -aL --delete --exclude 'node_modules/' "$src/" "$dst/"
  echo "synced pi/${name}"
}

sync_pi_file() {
  local name="$1"
  local src="${PI_AGENT_ROOT}/${name}"
  local dst="${NEW_CONFIG}/pi/.pi/${name}"

  if [[ ! -f "$src" && ! -L "$src" ]]; then
    echo "skip sync: pi ${name} not found at ${src}"
    return
  fi

  if is_canonical_link "$src" "$dst"; then
    echo "skip sync: pi/${name} already canonical"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  rsync -aL "$src" "$dst"
  echo "synced pi/${name}"
}

sync_zshrc() {
  if [[ ! -f "$ZSHRC_DST" && ! -L "$ZSHRC_DST" ]]; then
    echo "skip sync: ${ZSHRC_DST} not found"
    return
  fi

  if is_canonical_link "$ZSHRC_DST" "$ZSHRC_SRC"; then
    echo "skip sync: .zshrc already canonical"
    return
  fi

  rsync -aL "$ZSHRC_DST" "$ZSHRC_SRC"
  echo "synced .zshrc"
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
  sync_zshrc

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

  for name in "${PI_DIRS[@]}"; do
    sync_pi_dir "$name"
  done
  for name in "${PI_FILES[@]}"; do
    sync_pi_file "$name"
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
  link_path "$ZSHRC_SRC" "$ZSHRC_DST"
  if [[ -f "${NEW_CONFIG}/gh/config.yml" ]]; then
    link_path "${NEW_CONFIG}/gh/config.yml" "${CONFIG_ROOT}/gh/config.yml"
  fi

  for name in "${CODEX_DIRS[@]}"; do
    link_path "${NEW_CONFIG}/codex/${name}" "${CODEX_ROOT}/${name}"
  done
  for name in "${CODEX_FILES[@]}" "${CODEX_NESTED_FILES[@]}"; do
    link_path "${NEW_CONFIG}/codex/${name}" "${CODEX_ROOT}/${name}"
  done

  for name in "${PI_DIRS[@]}"; do
    link_path "${NEW_CONFIG}/pi/.pi/${name}" "${PI_AGENT_ROOT}/${name}"
  done
  for name in "${PI_FILES[@]}"; do
    link_path "${NEW_CONFIG}/pi/.pi/${name}" "${PI_AGENT_ROOT}/${name}"
  done
}

run_install() {
  ensure_path_dirs
  export PATH="${HOME}/bin:${LOCAL_BIN}:${HOME}/.cargo/bin:${PATH}"

  install_oh_my_zsh
  install_starship
  install_cursor_cli
  install_codex
  install_rust
  install_xcode_components
  apply_starship_preset
  run_link
  echo "install complete — open a new shell or run: exec zsh"
}

case "${1:-}" in
install)
  run_install
  ;;
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
