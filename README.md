# Commafiles

This repository contains the active macOS dotfiles and Codex configuration.

## Layout

- `config/` is the canonical configuration tree.
- `config/codex/` contains authored Codex configuration: `AGENTS.md`, agent profiles, `config.toml`, rules, browser settings, and computer-use settings.
- `Brewfile` lists Homebrew taps, formulae, casks, and VS Code extensions for a new Mac.
- `.zshrc` remains a root-level shell dotfile.
- Credentials and generated state are intentionally excluded, including GitHub `hosts.yml`, Codex `auth.json`, sessions, history, caches, databases, and plugin installations.

## New Mac setup

1. Install Homebrew, then install packages from this repo:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file ./Brewfile
```

2. Sync/link dotfiles (below).

To refresh the Brewfile from the current machine later:

```bash
brew bundle dump --force --file ./Brewfile
```

## Sync and activate

Run from the repository root:

```bash
./dotfiles.sh sync   # snapshot the live configuration into config/
./dotfiles.sh link   # make config/ the live configuration
./dotfiles.sh both   # sync, then link
```

The `link` operation sends replaced files and directories to macOS Trash before creating symlinks. Codex is linked file-by-file so its credentials and runtime state remain outside the repository.
