# Commafiles

This repository contains the active macOS dotfiles and Codex configuration.

## Layout

- `new_config/` is the canonical configuration tree.
- `new_config/codex/` contains authored Codex configuration: `AGENTS.md`, agent profiles, `config.toml`, rules, browser settings, and computer-use settings.
- `.zshrc` remains a root-level shell dotfile.
- Credentials and generated state are intentionally excluded, including GitHub `hosts.yml`, Codex `auth.json`, sessions, history, caches, databases, and plugin installations.

## Sync and activate

Run from the repository root:

```bash
./dotfiles.sh sync   # snapshot the live configuration into new_config/
./dotfiles.sh link   # make new_config/ the live configuration
./dotfiles.sh both   # sync, then link
```

The `link` operation sends replaced files and directories to macOS Trash before creating symlinks. Codex is linked file-by-file so its credentials and runtime state remain outside the repository.
