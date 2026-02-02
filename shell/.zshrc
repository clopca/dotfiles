# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme (Powerlevel10k will override this)
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# POWERLEVEL10K
# =============================================================================
[[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =============================================================================
# PATH
# =============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.toolbox/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
[[ -d "$HOME/.config/smithy-mcp/mcp-servers" ]] && export PATH="$HOME/.config/smithy-mcp/mcp-servers:$PATH"
[[ -d "$HOME/.aim/mcp-servers" ]] && export PATH="$HOME/.aim/mcp-servers:$PATH"

# =============================================================================
# AWS
# =============================================================================
export AWS_REGION="eu-west-1"
export AWS_PAGER=""

# =============================================================================
# DOCKER
# =============================================================================
export DOCKER_BUILDKIT=0
export DOCKER_DEFAULT_PLATFORM=linux/amd64
[[ -d "$HOME/.docker/completions" ]] && fpath=($HOME/.docker/completions $fpath)

# =============================================================================
# COMPLETIONS
# =============================================================================
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit
[[ -f /opt/homebrew/bin/terraform ]] && complete -o nospace -C /opt/homebrew/bin/terraform terraform

# =============================================================================
# NVM (Node Version Manager)
# =============================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# =============================================================================
# BUN
# =============================================================================
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# =============================================================================
# VOLTA (alternative Node version manager)
# =============================================================================
export VOLTA_HOME="$HOME/.volta"
[[ -d "$VOLTA_HOME/bin" ]] && export PATH="$VOLTA_HOME/bin:$PATH"

# =============================================================================
# CLAUDE / AI TOOLS
# =============================================================================
export CLAUDE_CODE_USE_BEDROCK=1
alias claude-code="export AWS_PROFILE=claudecode && export CLAUDE_CODE_USE_BEDROCK=1 && export ANTHROPIC_MODEL='global.anthropic.claude-sonnet-4-5-20250929-v1:0' && export DISABLE_TELEMETRY=1 && claude"

# =============================================================================
# KIRO CLI (if installed)
# =============================================================================
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# Kiro aliases
if command -v kiro-cli &> /dev/null; then
  KIRO_MODEL="claude-opus-4.5"
  alias kiromin='kiro-cli chat --agent kiro-main --model $KIRO_MODEL --trust-all-tools'
  
  salog() {
    local week="${1:-this}"
    kiro-cli chat --agent sa-logger --model $KIRO_MODEL --trust-all-tools "log my activities from $week week"
  }
  
  awsprice() {
    kiro-cli chat --agent aws-pricing-agent --model $KIRO_MODEL --trust-all-tools "$*"
  }
  
  awsknow() {
    kiro-cli chat --agent aws-knowledge-agent --model $KIRO_MODEL --trust-all-tools "$*"
  }
  
  mycal() {
    local when="${1:-today}"
    kiro-cli chat --agent outlook-agent --model $KIRO_MODEL --trust-all-tools "What meetings do I have $when?"
  }
  
  sentral() {
    kiro-cli chat --agent sentral-agent --model $KIRO_MODEL --trust-all-tools "Search for $*"
  }
fi

# =============================================================================
# OBSIDIAN
# =============================================================================
alias obsidian='open -a Obsidian && sleep 1 && open "obsidian://open?vault=clopca-obsidian-vault"'

# =============================================================================
# VS CODE / KIRO SHELL INTEGRATION
# =============================================================================
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  command -v kiro &> /dev/null && . "$(kiro --locate-shell-integration-path zsh)"
fi

# =============================================================================
# CUSTOM ALIASES
# =============================================================================
[[ -f ~/.aliases ]] && source ~/.aliases

# =============================================================================
# LOCAL CONFIGURATION (machine-specific, not in git)
# =============================================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# =============================================================================
# WORK-SPECIFIC TOOLS (source if exists)
# =============================================================================
[[ -f "$HOME/dev/aws/oc-sa-toolkit/opencode-aliases.sh" ]] && source "$HOME/dev/aws/oc-sa-toolkit/opencode-aliases.sh"
