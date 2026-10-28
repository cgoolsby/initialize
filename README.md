# Initialize

Bootstrap script for a fresh macBook. Installs tools, symlinks dotfiles, and clones personal config repos.

This repo is public and contains nothing machine- or network-specific. Home-only configuration
(SSH aliases, backup/restore, local env) lives in a separate private repo, `initialize-private`,
which is only pulled when you pass `--home`.

## Usage

```bash
git clone https://github.com/cgoolsby/initialize.git ~/.config/initialize
cd ~/.config/initialize/mbp2024
./setup.sh          # work / any machine: tools + dotfiles + nvim + iterm2
./setup.sh --home   # home machines: everything above plus the private tier (needs GitHub SSH key)
```

## What it does

**Dotfiles**
- Symlinks `.zshrc` from this repo to `~/.zshrc`
- `.zshrc` sources `.zsh_alias` and `.zsh_prompt` from this repo, then `.zsh_local` and `.zsh_export`
  from `~/.config/initialize-private` if that directory exists

**Tools installed via Homebrew**
- CLI utilities: `tree`, `fzf`, `jq`, `glow`, `yamllint`
- Version control: `gh`
- Editors: `neovim`
- Runtimes: `node`, `go`
- Containers: `docker`
- IaC: `terraform`
- Kubernetes: `helm`, `flux`, `kubectx`, `kind`, `kustomize`
- Secrets: `age`, `sops`
- Cloud CLIs: `awscli`, `google-cloud-sdk`, `azure-cli`
- AI: `claude` (Claude Code)

**macOS hardening**
- Enables the application firewall and stealth mode

**Config repos**

| Repo | Cloned to | Visibility | When |
|---|---|---|---|
| [cgoolsby/nvim](https://github.com/cgoolsby/nvim) | `~/.config/nvim` | public | always |
| [cgoolsby/iterm2](https://github.com/cgoolsby/iterm2) | `~/.config/iterm2` | public | always |
| cgoolsby/initialize-private | `~/.config/initialize-private` | private | `--home` only |

## Architecture

```
initialize/mbp2024/setup.sh [--home]
  ├── installs brew + tools
  ├── symlinks .zshrc
  ├── clones nvim            → ~/.config/nvim
  ├── clones iterm2          → ~/.config/iterm2
  │     └── defaults write   → iTerm2 loads plist from ~/.config/iterm2
  ├── applies macOS hardening
  └── [--home] clones initialize-private → ~/.config/initialize-private
        └── runs initialize-private/setup.sh if present

~/.zshrc → initialize/mbp2024/.zshrc
  ├── sources initialize/mbp2024/.zsh_alias, .zsh_prompt
  └── sources initialize-private/.zsh_local, .zsh_export   (if present)
```

## Other

- `fedora/` — equivalent bashrc + init for a Fedora box
- `kustomize-diff.sh` — strips server-side metadata and diffs two kustomize output dirs
