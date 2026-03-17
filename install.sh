#!/usr/bin/env bash
# ====================================================
#   Dotfiles Installer
#   github.com/sofonyas66/dotfiles
# ====================================================

set -e

# --- COLORS ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

ok()      { echo -e "${GREEN}  [✓]${RESET} $1"; }
info()    { echo -e "${YELLOW}  [i]${RESET} $1"; }
err()     { echo -e "${RED}  [✗]${RESET} $1"; exit 1; }
section() { echo -e "\n--- $1 ---"; }

# ====================================================
# 1. DETECT DISTRO
# ====================================================
section "Detecting System"

if command -v pacman &>/dev/null; then
    DISTRO="arch"
    ok "Detected: Arch Linux"
elif command -v apt &>/dev/null; then
    DISTRO="debian"
    ok "Detected: Parrot OS / Debian"
else
    err "Unsupported distro. Only Arch and Parrot OS (apt) are supported."
fi

# ====================================================
# 2. INSTALL DEPENDENCIES
# ====================================================
section "Checking Dependencies"

install_pkg() {
    if ! command -v "$1" &>/dev/null; then
        info "Installing $1..."
        if [ "$DISTRO" = "arch" ]; then
            sudo pacman -S --noconfirm "$1"
        else
            sudo apt install -y "$1"
        fi
        ok "$1 installed"
    else
        ok "$1 already installed"
    fi
}

install_pkg git
install_pkg curl
install_pkg zsh

# ====================================================
# 3. ASK INSTALL MODE
# ====================================================
section "Install Mode"

echo ""
echo "  Choose your setup:"
echo "  [1] Full  — Oh My Zsh + Powerlevel10k + Plugins"
echo "  [2] Light — Plugins only (no Oh My Zsh)"
echo ""
read -rp "  Enter choice [1/2]: " MODE

if [[ "$MODE" != "1" && "$MODE" != "2" ]]; then
    err "Invalid choice. Run the script again and enter 1 or 2."
fi

# ====================================================
# 4. BACKUP EXISTING .zshrc
# ====================================================
section "Checking Existing Config"

if [ -f "$HOME/.zshrc" ]; then
    BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    cp "$HOME/.zshrc" "$BACKUP"
    info "Existing .zshrc backed up to $BACKUP"
else
    ok "No existing .zshrc found — fresh install"
fi

# ====================================================
# 5. FULL MODE — Oh My Zsh + Powerlevel10k
# ====================================================
if [ "$MODE" = "1" ]; then

    section "Installing Oh My Zsh"
    if [ -d "$HOME/.oh-my-zsh" ]; then
        ok "Oh My Zsh already installed"
    else
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ok "Oh My Zsh installed"
    fi

    section "Installing Powerlevel10k Theme"
    P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ -d "$P10K_DIR" ]; then
        ok "Powerlevel10k already installed"
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
        ok "Powerlevel10k installed"
    fi

    section "Installing Nerd Font (MesloLGS NF)"
    if [ "$DISTRO" = "arch" ]; then
        sudo pacman -S --noconfirm ttf-meslo-nerd && ok "MesloLGS NF installed via pacman"
    else
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
        for font in \
            "MesloLGS NF Regular.ttf" \
            "MesloLGS NF Bold.ttf" \
            "MesloLGS NF Italic.ttf" \
            "MesloLGS NF Bold Italic.ttf"; do
            curl -fsSL "$BASE/${font// /%20}" -o "$FONT_DIR/$font"
        done
        fc-cache -fv &>/dev/null
        ok "MesloLGS NF installed to $FONT_DIR"
    fi

    section "Installing Plugins"
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    for plugin in \
        "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions" \
        "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting" \
        "zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search"; do
        NAME=$(echo "$plugin" | cut -d' ' -f1)
        URL=$(echo "$plugin" | cut -d' ' -f2)
        if [ -d "$PLUGIN_DIR/$NAME" ]; then
            ok "$NAME already installed"
        else
            git clone --depth=1 "$URL" "$PLUGIN_DIR/$NAME"
            ok "$NAME installed"
        fi
    done

    section "Writing .zshrc"
    cat > "$HOME/.zshrc" << 'ZSHRC'
# ====================================================
#   Sofonyas' Zsh Config — Oh My Zsh Edition
#   github.com/sofonyas66/dotfiles
# ====================================================

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
source $ZSH/oh-my-zsh.sh

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Navigation
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS AUTO_CD
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Aliases — System
alias c="clear"
alias h="history"
alias x="exit"
alias reload="source ~/.zshrc"

