# Dotfiles

Personal macOS configuration files and setup scripts for Apple Silicon machines (M1/M2/M3/M4).

**Architecture:** Apple Silicon (arm64)  
**Tested on:** macOS 26.x (Tahoe) - Mac Mini M4 Pro

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

Or run directly:

```bash
curl -fsSL https://raw.githubusercontent.com/clopca/dotfiles/main/install.sh | bash
```

## Directory Structure

```
dotfiles/
├── Brewfile                  # Homebrew packages (CLI tools)
├── Brewfile.apps             # Optional desktop applications
├── install.sh                # Main installation script
├── shell/
│   ├── .zshrc                # ZSH configuration (with agent mode)
│   ├── .zprofile             # Login shell config
│   ├── .zshenv               # Environment variables
│   ├── .aliases              # Shell aliases
│   └── .p10k.zsh             # Powerlevel10k theme config
├── git/
│   ├── .gitconfig            # Git configuration
│   └── .gitignore_global     # Global gitignore
├── config/
│   ├── aws/                  # AWS CLI SSO configuration
│   │   └── config            # SSO sessions & profiles (merged into ~/.aws/config)
│   ├── opencode/             # OpenCode AI assistant config
│   │   ├── opencode.jsonc    # Global config (goes to ~/.config/opencode/)
│   │   ├── package.json      # MCP dependencies
│   │   └── opencode.project-example.jsonc  # Project template
│   ├── ghostty/              # Ghostty terminal config
│   ├── cursor/               # Cursor editor settings
│   ├── vscode/               # VS Code settings
│   └── ssh/                  # SSH config template
├── macos/
│   └── defaults.sh           # macOS system preferences
└── fonts/                    # Terminal fonts (Hack, MesloLGS)
```

## What's Installed

### CLI Tools (Brewfile)

| Category | Tools |
|----------|-------|
| **Shell** | Oh My Zsh, Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting |
| **Git** | gh (GitHub CLI), git-filter-repo |
| **JavaScript** | fnm (Node version manager), Bun |
| **Python** | Python 3.13/3.14, uv (fast pip), pipx |
| **Infrastructure** | Terraform, Pulumi |
| **Containers** | Docker, Docker Buildx, kubectl, Helm |
| **Utilities** | direnv, pandoc, ffmpeg, watch |
| **AI Tools** | OpenCode, Codex CLI |

### Desktop Applications (Brewfile.apps)

| Category | Apps |
|----------|------|
| **Editors** | Cursor, VS Code, Sublime Text |
| **Terminal** | Ghostty, iTerm2, Warp |
| **Browsers** | Chrome, Firefox, Arc |
| **Productivity** | Raycast, Rectangle, Obsidian, Linear |
| **Communication** | Slack, Discord, Zoom |
| **Utilities** | 1Password, Alt-Tab, HiddenBar, Stats |

## GitHub Projects Structure

Location: `~/dev/github/`

| Project | Description |
|---------|-------------|
| `dotfiles` | This repository - system configuration |
| `opencode` | OpenCode CLI source |
| `opencode-configs` | OpenCode profiles and MCP configurations |
| `criteria` | Main application |
| `criteria-opensearch` | OpenSearch integration |
| `clon-ai` | AI assistant project |
| `crediteame` | Credit application |
| `entrena-app` | Training application |
| `donna` | Personal assistant |
| `AudioRecorder` | Audio recording tool |
| `pizza-chat` | Chat application |
| `sst-data-pipeline` | SST data pipelines |

## Cursor / VS Code Configuration

### Settings Location

The install script copies settings to:

```
~/Library/Application Support/Cursor/User/settings.json
~/Library/Application Support/Code/User/settings.json
```

### What's Configured

| Setting | Value |
|---------|-------|
| **Theme** | Dracula Pro (Van Helsing) |
| **Editor Font** | Fira Code (with ligatures) |
| **Terminal Font** | MesloLGS NF |
| **Default Formatter** | Biome (JS/TS/JSON) |
| **Tab Size** | 2 spaces |
| **Format on Save** | Enabled |
| **Icon Theme** | Material Icon Theme |

### Language-Specific Formatters

| Language | Formatter |
|----------|-----------|
| TypeScript, JavaScript, JSON, JSONC | Biome |
| YAML, Docker Compose, GitHub Actions | Red Hat YAML |
| Python | Format on type enabled |

### File Nesting

`package.json` nests related files:
- `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb`
- `tsconfig.json`, `next.config.mjs`, `tailwind.config.ts`
- `.gitignore`, `.eslintrc.json`, `.prettierrc`

### Extensions

Extensions are listed in `config/cursor/extensions.txt` and installed automatically:
- Biome, Tailwind CSS, React snippets
- Terraform, Python, Rainbow CSV
- Material Icon Theme, Dracula Pro

### Customizing

Edit `config/cursor/settings.json` then re-run:

```bash
./install.sh
```

Or manually copy:

