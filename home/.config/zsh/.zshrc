#### General #####################################
eval $(gdircolors $ZDOTDIR/dircolors.ansi-dark)
export KEYTIMEOUT=1
setopt autocd notify

#### Prompt ######################################
autoload -Uz promptinit
promptinit
PROMPT='%F{blue}>%f '
RPROMPT='%F{yellow}%3~%f'

#### Completion ##################################
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
# Include hidden files.
_comp_options+=(globdots)

#### History #####################################
HISTFILE="$MYHIST"
HISTSIZE=SAVEHIST=10000000
setopt appendhistory extendedhistory incappendhistory
setopt histfindnodups sharehistory histignorespace

#### History searching ###########################
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

#### Vim #########################################
# j/k history search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# edit command in vim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# cursor shape for diff modes
function zle-keymap-select {
    [ $KEYMAP = vicmd ] || [ $1 = block ] &&
        echo -ne '\e[1 q'

    [ $KEYMAP = main ] || [ $KEYMAP = viins ] || [ $KEYMAP = "" ] || [ $1 = beam ] &&
        echo -ne '\e[5 q'
}
zle -N zle-keymap-select

#init `vi insert` keymap (is removed if `bindkey -V` has been set elsewhere)
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init

# Use beam shape cursor on startup.
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

#### Mac OS ######################################
FontSmoothing=$(defaults read -g CGFontRenderingFontSmoothingDisabled) 2&>/dev/null
[ "$FontSmoothing" != 0 ] &&
    defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

#### Plugins #####################################
[ -f "$ZDOTDIR/fzf.zsh" ] && source "$ZDOTDIR/fzf.zsh"
[ -f "$ZDOTDIR/alias" ] && source "$ZDOTDIR/alias"
# source <(kubectl completion zsh)
# source <(helm completion zsh)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2> /dev/null
$HOME/.local/bin/historybackup
