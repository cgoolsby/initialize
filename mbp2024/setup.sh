#!/bin/bash
#
# Usage: ./setup.sh [--home]
#   --home   also clone the private initialize-private repo (home machines only)

HOME_SETUP=false
for arg in "$@"; do
    case "$arg" in
        --home) HOME_SETUP=true ;;
        -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

# =====================================
# Configuration Symlinks
# =====================================
echo "Setting up configuration symlinks..."
ln -sf $(pwd)/.zshrc ~/.zshrc

# =====================================
# Install Homebrew
# =====================================
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed, skipping..."
fi

# =====================================
# Development Tools
# =====================================
echo "Installing development tools..."

# Basic utilities
if ! command -v tree &> /dev/null; then
    brew install tree
else
    echo "tree is already installed, skipping..."
fi

if ! command -v fzf &> /dev/null; then
    brew install fzf
else
    echo "fzf is already installed, skipping..."
fi

# Version control
if ! command -v gh &> /dev/null; then
    brew install gh
else
    echo "GitHub CLI is already installed, skipping..."
fi

# Text editor
if ! command -v nvim &> /dev/null; then
    brew install neovim
else
    echo "Neovim is already installed, skipping..."
fi

# Node.js and npm
if ! command -v node &> /dev/null; then
    brew install node
else
    echo "Node.js is already installed, skipping..."
fi

# Go programming language
if ! command -v go &> /dev/null; then
    brew install go
else
    echo "Go is already installed, skipping..."
fi

# Container tools
if ! command -v docker &> /dev/null; then
    brew install docker
else
    echo "Docker is already installed, skipping..."
fi

# Infrastructure as Code
if ! command -v terraform &> /dev/null; then
    brew install terraform
else
    echo "Terraform is already installed, skipping..."
fi

# Kubernetes tools
if ! command -v helm &> /dev/null; then
    brew install helm
else
    echo "Helm is already installed, skipping..."
fi

if ! command -v flux &> /dev/null; then
    brew install fluxcd/tap/flux
else
    echo "Flux is already installed, skipping..."
fi

if ! command -v age &> /dev/null; then
    brew install age
else
    echo "age is already installed, skipping..."
fi

if ! command -v sops &> /dev/null; then
    brew install sops
else
    echo "SOPS is already installed, skipping..."
fi

if ! command -v jq &> /dev/null; then
    brew install jq
else
    echo "jq is already installed, skipping..."
fi

if ! command -v kubectx &> /dev/null; then
    brew install kubectx
else
    echo "kubectx and kubens are already installed, skipping..."
fi

if ! command -v kind &> /dev/null; then
    brew install kind
else
    echo "kind is already installed, skipping..."
fi

if ! command -v glow &> /dev/null; then
    brew install glow
else
    echo "glow is already installed, skipping..."
fi

if ! command -v yamllint &> /dev/null; then
    brew install yamllint
else
    echo "yamllint is already installed, skipping..."
fi

if ! command -v kustomize &> /dev/null; then
    brew install kustomize
else
    echo "kustomize is already installed, skipping..."
fi

# =====================================
# Cloud CLIs
# =====================================
echo "Installing cloud CLIs..."

# AWS CLI
if ! command -v aws &> /dev/null; then
    brew install awscli
else
    echo "AWS CLI is already installed, skipping..."
fi

# Google Cloud CLI
if ! command -v gcloud &> /dev/null; then
    brew install --cask google-cloud-sdk
else
    echo "Google Cloud CLI is already installed, skipping..."
fi

# Azure CLI
if ! command -v az &> /dev/null; then
    brew install azure-cli
else
    echo "Azure CLI is already installed, skipping..."
fi

# =====================================
# Claude Code
# =====================================
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "Claude Code is already installed, skipping..."
fi

# =====================================
# Personal Configurations
# =====================================
echo "Setting up personal configurations..."

# Clone Neovim configuration
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning Neovim configuration..."
    mkdir -p "$HOME/.config"
    git clone https://github.com/cgoolsby/nvim.git "$HOME/.config/nvim"
else
    echo "Neovim configuration already exists at ~/.config/nvim"
fi

# Clone iTerm2 configuration
ITERM2_CONFIG="$HOME/.config/iterm2"
if [ ! -d "$ITERM2_CONFIG" ]; then
    echo "Cloning iTerm2 configuration..."
    mkdir -p "$HOME/.config"
    git clone https://github.com/cgoolsby/iterm2.git "$ITERM2_CONFIG"
    echo "iTerm2 configuration cloned to $ITERM2_CONFIG"
else
    echo "iTerm2 configuration already exists at $ITERM2_CONFIG"
fi

# Point iTerm2 at the repo so it auto-loads all settings on next launch
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 "Custom Folder" -string "$ITERM2_CONFIG"
echo "iTerm2 configured to load preferences from $ITERM2_CONFIG"

