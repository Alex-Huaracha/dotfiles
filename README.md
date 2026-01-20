# Alex's dotfiles

My development environment setup.

## What gets installed

**Shell & Config:**

- `.zshrc` symlink with Starship prompt and fnm configuration
- Fira Code font (latest from GitHub)

**Development Tools:**

- Homebrew (package manager)
- fnm (Fast Node Manager)
- Node.js LTS (via fnm)

## Quick Setup

```bash
git clone https://github.com/Alex-Huaracha/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Restart your terminal when done.

## VS Code Font Setup

Add to your settings.json:

```json
{
  "editor.fontFamily": "'Fira Code', monospace",
  "editor.fontLigatures": true
}
```

## Manual Installs

These tools need to be installed separately:

- [VS Code](https://code.visualstudio.com/)

## Verify Setup

```bash
fnm --version
node --version
```

**Important:** When switching Node.js versions with fnm, you need to re-enable pnpm:

```bash
corepack enable pnpm
```

This is required each time you install or switch to a different Node.js version.
