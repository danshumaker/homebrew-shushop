#!/usr/bin/env bash
set -euo pipefail

# ---------------- Color Support ----------------
if test -t 1 && command -v tput >/dev/null 2>&1; then
  BLUE=$(tput setaf 4)
  YEL=$(tput setaf 3)
  RED=$(tput setaf 1)
  GRN=$(tput setaf 2)
  NC=$(tput sgr0)
else
  BLUE=""
  YEL=""
  RED=""
  GRN=""
  NC=""
fi

info() { printf "%s[INFO]%s %s\n" "$BLUE" "$NC" "$*"; }

info "Developer Envioronment Installer"

warn() { printf "%s[WARN]%s %s\n" "$YEL" "$NC" "$*"; }
error() {
  printf "%s[ERROR]%s %s\n" "$RED" "$NC" "$*"
  exit 1
}
ok() { printf "%s[SUCCESS]%s %s\n" "$GRN" "$NC" "$*"; }

# ---------------- Dry Run Mode ----------------
DRY=0
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]]; then
  DRY=1
  info "Running in DRY-RUN mode — commands will NOT execute."
fi

run() {
  if [[ $DRY -eq 1 ]]; then
    echo "DRYRUN: $*"
  else
    eval "$@"
  fi
}

getc() {
  local save_state
  save_state="$(/bin/stty -g)"
  /bin/stty raw -echo
  IFS='' read -r -n 1 -d '' "$@"
  /bin/stty "${save_state}"
}

ring_bell() {
  # Use the shell's audible bell.
  if [[ -t 1 ]]; then
    printf "\a"
  fi
}

wait_for_user() {
  local c
  echo
  warn "Press RETURN/ENTER to continue or any other key to abort:"
  getc c
  # we test for \r and \n because some stuff does \r instead
  if ! [[ "${c}" == $'\r' || "${c}" == $'\n' ]]; then
    exit 1
  fi
}

# ---------------- Detect OS -------------------
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="macos" ;;
  Linux) PLATFORM="linux" ;;
  *) error "Unsupported OS: $OS" ;;
esac
info "Platform: $PLATFORM"

# ----------------- xCode Developer Tools -------
xcode_install() {
  if [[ "$PLATFORM" == "macos" ]]; then
    if ! xcode-select -p >/dev/null 2>&1; then
      info "The Xcode Command Line Tools will be installed."
      run "xcode-select --install"
      echo "Press any key when the installation has completed."
      getc
    else
      info "Xcode Command Line Tools are already installed."
    fi
  fi
}

# ----------------- Change Zsh to Bash default shell -------
change_shell() {
  info "Auditing shell configuration..."

  if [[ -z "${SHELL:-}" ]]; then
    error "\$SHELL is not set."
  fi

  if [[ ! -x "$SHELL" ]]; then
    error "\$SHELL points to a non-executable: $SHELL"
  fi

  if ! grep -qx "$SHELL" /etc/shells; then
    warn "\$SHELL ($SHELL) is not listed in /etc/shells"
  fi

  if command -v brew >/dev/null 2>&1; then

    info "Enforcing Homebrew bash as login shell..."

    BREW_BASH="$(brew --prefix)/bin/bash"

    if ! grep -qx "$BREW_BASH" /etc/shells; then
      info "Registering Homebrew bash in /etc/shells"
      echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
    fi

    if [[ "$SHELL" != "$BREW_BASH" ]]; then
      info "Changing login shell to $BREW_BASH"
      chsh -s "$BREW_BASH"
      ok "Login shell updated. Log out/in required."
    else
      ok "Homebrew bash already set as login shell"
    fi
  fi

}

# ---------------- Homebrew Install --------------
homebrew_install() {
  if ! command -v brew >/dev/null 2>&1; then
    info "Installing Homebrew..."
    run 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  else
    info "Homebrew already installed."
  fi

  # Load brew shellenv
  BREW_PREFIX="$(brew --prefix)"
  run 'eval "$($BREW_PREFIX/bin/brew shellenv)"'
}

# ---------------- Tap + Install formula ----------
denver_install() {
  run "brew untap danshumaker/denver --force"
  info "Tapping danshumaker/denver..."
  run "brew tap danshumaker/denver"
  run "brew upgrade"

  info "Installing Denver formula..."

  if ! run "brew install denver"; then
    error "Homebrew failed to install 'denver'. Aborting."
  fi

  # ---------------- Verify Installation Success ----------------
  DENVER_PREFIX="$(brew --prefix denver || true)"
  if [[ ! -d "$DENVER_PREFIX" ]]; then
    error "Denver prefix not found at: $DENVER_PREFIX"
  fi

  PAYLOAD_DIR="$DENVER_PREFIX/share/denver"

  if [[ ! -d "$PAYLOAD_DIR" ]]; then
    error "Denver payload directory missing: $PAYLOAD_DIR"
  fi

  info "Denver payload detected at: $PAYLOAD_DIR"

  # ---------------- Verify Brewfile Exists ----------------
  BREWFILE="$PAYLOAD_DIR/Brewfile"

  if [[ ! -f "$BREWFILE" ]]; then
    error "Brewfile missing at: $BREWFILE"
  fi

  # Update Homebrew and basic sanity
  brew update
  #brew doctor || true
  # run "brew cleanup -s"
  #run "rm -rf ~/Library/Caches/Homebrew/downloads/*"
}