# =====================================
# Private Tier (--home only)
# =====================================
PRIVATE="$HOME/.config/initialize-private"
if $HOME_SETUP; then
    if [ ! -d "$PRIVATE" ]; then
        echo "Cloning private configuration..."
        git clone git@github.com:cgoolsby/initialize-private.git "$PRIVATE"
    else
        echo "Private configuration already exists at $PRIVATE"
    fi
    if [ -x "$PRIVATE/setup.sh" ]; then
        echo "Running private setup..."
        "$PRIVATE/setup.sh"
    fi
else
    echo "Skipping private tier (pass --home to enable)"
fi

# =====================================
# macOS Security Hardening
# =====================================
echo "Applying macOS security hardening..."

SFW=/usr/libexec/ApplicationFirewall/socketfilterfw

# Application firewall
if $SFW --getglobalstate | grep -q "enabled"; then
    echo "Application firewall is already enabled, skipping..."
else
    echo "Enabling application firewall..."
    sudo $SFW --setglobalstate on
fi

# Stealth mode: drop pings and probes to closed ports instead of replying
if $SFW --getstealthmode | grep -q "on"; then
    echo "Firewall stealth mode is already on, skipping..."
else
    echo "Enabling firewall stealth mode..."
    sudo $SFW --setstealthmode on
fi

# =====================================
# Verification
# =====================================
echo ""
echo "Installation complete! Verifying installations..."
echo ""

# Verify installations
command -v brew >/dev/null 2>&1 && echo "✓ Homebrew installed" || echo "✗ Homebrew not found"
command -v node >/dev/null 2>&1 && echo "✓ Node.js installed ($(node --version))" || echo "✗ Node.js not found"
command -v npm >/dev/null 2>&1 && echo "✓ npm installed ($(npm --version))" || echo "✗ npm not found"
command -v go >/dev/null 2>&1 && echo "✓ Go installed ($(go version | awk '{print $3}'))" || echo "✗ Go not found"
command -v nvim >/dev/null 2>&1 && echo "✓ Neovim installed" || echo "✗ Neovim not found"
command -v docker >/dev/null 2>&1 && echo "✓ Docker installed" || echo "✗ Docker not found"
command -v terraform >/dev/null 2>&1 && echo "✓ Terraform installed" || echo "✗ Terraform not found"
command -v helm >/dev/null 2>&1 && echo "✓ Helm installed" || echo "✗ Helm not found"
command -v flux >/dev/null 2>&1 && echo "✓ Flux installed" || echo "✗ Flux not found"
command -v age >/dev/null 2>&1 && echo "✓ age installed" || echo "✗ age not found"
command -v sops >/dev/null 2>&1 && echo "✓ SOPS installed" || echo "✗ SOPS not found"
command -v jq >/dev/null 2>&1 && echo "✓ jq installed" || echo "✗ jq not found"
command -v kubectx >/dev/null 2>&1 && echo "✓ kubectx installed" || echo "✗ kubectx not found"
command -v kubens >/dev/null 2>&1 && echo "✓ kubens installed" || echo "✗ kubens not found"
command -v kind >/dev/null 2>&1 && echo "✓ kind installed" || echo "✗ kind not found"
command -v gh >/dev/null 2>&1 && echo "✓ GitHub CLI installed" || echo "✗ GitHub CLI not found"
command -v aws >/dev/null 2>&1 && echo "✓ AWS CLI installed" || echo "✗ AWS CLI not found"
command -v gcloud >/dev/null 2>&1 && echo "✓ Google Cloud CLI installed" || echo "✗ Google Cloud CLI not found"
command -v az >/dev/null 2>&1 && echo "✓ Azure CLI installed" || echo "✗ Azure CLI not found"
command -v claude >/dev/null 2>&1 && echo "✓ Claude Code installed" || echo "✗ Claude Code not found"
command -v fzf >/dev/null 2>&1 && echo "✓ fzf installed" || echo "✗ fzf not found"
command -v glow >/dev/null 2>&1 && echo "✓ glow installed" || echo "✗ glow not found"
command -v yamllint >/dev/null 2>&1 && echo "✓ yamllint installed" || echo "✗ yamllint not found"
command -v kustomize >/dev/null 2>&1 && echo "✓ kustomize installed" || echo "✗ kustomize not found"
[ -d "$HOME/.config/nvim" ] && echo "✓ Neovim config present at ~/.config/nvim" || echo "✗ Neovim config not found"
[ -d "$HOME/.config/iterm2" ] && echo "✓ iTerm2 config present at ~/.config/iterm2" || echo "✗ iTerm2 config not found"
$HOME_SETUP && { [ -d "$PRIVATE" ] && echo "✓ Private config present at ~/.config/initialize-private" || echo "✗ Private config not found"; }
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep -q enabled && echo "✓ Application firewall enabled" || echo "✗ Application firewall disabled"
/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode | grep -q on && echo "✓ Firewall stealth mode on" || echo "✗ Firewall stealth mode off"

echo ""
echo "Setup complete!"
