# ====================================================
#     SOFONYAS' ZSH CONFIG — Arch + Oh My Zsh Edition
# ====================================================

# --- POWERLEVEL10K INSTANT PROMPT (must be at top) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- OH MY ZSH SETUP ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# --- HISTORY (NEVER LOSE A COMMAND) ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# --- INTELLIGENT NAVIGATION ---
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt AUTO_CD
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# --- ALIASES ---
# System
alias c="clear"
alias h="history"
alias x="exit"
alias reload="source ~/.zshrc"

# Safety First
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

# Listing Files
alias ls="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lah --color=auto"
alias grep="grep --color=auto"

# Network
alias myip="curl http://ipecho.net/plain; echo"
alias ports="netstat -tulanp"

# Arch/Pacman (replacing apt aliases)
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias remove="sudo pacman -R"
alias search="pacman -Ss"
alias cleanup="sudo pacman -Rns $(pacman -Qdtq)"  # Remove orphans

# --- KEYBINDINGS ---
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# --- TILIX / VTE FIX ---
if [ "$TILIX_ID" ] || [ "$VTE_VERSION" ]; then
  [ -f /etc/profile.d/vte-2.91.sh ] && source /etc/profile.d/vte-2.91.sh
  [ -f /etc/profile.d/vte.sh ]      && source /etc/profile.d/vte.sh
fi

# --- POWERLEVEL10K CONFIG ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh