# constants
export HISTFILESIZE=10000
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt INC_APPEND_HISTORY # command are directly entered in the HISTFILE instead of waiting for the shell to close
setopt HIST_FIND_NO_DUPS # removes the duplicates while searching
setopt HIST_IGNORE_ALL_DUPS # ignores all duplicates while writing in the hist file
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPs
setopt HIST_IGNORE_DUPS

# Make zsh xdg compliant
HISTFILE="$XDG_STATE_HOME"/zsh/history
# Completion files: Use XDG dirs
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

# Add a directory to the PATH variable
addToPath ()
{
    if [ -d $1 ]; then
        export PATH=$1:$PATH
    fi
}

# environment variables
export BUN_INSTALL="$XDG_DATA_HOME/bun" #bun
export TMUXIFIER_LAYOUT_PATH="$XDG_DATA_HOME/tmux/sessions" #tmuxifier
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"

# add to path
addToPath "$BUN_INSTALL/bin" #bun
addToPath "$GOPATH/bin" #go
addToPath "$CARGO_HOME/bin" #rust
addToPath "$XDG_DATA_HOME/tmux/plugins/tmuxifier/bin" #tmuxifier

# to initialize zap plugin manager
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"


# plug = source
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "Aloxaf/fzf-tab"

# plug "${XDG_CONFIG_HOME}/zsh/zsh_prompt.zsh" # prompt for zsh
eval "$(starship init zsh)"
plug "${XDG_CONFIG_HOME}/zsh/env.zsh" # aliases for zsh
plug "${XDG_CONFIG_HOME}/zsh/zsh_aliases.zsh" # aliases for zsh
# plug "${XDG_CONFIG_HOME}/zsh/plugins/*" # local plugins for zsh switched to bin folder
plug "${XDG_DATA_HOME}/bun/_bun" # autocompletion for bun
plug "${XDG_DATA_HOME}/sdkman/bin/sdkman-init.sh" # sdkman

fpath=($XDG_DATA_HOME/zsh/completions $fpath)


fastfetch


# Load and initialise completion system
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION # caching zsh completions using XDG base dir

# caching zsh completions
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh"
zstyle ':completion::complete:*' use-cache on

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# vi mode
bindkey -v
bindkey '^[^M' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

bindkey -s "^ " "tmux_sessionizer.sh\n"

eval "$(zoxide init zsh)"
source <(fzf --zsh)
