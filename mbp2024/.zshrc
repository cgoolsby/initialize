INITIALIZE="$HOME/.config/initialize/mbp2024"
PRIVATE="$HOME/.config/initialize-private"

# Public tier (this repo), then private tier if cloned via `setup.sh --home`
for f in "$INITIALIZE/.zsh_alias" "$INITIALIZE/.zsh_prompt" \
         "$PRIVATE/.zsh_local" "$PRIVATE/.zsh_export"; do
  [ -f "$f" ] && source "$f"
done

# LS Colors
#export LSCOLORS=GxFxCxDxBxegedabagaced
#export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31'
export LS_COLORS='di=1;32:ln=1;30;47:so=30;45:pi=30;45:ex=1;31:bd=30;46:cd=30;46:su=30'
export LS_COLORS="${LS_COLORS};41:sg=30;41:tw=30;41:ow=30;41:*.rpm=1;31:*.deb=1;31"
export LSCOLORS=CxahafafBxagagabababab

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Kubernetes preferences
export KUBE_EDITOR='/opt/homebrew/bin/nvim'

# Configuration for SOPs and age
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/SOPS_AGE_KEY_FILE"
export HPC_DEMO_AGE_KEY_FILE="$HOME/.config/sops/deploy-keys/hpc-demo.txt"

alias v='nvim'

export PATH="$HOME/.local/bin:$PATH"
