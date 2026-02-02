#!/usr/bin/env bash

# Bootstrap script for new Mac setup
# Usage: ./install.sh
# Or run directly: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash

set -e

DOTFILES_DIR="$HOME/dev/github/dotfiles"
GITHUB_REPO="clopca/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# =============================================================================
# CHECK PREREQUISITES
# =============================================================================

print_step "Checking prerequisites..."

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

print_success "Running on macOS"

# =============================================================================
# INSTALL XCODE COMMAND LINE TOOLS
# =============================================================================

print_step "Checking Xcode Command Line Tools..."

if ! xcode-select -p &>/dev/null; then
    print_warning "Xcode Command Line Tools not installed. Installing..."
    xcode-select --install
    echo "Press any key when the installation is complete..."
    read -n 1
else
    print_success "Xcode Command Line Tools already installed"
fi

# =============================================================================
# INSTALL HOMEBREW
# =============================================================================

print_step "Checking Homebrew..."

if ! command -v brew &>/dev/null; then
    print_warning "Homebrew not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_step "Updating Homebrew..."
brew update

# =============================================================================
# CLONE DOTFILES REPOSITORY
# =============================================================================

print_step "Setting up dotfiles..."

if [[ ! -d "$DOTFILES_DIR" ]]; then
    print_warning "Cloning dotfiles repository..."
    git clone "https://github.com/$GITHUB_REPO.git" "$DOTFILES_DIR"
else
    print_success "Dotfiles directory already exists"
    print_step "Pulling latest changes..."
    cd "$DOTFILES_DIR" && git pull
fi

# =============================================================================
# INSTALL HOMEBREW PACKAGES
# =============================================================================

print_step "Installing Homebrew packages from Brewfile..."

cd "$DOTFILES_DIR"
brew bundle --file=Brewfile

# Optionally install additional apps
read -p "Install additional applications from Brewfile.apps? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew bundle --file=Brewfile.apps
fi

# =============================================================================
# INSTALL OH MY ZSH
# =============================================================================

print_step "Checking Oh My Zsh..."

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print_warning "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_success "Oh My Zsh already installed"
fi

# =============================================================================
# INSTALL ZSH PLUGINS
# =============================================================================

print_step "Installing ZSH plugins..."

# zsh-autosuggestions
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_success "Installed zsh-autosuggestions"
else
    print_success "zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_success "Installed zsh-syntax-highlighting"
else
    print_success "zsh-syntax-highlighting already installed"
fi

# =============================================================================
# INSTALL POWERLEVEL10K
# =============================================================================

print_step "Checking Powerlevel10k..."

if [[ ! -d "$HOME/powerlevel10k" ]]; then
    print_warning "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
else
    print_success "Powerlevel10k already installed"
fi

# =============================================================================
# COPY CONFIGURATION FILES
# =============================================================================

print_step "Copying configuration files..."

# Backup and copy file
copy_file() {
    local source="$1"
    local target="$2"
    
    # Backup existing file if it exists and is not a symlink
    if [[ -f "$target" && ! -L "$target" ]]; then
        mv "$target" "${target}.backup.$(date +%Y%m%d%H%M%S)"
        print_warning "Backed up existing $target"
    fi
    
    # Remove symlink if exists
    if [[ -L "$target" ]]; then
        rm "$target"
    fi
    
    cp "$source" "$target"
    print_success "Copied $source -> $target"
}

# Shell configuration
copy_file "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
copy_file "$DOTFILES_DIR/shell/.zprofile" "$HOME/.zprofile"
copy_file "$DOTFILES_DIR/shell/.zshenv" "$HOME/.zshenv"
copy_file "$DOTFILES_DIR/shell/.aliases" "$HOME/.aliases"
copy_file "$DOTFILES_DIR/shell/.p10k.zsh" "$HOME/.p10k.zsh"

# Git configuration
copy_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
copy_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Ghostty configuration
mkdir -p "$HOME/.config/ghostty"
copy_file "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

# VS Code settings (if VS Code is installed)
if [[ -d "$HOME/Library/Application Support/Code/User" ]]; then
    copy_file "$DOTFILES_DIR/config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
fi

# =============================================================================
# SETUP SSH DIRECTORY
# =============================================================================

print_step "Setting up SSH directory..."

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/config" ]]; then
    cp "$DOTFILES_DIR/config/ssh/config.template" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
    print_success "Created SSH config from template"
    print_warning "Remember to configure your SSH keys and update ~/.ssh/config"
else
    print_success "SSH config already exists"
fi

# =============================================================================
# INSTALL NODE VERSION MANAGER
# =============================================================================

print_step "Checking Node version managers..."

# Install NVM
if [[ ! -d "$HOME/.nvm" ]]; then
    print_warning "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
    print_success "NVM already installed"
fi

# Or install Volta (alternative)
# if ! command -v volta &>/dev/null; then
#     print_warning "Installing Volta..."
#     curl https://get.volta.sh | bash
# fi

# =============================================================================
# CONFIGURE MACOS DEFAULTS
# =============================================================================

read -p "Configure macOS defaults? This will change system preferences. (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Configuring macOS defaults..."
    chmod +x "$DOTFILES_DIR/macos/defaults.sh"
    "$DOTFILES_DIR/macos/defaults.sh"
fi

# =============================================================================
# FINAL SETUP
# =============================================================================

print_step "Performing final setup..."

# Create local zshrc for machine-specific config
if [[ ! -f "$HOME/.zshrc.local" ]]; then
    echo "# Machine-specific configuration" > "$HOME/.zshrc.local"
    echo "# Add private environment variables and local settings here" >> "$HOME/.zshrc.local"
    print_success "Created ~/.zshrc.local for local configuration"
fi

# Update git config with user info
echo ""
print_warning "Don't forget to update your git configuration!"
echo "Run: git config --global user.name 'Your Name'"
echo "     git config --global user.email 'your.email@example.com'"

# =============================================================================
# DONE
# =============================================================================

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}    Dotfiles installation complete!    ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Configure Powerlevel10k: p10k configure"
echo "  3. Setup 1Password SSH agent for key management"
echo "  4. Update ~/.gitconfig with your user info"
echo "  5. Add machine-specific config to ~/.zshrc.local"
echo ""