```bash
cp config/cursor/settings.json ~/Library/Application\ Support/Cursor/User/
```

## OpenCode Configuration

OpenCode is configured at multiple levels:

### 1. Global Configuration

Location: `~/.config/opencode/opencode.jsonc`

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "amazon-bedrock/global.anthropic.claude-opus-4-6-v1",
  "plugin": [
    "opencode-antigravity-auth@1.4.3",
    "opencode-openai-codex-auth",
    "@franlol/opencode-md-table-formatter@0.0.3"
  ],
  "provider": {
    // Custom providers (Antigravity, Codex)
  },
  "mcp": {
    // Global MCP servers (Neon, Linear, Sentry, etc.)
  }
}
```

### 2. Project-Level Configuration

Location: `<project>/.opencode/opencode.jsonc`

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "playwright": {
      "type": "local",
      "command": ["npx", "-y", "@anthropic-ai/mcp-server-playwright"],
      "enabled": true
    }
  }
}
```

### 3. Available Models

| Provider | Models |
|----------|--------|
| **AWS Bedrock** | claude-opus-4.6, claude-sonnet-4.5 |
| **Google (Antigravity)** | gemini-3-pro-high/medium/low, gemini-3-flash |
| **OpenAI (Codex)** | gpt-5.2, o3, o4-mini, codex-1 |

### 4. MCP Servers

| Server | Purpose |
|--------|---------|
| **neon** | Postgres serverless database |
| **linear** | Project management |
| **sentry** | Error tracking |
| **axiom** | Logs and analytics |
| **context7** | Documentation search |
| **playwright** | E2E testing (project-level) |

## Shell Features

### Agent Mode

The `.zshrc` includes automatic detection for AI agents (CI environments, non-interactive shells):

- Disables Powerlevel10k for faster startup
- Uses minimal prompt
- Removes interactive confirmations
- Disables bells and corrections

### Key Aliases

```bash
# OpenCode
oc          # opencode
ocr         # opencode run

# Editors
c           # cursor
code        # cursor

# Navigation
..          # cd ..
...         # cd ../..

# Git
gs          # git status
gp          # git push
gl          # git pull
gc          # git commit
```

### Environment Tools

| Tool | Purpose |
|------|---------|
| **fnm** | Fast Node.js version manager (preferred) |
| **direnv** | Per-project environment variables |
| **1Password CLI** | SSH agent and secrets |

## Manual Setup Steps

### 1. SSH Keys with 1Password

```bash
# 1. Enable SSH Agent in 1Password Settings > Developer
# 2. Add SSH key to 1Password
# 3. Copy public key to GitHub Settings > SSH Keys
# 4. Test connection:
ssh -T git@github.com
```

### 2. Configure Git Identity

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. Configure Powerlevel10k

```bash
p10k configure
```

### 4. Setup OpenCode

```bash
# Install OpenCode
curl -fsSL https://opencode.ai/install | bash

# Login to Antigravity (for Google models)
opencode auth login --provider antigravity

# Verify installation
opencode --version
```

### 5. Local Configuration

Machine-specific settings go in `~/.zshrc.local`:

```bash
# Example: Work-specific aliases
export WORK_API_KEY="secret"
alias vpn="networksetup -connectpppoeservice 'Work VPN'"
```

### 6. AWS SSO Configuration

The install script merges SSO sessions and profiles from `config/aws/config` into `~/.aws/config`. This includes customer AWS accounts authenticated via IAM Identity Center (SSO).

| SSO Session | Profile | Account | SSO URL |
|-------------|---------|---------|---------|
| `crediteame` | `crediteame` | `654654416577` | `sensobox.awsapps.com` |
| `investtup` | `investtup` | `851725568910` | `investtup.awsapps.com` |
| `criteria` | `criteria` | `109964722912` | `somoscriteria.awsapps.com` |
| `lighthouse` | `lighthouse` | TBD | TBD |

Usage (shell aliases defined in `.zshrc`):

```bash
# Login (opens browser + 1Password passkey, once per day)
awslogin crediteame    # or: alcred

# Switch profile in current terminal
awsuse crediteame      # or: aucred

# Export SSO creds to [default] in ~/.aws/credentials (auto-logins if expired)
awsexport crediteame   # or: aecred
```

| Action | Crediteame | Investtup | Criteria |
|--------|-----------|-----------|----------|
| **Login** (SSO browser) | `alcred` | `alinv` | `alcrit` |
| **Use** (switch profile) | `aucred` | `auinv` | `aucrit` |
| **Export** (login + creds to default) | `aecred` | `aeinv` | `aecrit` |

Machine-specific profiles (e.g., Isengard) should be added directly to `~/.aws/config` — they won't be overwritten.

### 7. AWS Isengard Configuration

Internal AWS accounts use `isengardcli` as `credential_process` in `~/.aws/config` (auto-fetches creds per CLI call). For system-wide credential export, `ada` writes temp creds to `[default]` in `~/.aws/credentials`.

