# Dotfiles

Personal macOS configuration files and setup scripts for quick machine provisioning.

## Quick Start

On a fresh Mac, run:

```bash
# Install Xcode Command Line Tools (if not already installed)
xcode-select --install

# Clone and run setup
mkdir -p ~/dev/github
git clone https://github.com/clopca/dotfiles.git ~/dev/github/dotfiles
cd ~/dev/github/dotfiles
./install.sh
```

Or run directly (after pushing to GitHub):

```bash
curl -fsSL https://raw.githubusercontent.com/clopca/dotfiles/main/install.sh | bash
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

### 1. Setup SSH Keys with 1Password (Recommended)

This setup uses 1Password as your SSH agent, so keys are securely stored and synced across devices.

**Step 1: Install and configure 1Password**

1. Install 1Password from the App Store or `brew install --cask 1password`
2. Sign in to your 1Password account
3. Go to **1Password > Settings > Developer**
4. Enable **"Use the SSH Agent"**
5. Enable **"Integrate with 1Password CLI"** (optional, for `op` command)

**Step 2: Add your SSH key to 1Password**

Option A - Import existing key:
1. In 1Password, click **+ New Item > SSH Key**
2. Import your existing private key, or
3. Let 1Password generate a new one

Option B - Generate new key:
1. In 1Password, click **+ New Item > SSH Key**
2. Click **"Generate a New Key"**
3. Choose **Ed25519** (recommended) or RSA

**Step 3: Add SSH key to GitHub**

1. In 1Password, open your SSH key item
2. Copy the **public key**
3. Go to [GitHub > Settings > SSH Keys](https://github.com/settings/keys)
4. Click **"New SSH key"**
5. Paste your public key and save

**Step 4: Configure SSH (already done by dotfiles)**

The install script copies `~/.ssh/config` which includes:
```
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

**Step 5: Test the connection**

```bash
ssh -T git@github.com
# Should see: "Hi username! You've successfully authenticated..."
```

**Step 6: Setup Git commit signing (optional)**

Your commits can be signed with your SSH key:

```bash
# Get your SSH public key from 1Password and set it
git config --global user.signingkey "ssh-ed25519 AAAA..."
git config --global gpg.format ssh
git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --global commit.gpgsign true
```

Then add the same public key to [GitHub > Settings > SSH Keys](https://github.com/settings/keys) as a **"Signing Key"**.

### 2. Configure Git

Update your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

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
cd ~/dev/github/dotfiles
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
