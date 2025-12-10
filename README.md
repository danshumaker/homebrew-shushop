# 🚀 ShuShop

### Unified Dotfile Bootstrap System for macOS + Linux (via Homebrew, rcm, Rustup)

![Version](<https://img.shields.io/badge/version-$(curl> -fsSL <https://raw.githubusercontent.com/danshumaker/homebrew-shushop/main/VERSION)-blue>)

ShuShop is a **one-repository, one-command, fully reversible system bootstrap** that installs:

- Your dotfiles (managed by `rcm`)
- All required packages (via `brew bundle`)
- Rust toolchain (`rustup`)
- Fonts (macOS Terminal fonts)
- System configuration and permission fixes

It also provides an equally simple **one-command uninstall** that cleanly reverses everything.

Designed for **clarity, reproducibility, reversibility, and zero manual setup**.

---

# 🌟 Features at a Glance

| Feature                                | Install | Uninstall | Notes                                      |
| -------------------------------------- | ------- | --------- | ------------------------------------------ |
| Homebrew installation                  | ✅      | —         | Installed automatically if missing         |
| Brewfile-driven package management     | ✅      | ✅        | Uses `brew bundle` + `brew bundle cleanup` |
| rcm-based dotfile deployment           | ✅      | ✅        | `rcup` to install, `rcdn` to remove        |
| Rust toolchain installation            | ✅      | ✅        | Uses `rustup`                              |
| Terminal font installation (macOS)     | ✅      | —         | Optional but automatic                     |
| Automatic backup + restore of dotfiles | ✅      | ✅        | Timestamped backups under `~/.old_dots`    |
| Full dry-run mode                      | ✅      | ✅        | `--dry-run` or `-n`                        |
| Homebrew formula payload system        | ✅      | —         | Clean packaging via `pkgshare`             |

Everything is **idempotent**, safe, and reversible.

---

# 📦 Repository Structure

```
homebrew-shushop/
├── Formula/
│   └── shushop.rb       # Minimal brew formula (payload only)
├── install.sh           # Full bootstrap script
├── uninstall.sh         # Full teardown script (reverse of install)
├── Brewfile             # Declares all packages to install
└── .dotfiles/           # rcm-managed dotfiles
    ├── rcrc
    ├── config/
    │   └── op/
    │       └── config
    └── ...your dotfiles...
```

The Homebrew formula installs the repository payload into:

```
$(brew --prefix shushop)/share
```

The installer scripts then consume this payload.

---

# 🟦 Installation

Install ShuShop in **one command**:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/danshumaker/homebrew-shushop/main/install.sh)"
```

### ✔ What this command does

1. Installs Homebrew (if missing)
2. Taps your tap: `danshumaker/shushop`
3. Installs the `shushop` Homebrew formula
4. Backs up any existing dotfiles into `~/.old_dots/backup_TIMESTAMP`
5. Runs `brew bundle` using your Brewfile
6. Deploys dotfiles via `rcup`
7. Installs Rust toolchain
8. Installs macOS Terminal fonts (macOS only)
9. Fixes permissions for `.dotfiles/config/op`

---

# 🧪 Dry-run Mode (safe preview)

You can simulate the entire installation without touching your system:

```bash
/bin/bash install.sh --dry-run
```

or

```bash
/bin/bash install.sh -n
```

Dry-run prints each command instead of executing it.

---

# 🟥 Uninstallation

Teardown is **one command**:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/danshumaker/homebrew-shushop/main/uninstall.sh)"
```

### ✔ What gets reversed

1. Removes all `rcp`-created symlinks (`rcdn`)
2. Restores your most recent dotfile backup from `~/.old_dots/...`
3. Uninstalls all Brewfile packages (`brew bundle cleanup`)
4. Removes the Rust toolchain (`rustup self uninstall`)
5. Uninstalls the ShuShop formula
6. Removes your tap

Fonts are not removed automatically (system-wide resources).

---

# 🔄 Dry-run Mode for Uninstall

Preview what _would_ be removed:

```bash
/bin/bash uninstall.sh --dry-run
```

---

# 🧭 Homebrew Formula Behavior

The formula:

- **Does not** perform installation work
- **Does not** modify `$HOME`
- **Does not** call external scripts
- **Only** installs payload files into:

```
$(brew --prefix shushop)/share
```

This keeps Homebrew happy while giving your installer script full control.

---

# 🔐 Security Notes

- Homebrew handles checksum verification for the formula tarball.
- No checksum logic is included in the scripts.
- All system changes are reversible.
- Backups protect all user-modified dotfiles before linking.

---

# 🧰 Developer Notes

Useful commands during development:

```bash
brew uninstall shushop
brew untap danshumaker/shushop
brew tap --repair
brew tap danshumaker/shushop
brew install shushop
```

Print formula payload path:

```bash
brew --prefix shushop
```

---

# 📄 License

MIT License — Do whatever you want, just don’t blame me.

---

# 🙋 TODO

- put dotfiles in place.
- fix jj (zz) it's not loading.
- comb through bash_profile and aliases to clean them up.
- show list of NON-tracked dot files with explainations why they are not tracked.
- Convert all hashes and tokens (gh, terminus, acquia, etc) over to use 1pass-cli (op)
- check fonts
- test install (xcode, bash, kitty, brewfile, prompt, tmux, 1pass-cli and shutrail.) on laptop
