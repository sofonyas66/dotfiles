# ====================================================
#        THE "PARROT POWER" ZSH CONFIGURATION
# ====================================================

# --- 1. PLUGINS (LOAD THESE FIRST) ---
# If these files don't exist, the terminal will just skip them smoothly.
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 2. HISTORY (NEVER LOSE A COMMAND) ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY          # Append to history, don't overwrite
setopt SHARE_HISTORY           # Share history between different terminal windows
setopt HIST_IGNORE_DUPS        # Don't record the same command twice in a row
setopt HIST_IGNORE_SPACE       # specific commands with a space won't be saved (good for passwords)

# --- 3. INTELLIGENT NAVIGATION ---
setopt AUTO_PUSHD              # cd actually pushes to a stack
setopt PUSHD_IGNORE_DUPS       # Don't push duplicates
setopt AUTO_CD                 # If you type a folder name, cd into it
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# --- 4. THE "POWER" PROMPT ---
# This checks if you are root (red) or user (cyan).
# Format: [User@Hostname] [Directory] [Git Branch]
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'

# Colors
RED='%F{196}'
GREEN='%F{046}'
CYAN='%F{051}'
YELLOW='%F{226}'
RESET='%f'

# The Prompt Logic
setopt PROMPT_SUBST
PROMPT="${CYAN}%n${RESET}@${GREEN}%m${RESET}:${YELLOW}%~${RESET} \${vcs_info_msg_0_} %# "

# --- 5. GOD-TIER ALIASES (SHORTCUTS) ---
# System
alias c="clear"
alias h="history"
alias x="exit"
alias reload="source ~/.zshrc"

# Safety First (Parrot OS specific)
alias cp="cp -iv"              # Ask before overwriting files
alias mv="mv -iv"              # Ask before moving/overwriting
alias rm="rm -iv"              # Ask before deleting

# Listing Files (Colorized)
alias ls="ls --color=auto"
alias ll="ls -lh --color=auto" # List details, human readable sizes
alias la="ls -lah --color=auto" # List hidden files
alias grep="grep --color=auto"

# Quick Network Checks
alias myip="curl http://ipecho.net/plain; echo"
alias ports="netstat -tulanp"

# Parrot/Debian Maintenance
alias update="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install"
alias remove="sudo apt remove"

# --- 6. KEYBINDINGS (FIX HOME/END KEYS) ---
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# --- VTE FIX FOR TILIX ---
# This ensures that new tabs/tiles open in the same directory
if [ "$TILIX_ID" ] || [ "$VTE_VERSION" ]; then
    # Check if the file exists before sourcing to prevent errors
    if [ -f /etc/profile.d/vte-2.91.sh ]; then
        source /etc/profile.d/vte-2.91.sh
    elif [ -f /etc/profile.d/vte.sh ]; then
        source /etc/profile.d/vte.sh
    fi
fi
