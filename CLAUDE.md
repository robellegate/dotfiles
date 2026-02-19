# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for Robert Ellegate, managed with [chezmoi](https://chezmoi.io) (v2.33.0+). The repo manages ZSH shell configuration, git config, aliases, and tool configurations across Linux and macOS.

## Key Architecture

- **`.chezmoiroot`** points to `home/` — all managed dotfiles live under `home/`, not the repo root.
- **Template files** (`*.tmpl`) use Go template syntax and are rendered by chezmoi during `chezmoi apply`.
- **User data** is defined in `home/.chezmoi.yaml.tmpl` and accessed in templates as `.user.*` (e.g., `.user.name`, `.user.email`).
- **External resources** (fonts, gitignore files) are declared in `home/.chezmoiexternal.yaml.tmpl`.
- **Platform-specific logic** uses `{{ if eq .chezmoi.os "linux" }}` / `"darwin"` guards in templates and `.chezmoiignore.tmpl`.
- **Post-apply scripts** in `home/.chezmoiscripts/{linux,darwin}/` configure OS-level settings (GNOME/macOS defaults).

## Chezmoi Naming Conventions

Files under `home/` use chezmoi's attribute prefixes:
- `dot_` → `.` (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)
- `private_` → file with restricted permissions
- `empty_` → ensure file exists even if empty
- `symlink_` → creates a symlink
- `executable_` → file with executable permissions
- `run_onchange_after_` → script that runs after apply when content changes

## Common Template Patterns

```go
{{- if eq .chezmoi.os "linux" -}}       // Platform conditional
{{ if lookPath "command" -}}             // Check if command exists
{{ if stat "/path/to/file" -}}          // Check if path exists
{{ default "fallback" (env "VAR") }}    // Env var with default
{{ .user.name }}                         // User data access
{{ .user.email }}                        // User email access
{{ include "file_path" }}               // Include another file
{{ glob "pattern" }}                    // Glob for files
{{ joinPath .chezmoi.homeDir ".dir" }}  // Path construction
```

## Shell Configuration Hierarchy

ZSH files are loaded in this order (each is a `.tmpl`):
1. `.zshenv` — environment variables only, loaded by ALL zsh instances
2. `.zprofile` — login shell PATH setup, tool initialization
3. `.zshrc` — interactive shell: completions, plugins, aliases, prompt
4. `.zlogin` — post-login tasks (MOTD, cache updates)
5. `.zlogout` — cleanup on exit

Aliases are modularized in `home/dot_aliasrc.d/*.aliasrc` (26 files), sourced by `.zshrc` via glob.

## Commands

### Apply dotfiles
```sh
chezmoi apply           # Apply all changes to home directory
chezmoi apply --dry-run # Preview changes without applying
chezmoi diff            # Show pending changes
```

### Benchmark ZSH startup
```sh
./scripts/benchmark-zsh.sh   # Full benchmark (time + hyperfine + zprof)
```
Requires: `hyperfine`. Reports are written to `reports/` (gitignored).

VS Code: `Ctrl+Shift+B` runs the benchmark as the default build task.

### Update chezmoi version tracker
```sh
./scripts/bump_chezmoiversion.sh
```
Requires: `git`, `rg`, `chezmoi`.

## File Organization

- `home/dot_aliasrc.d/` — modular alias files, one per tool/category
- `home/dot_config/` — XDG config files (starship, kitty, gh, ripgrep, systemd units, VS Code)
- `home/dot_gitaliases.tmpl` — extensive git aliases (~85), with conditional fzf support
- `home/dot_gitconfig.tmpl` — git config with templated user identity
- `home/Scripts/` — utility scripts (Fedora upgrade, kernel cleanup, tool installers)
- `home/.chezmoiscripts/` — platform-specific post-apply configuration scripts
- `scripts/` — repo-level maintenance scripts (benchmarking, version bumping)

## Conventions

- Commit messages use emoji-prefixed conventional format (e.g., `✨ feat(scope): description`).
- Files containing secrets use the `private_` prefix and are not committed in plaintext.
- `.chezmoiignore.tmpl` excludes platform-inappropriate files and dynamically modified configs (starship, VS Code settings).
- EditorConfig enforces 4-space indentation by default, 2-space for YAML/JSON/JSONC.
- Markdown line length limit is 120 characters (`.markdownlint.yaml`).
