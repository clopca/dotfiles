# Dotfiles

Personal macOS configuration files and setup scripts for quick machine provisioning.

## Quick Start

On a fresh Mac, run:

```bash
# Install Xcode Command Line Tools (if not already installed)
xcode-select --install

# Clone and run setup
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Or run directly (after pushing to GitHub):

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash
```

## What's Included

### Directory Structure

```
dotfiles/
├── Brewfile              # Homebrew packages (CLI tools)
├── Brewfile.apps         # Optional desktop applications
├── install.sh            # Main installation script
├── shell/
│   ├── .zshrc            # ZSH configuration
│   ├── .zprofile         # Login shell config
│   ├── .zshenv           # Environment variables
│   ├── .aliases          # Shell aliases
│   └── .p10k.zsh         # Powerlevel10k theme config
├── git/
│   ├── .gitconfig        # Git configuration
│   └── .gitignore_global # Global gitignore
├── config/
│   ├── ghostty/          # Ghostty terminal config
│   ├── vscode/           # VS Code settings
│   └── ssh/              # SSH config template
├── macos/
│   └── defaults.sh       # macOS system preferences
└── scripts/              # Utility scripts
```

### Tools Installed

**CLI Tools:**
- `git`, `gh` - Version control
- `terraform` - Infrastructure as Code
- `kubectl`, `helm` - Kubernetes
- `docker` - Containers
- `bun`, `nvm` - JavaScript runtimes
- `python`, `uv` - Python
- And more...

**Shell:**
- Oh My Zsh with plugins
- Powerlevel10k theme
- zsh-autosuggestions
- zsh-syntax-highlighting

**Applications (optional):**
- VS Code, Cursor
- Chrome, Firefox, Arc
- Slack, Discord
- Raycast, Rectangle
- 1Password
- And more...

## Manual Steps After Installation

### 1. Configure Git

Update your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 2. Setup SSH Keys with 1Password

1. Install 1Password desktop app
2. Enable the SSH Agent in 1Password Settings > Developer
3. Add your SSH keys to 1Password
4. The dotfiles already configure 1Password as the SSH agent

### 3. Configure Powerlevel10k

Run the configuration wizard:

```bash
p10k configure
```

### 4. Local Configuration

Add machine-specific settings to `~/.zshrc.local`:

```bash
# Example: Work-specific aliases
alias vpn="networksetup -connectpppoeservice 'Work VPN'"

# Example: Environment variables
export WORK_API_KEY="secret"
```

### 5. AWS Configuration

Configure AWS CLI:

```bash
aws configure
# Or setup SSO
aws configure sso
```

## Updating

Pull the latest changes and re-run the install script:

```bash
cd ~/dotfiles
git pull
./install.sh
```

## Customization

### Adding Homebrew Packages

Edit `Brewfile` and run:

```bash
brew bundle --file=Brewfile
```

### Adding macOS Defaults

Edit `macos/defaults.sh` and run:

```bash
./macos/defaults.sh
```

### Shell Configuration

- Main config: `shell/.zshrc`
- Aliases: `shell/.aliases`
- Local (not tracked): `~/.zshrc.local`

## Backup Your Existing Config

Before running on an existing machine, the script will automatically backup:
- `~/.zshrc` -> `~/.zshrc.backup.TIMESTAMP`
- `~/.gitconfig` -> `~/.gitconfig.backup.TIMESTAMP`
- etc.

## License

MIT
