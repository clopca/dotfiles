# ~/.zshrc - Main ZSH configuration
# This file is managed by dotfiles - edit the source in ~/dotfiles/shell/

# =============================================================================
# INSTANT PROMPT
# =============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# OH MY ZSH
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins - add wisely as too many slow down shell startup
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  web-search
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# POWERLEVEL10K THEME
# =============================================================================
# Use Powerlevel10k theme (overrides robbyrussell)
[[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =============================================================================
# PATH CONFIGURATION
# =============================================================================
# Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Volta (Node version manager)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# NVM (alternative Node version manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
export PATH="$HOME/.bun/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Toolbox (Amazon internal)
export PATH="$HOME/.toolbox/bin:$PATH"

# =============================================================================
# AWS CONFIGURATION
# =============================================================================
export AWS_REGION="eu-west-1"
export AWS_PAGER=""  # Disable AWS CLI pager (no vim-style output)

# =============================================================================
# DOCKER CONFIGURATION
# =============================================================================
export DOCKER_BUILDKIT=0
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Docker completions
fpath=($HOME/.docker/completions $fpath)

# =============================================================================
# TERRAFORM
# =============================================================================
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# =============================================================================
# COMPLETIONS
# =============================================================================
autoload -Uz compinit
compinit

# =============================================================================
# ALIASES
# =============================================================================
# Source custom aliases from separate file
[[ -f ~/.aliases ]] && source ~/.aliases

# Claude Code alias (using AWS Bedrock)
alias claude-code="export AWS_PROFILE=claudecode && export CLAUDE_CODE_USE_BEDROCK=1 && export ANTHROPIC_MODEL='global.anthropic.claude-sonnet-4-5-20250929-v1:0' && export DISABLE_TELEMETRY=1 && claude"

# Obsidian shortcuts
alias obsidian='open -a Obsidian && sleep 1 && open "obsidian://open?vault=clopca-obsidian-vault"'

# =============================================================================
# LOCAL CONFIGURATION (not tracked in git)
# =============================================================================
# Source machine-specific or private configuration
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