# Aliases — Safety
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

# Aliases — Listing
alias ls="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lah --color=auto"
alias grep="grep --color=auto"

# Aliases — Network
alias myip="curl http://ipecho.net/plain; echo"
alias ports="netstat -tulanp"

# Aliases — Package Manager (auto-detect)
if command -v pacman &>/dev/null; then
    alias update="sudo pacman -Syu"
    alias install="sudo pacman -S"
    alias remove="sudo pacman -R"
    alias search="pacman -Ss"
elif command -v apt &>/dev/null; then
    alias update="sudo apt update && sudo apt full-upgrade -y"
    alias install="sudo apt install"
    alias remove="sudo apt remove"
    alias search="apt search"
fi

# Keybindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Tilix / VTE fix
if [ "$TILIX_ID" ] || [ "$VTE_VERSION" ]; then
  [ -f /etc/profile.d/vte-2.91.sh ] && source /etc/profile.d/vte-2.91.sh
  [ -f /etc/profile.d/vte.sh ]      && source /etc/profile.d/vte.sh
fi

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC
    ok ".zshrc written"

fi

# ====================================================
# 6. LIGHT MODE — Plugins only
# ====================================================
if [ "$MODE" = "2" ]; then

    section "Installing Plugins"
    PLUGIN_DIR="$HOME/.zsh"
    mkdir -p "$PLUGIN_DIR"

    for plugin in \
        "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions" \
        "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting"; do
        NAME=$(echo "$plugin" | cut -d' ' -f1)
        URL=$(echo "$plugin" | cut -d' ' -f2)
        if [ -d "$PLUGIN_DIR/$NAME" ]; then
            ok "$NAME already installed"
        else
            git clone --depth=1 "$URL" "$PLUGIN_DIR/$NAME"
            ok "$NAME installed"
        fi
    done

    section "Writing .zshrc"
    cat > "$HOME/.zshrc" << 'ZSHRC'
# ====================================================
#   Sofonyas' Zsh Config — Lightweight Edition
#   github.com/sofonyas66/dotfiles
# ====================================================

# Plugins
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Navigation
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS AUTO_CD
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Prompt (color-coded user/root + git branch)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b) '
setopt PROMPT_SUBST
PROMPT='%F{051}%n%f@%F{046}%m%f:%F{226}%~%f ${vcs_info_msg_0_}%# '

# Aliases — System
alias c="clear"
alias h="history"
alias x="exit"
alias reload="source ~/.zshrc"

# Aliases — Safety
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

# Aliases — Listing
alias ls="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lah --color=auto"
alias grep="grep --color=auto"

# Aliases — Network
alias myip="curl http://ipecho.net/plain; echo"
alias ports="netstat -tulanp"

# Aliases — Package Manager (auto-detect)
if command -v pacman &>/dev/null; then
    alias update="sudo pacman -Syu"
    alias install="sudo pacman -S"
    alias remove="sudo pacman -R"
    alias search="pacman -Ss"
elif command -v apt &>/dev/null; then
    alias update="sudo apt update && sudo apt full-upgrade -y"
    alias install="sudo apt install"
    alias remove="sudo apt remove"
    alias search="apt search"
fi

# Keybindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Tilix / VTE fix
if [ "$TILIX_ID" ] || [ "$VTE_VERSION" ]; then
  [ -f /etc/profile.d/vte-2.91.sh ] && source /etc/profile.d/vte-2.91.sh
  [ -f /etc/profile.d/vte.sh ]      && source /etc/profile.d/vte.sh
fi
ZSHRC
    ok ".zshrc written"

fi

# ====================================================
# 7. SET DEFAULT SHELL
# ====================================================
section "Setting Default Shell"

if [ "$SHELL" = "$(which zsh)" ]; then
    ok "Zsh is already the default shell"
else
    chsh -s "$(which zsh)"
    ok "Default shell set to Zsh"
fi

# ====================================================
# DONE
# ====================================================
echo ""
echo "=================================================="
echo "  Install complete! ✓"
echo "=================================================="
echo ""
if [ "$MODE" = "1" ]; then
    echo "  Next steps:"
    echo "  1. Set your terminal font to: MesloLGS NF"
    echo "  2. Open a new terminal"
    echo "  3. The Powerlevel10k wizard will start automatically"
    echo "     (or run: p10k configure)"
fi
echo ""
echo "  Open a new terminal to apply your config."
echo "  github.com/sofonyas66/dotfiles"
echo ""