```bash
# Login — set AWS_PROFILE for current session (uses credential_process)
isengardlogin clopca+cc-Admin   # or: ilcc

# Export — write creds to [default] for all processes (uses ada)
isengardexport clopca+cc@amazon.es   # or: iecc
```

| Alias | Account | Login (session) | Export (computer) |
|-------|---------|-----------------|-------------------|
| cc | `clopca+cc` | `ilcc` | `iecc` |
| sandbox | `clopca+aisandbox` | `ilsandbox` | `iesandbox` |
| kiro | `clopca+kiro` | `ilkiro` | `iekiro` |
| net | `clopca+ceca+net` | `ilnet` | `ienet` |

## Remote Development Setup

Use your Mac Mini as a remote dev server accessible from your MacBook Pro (or anywhere).

### 1. Enable Remote Access on Mac Mini

```bash
# Enable SSH (Remote Login)
sudo systemsetup -setremotelogin on
```

Or via GUI: **System Settings → General → Sharing → Remote Login → Enable**

For Screen Sharing: **System Settings → General → Sharing → Screen Sharing → Enable**

### 2. Install Tailscale (Both Machines)

Tailscale creates a secure mesh VPN - your devices always see each other, anywhere.

```bash
# Install via Homebrew (already in Brewfile)
brew install --cask tailscale

# Open Tailscale and sign in with same account on both machines
```

After setup, your Mac Mini is accessible via Tailscale hostname (e.g., `clopca-m4pro`).

### 3. Connect from MacBook Pro

#### SSH Access
```bash
# Local network
ssh clopca@clopca-M4Pro.local

# Via Tailscale (from anywhere)
ssh clopca@clopca-m4pro
```

#### Cursor/VS Code Remote Development
1. Install "Remote - SSH" extension
2. `Cmd+Shift+P` → "Remote-SSH: Connect to Host"
3. Add host: `clopca@clopca-m4pro` (Tailscale) or `clopca@clopca-M4Pro.local` (local)
4. Full IDE experience with code running on Mac Mini

#### Screen Sharing (Full Desktop)
```bash
# Local network
open vnc://clopca-M4Pro.local

# Via Tailscale (from anywhere)
open vnc://clopca-m4pro
```

Or: **Finder → Go → Connect to Server** → enter VNC URL

### 4. Remote Access Methods Summary

| Method | Local Network | From Anywhere | GUI | Use Case |
|--------|--------------|---------------|-----|----------|
| SSH | `clopca-M4Pro.local` | Via Tailscale | No | Terminal, scripts |
| Cursor Remote SSH | `clopca-M4Pro.local` | Via Tailscale | Editor only | Development |
| Screen Sharing | `vnc://...local` | Via Tailscale | Full desktop | GUI apps, debugging |
| OpenCode | Works over SSH | Via Tailscale | TUI | AI coding |

### 5. Recommended Workflow

1. **Daily development:** Cursor Remote SSH (lightweight, fast)
2. **Need a browser/GUI:** Screen Sharing via Tailscale
3. **Quick terminal task:** SSH directly

### 6. Tips

**Passwordless SSH:** If using 1Password SSH agent on both machines with same account, authentication is automatic.

**Keep Mac Mini awake:**
```bash
# Prevent sleep (run on Mac Mini)
sudo pmset -a sleep 0
sudo pmset -a disksleep 0
```

Or: **System Settings → Energy → Prevent automatic sleeping**

**Tailscale Exit Node:** You can route all MacBook traffic through Mac Mini if needed (useful for accessing home network resources).

## Updating

Pull the latest changes and re-run install:

```bash
cd ~/dev/github/dotfiles
git pull
./install.sh
```

## Customization

### Adding Homebrew Packages

```bash
# Edit Brewfile, then:
brew bundle --file=Brewfile
```

### Adding macOS Defaults

```bash
# Edit macos/defaults.sh, then:
./macos/defaults.sh
```

### Adding OpenCode MCP Servers

Edit `~/.config/opencode/opencode.jsonc` or project-level `.opencode/opencode.jsonc`.

## Backup

Before running on an existing machine, the script automatically backs up:
- `~/.zshrc` -> `~/.zshrc.backup.TIMESTAMP`
- `~/.gitconfig` -> `~/.gitconfig.backup.TIMESTAMP`
- etc.

## Troubleshooting

### Homebrew on Apple Silicon

Homebrew installs to `/opt/homebrew` on Apple Silicon. The `.zprofile` handles this:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Powerlevel10k Not Loading

Ensure Powerlevel10k is installed via Homebrew:

```bash
brew install powerlevel10k
```

### OpenCode Not Found

Add to PATH in `.zshrc`:

```bash
export PATH="$HOME/.opencode/bin:$PATH"
```

### SSH Agent Not Working

Verify 1Password SSH agent is enabled:
1. 1Password > Settings > Developer
2. Enable "Use the SSH Agent"

## License

MIT