# ---------------- Backup dotfiles ----------------
dotfile_backup() {
  BACKUP_DIR="$HOME/.old_dots/backup_$(date +%Y%m%d_%H%M%S)"
  run "mkdir -p \"$BACKUP_DIR\""

  info "Backing up existing dotfiles... to $BACKUP_DIR"

  DOTS="$PAYLOAD_DIR"/dotfiles
  files=$(find "$DOTS" -type f -depth 1)
  for f in ${files[@]}; do
    if [[ -e "$HOME/.$f" ]]; then
      run "mv -v \"$HOME/.$f\" \"$BACKUP_DIR/\""
    fi
  done
}

# ---------------- Safe Brew Install Wrapper ----------------
formula_install() {
  local formula="$1"
  local logfile="/tmp/brew-install-${formula}.log"

  info "Installing ${formula}…"

  # Run brew install and capture all output.
  # brew returns 0 even with warnings, so exit code is the only correct test.
  if ! brew install "${formula}" >"${logfile}" 2>&1; then
    error "Fatal error installing ${formula}. See ${logfile}"
  fi

  # Validation: Did Brew actually install it?
  # brew list <formula> returns 1 if installation did NOT succeed.
  if ! brew list "${formula}" >/dev/null 2>&1; then
    warn "Brew did not register '${formula}' as installed."
    warn "This typically means a post-install failure."
    warn "See ${logfile}"
    error "Installation of ${formula} is incomplete."
  fi

  ok "${formula} installed successfully (non-fatal Brew warnings ignored)"
}

# ---------------- Brew Bundle ----------------
safe_brew_bundle() {
  local brewfile="$1"
  local logfile="/tmp/brew-bundle.log"

  info "Running brew bundle using ${brewfile}…"

  # Brew bundle returns non-zero only on a real failure
  if ! brew bundle --file="${brewfile}" >"${logfile}" 2>&1; then
    error "brew bundle failed. See ${logfile}"
  fi

  ok "Brew bundle finished successfully"
}

# ---------------- Brew bundle --------------------
bundle_install() {
  info "Running brew bundle..."
  run "brew tap homebrew/bundle || true"
  safe_brew_bundle "$BREWFILE"
}

# ---------------- PHP Install --------------------
php_install() {
  info "Safe PHP install..."
  formula_install php
}

# ---------------- RCM deployment ----------------
rcm_setup() {
  info "Running rcup..."
  run "ln -s \"$DOTS\"/rcrc $HOME/.rcrc"
  run "rcup -d \"$DOTS\""
  if [[ ! -L $HOME/.bash_profile ]]; then
    error "RCM up did not link dotfiles."
  else
    ok "Dotfiles installed"
  fi
}

# ---------------- Install Rust --------------------
rust_install() {
  if ! command -v cargo >/dev/null 2>&1; then
    info "Installing Rust/Cargo toolchain..."
    run 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
  else
    info "Rust already installed."
  fi
}

# ---------------- Install Fonts (macOS only) -------
font_install() {
  if [[ "$PLATFORM" == "macos" ]]; then
    # TODO: Possible install powerline fonts https://github.com/powerline/fonts.git
    brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs brew install

    #FONT_SRC="/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
    #if [[ -d "$FONT_SRC" ]]; then
    #  info "Installing Terminal fonts..."
    #  run "sudo cp -R \"$FONT_SRC/.\" \"/Library/Fonts/\""
    #else
    #  warn "Terminal fonts not found at $FONT_SRC"
    #fi
  fi
}

kitty_config() {
  KITTY_CONF="$HOME/.config/kitty/kitty.conf"

  if [[ ! -f "$KITTY_CONF" ]]; then
    warn "kitty.conf not found"
    return
  fi

  if ! grep -q '^shell \$SHELL --login' "$KITTY_CONF"; then
    warn "Kitty is not configured to use '\$SHELL --login'"
    warn "Expected: shell \$SHELL --login"
  else
    ok "Kitty shell configuration is correct"
  fi
}

main() {
  xcode_install
  change_shell
  homebrew_install
  denver_install
  dotfile_backup
  bundle_install
  php_install
  rcm_setup
  font_install
  kitty_config

  ok "Denver installation complete."
  warn "CONFIGURATION LEFT TODO"
  info " - Kitty shell usage"
  info " - Configure 1Pass-cli .config/op/config"
  info " - ^S^I in Tmux to picup installed plugins"
  info " - .config/gh github authentication"
  info " - possible powerline fonts install git clone https://github.com/powerline/fonts "
  info " - configure .ssh do ssh-keygen but also convert to 1Pass-OP"
  info " - Ensure docksal, colima, and terminus work"
  info " - Ensure node and hugo work in resume theme"
  info " - Ensure shutrail standsup"

}

main "$@"
