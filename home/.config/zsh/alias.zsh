#### Default Options #############################
alias ls="ls -Hp"
alias bc="bc -q"

#### Shortcut ####################################
alias vim="$EDITOR"
alias vi="$EDITOR"
alias v="$EDITOR"
alias la="ls -HpA"
alias ll="ls -Hpl"
alias ww="$EDITOR ~/.local/vimwiki/index.wiki"
alias ldk="lazydocker"
alias yay="pacapt"
alias lg="lazygit"
alias cl="clear"
alias cls="clear && ls"
alias cll="printf '\033\143'"
alias hb="hub browse"
alias :q="exit"
alias k="kubectl"
alias l="lfcd"
alias j="jump"
alias c="jump"
alias loc="tokei -s code"
alias page="$PAGER --paging=always"
alias bat="bat --paging=never"

#### Configs #####################################
alias .zsh="$EDITOR $ZDOTDIR/.zshrc"
alias .alias="$EDITOR $ZDOTDIR/alias.zsh"
alias .env="$EDITOR $HOME/.zprofile"
alias .nvim="$EDITOR $XDG_CONFIG_HOME/nvim/init.vim"
alias .hist="$EDITOR $MYHIST"

#### Functions ###################################
up() { fc -e "sed -i \"\" -e \"s| | $* |\"" }
up2() { fc -e "sed -i \"\" -e \"s| | $* |2\"" }

ip() { ifconfig | grep "inet " | tail -1 | cut -d " " -f 2 }

glog() { git log --oneline --no-decorate "-${1:-5}" ${@:2} }

bak() { cp -r "$1" "$1.bak" }
unbak() { mv "$1" $(sed "s/.bak$//" <<< "$1") }

mksh() { echo "#!/bin/sh" >> "$1" && chmod +x "$1" && "$EDITOR" "$1" }

#### Fzf #########################################
# go to one of the lastest dirs
gl() {
    goto=$(cat "$DIRSTACKFILE" | fzf --reverse)
    [ "$goto" ] && cd "$goto"
}

# go to a repo
gr() {
    repo="$(cd ~/repos && fd -d1 | fzf --reverse)"
    [ "$repo" ] && cd "$HOME/repos/$repo"
}

# go to a repo (recursive)
grr() {
    repo="$(cd ~/repos && fd -d3 -t d -I -H "^.git$" |
        rev | cut -c 6- | rev | fzf --reverse)"
    [ "$repo" ] && cd "$HOME/repos/$repo"
}

# open a repo in the browser
or() {
    prev_dir=$(pwd) && gr && hub browse; cd "$prev_dir"
}

# use lazygit on one or more repos
lr() {
    for repo in $(cd ~/repos && fd -d1 | fzf --reverse --multi); do
        lazygit -p "$HOME/repos/$repo"
    done
}

# go to a dir in temp
gt() {
    dir="$(cd ~/temp && fd -t d | fzf --reverse)"
    [ "$dir" ] && cd "$HOME/temp/$dir"
}

# edit a file in temp
et() {
    file="$(cd ~/temp && fd -t f | fzf --reverse)"
    [ "$file" ] && "$EDITOR" "$HOME/temp/$file"
}

# go to a dir in save
gs() {
    dir="$(cd ~/save && fd -t d | fzf --reverse)"
    [ "$dir" ] && cd "$HOME/save/$dir"
}

# edit a file in temp
es() {
    file="$(cd ~/save && fd -t f | fzf --reverse)"
    [ "$file" ] && "$EDITOR" "$HOME/save/$file"
}

# edit a vimwiki page
ew() {
    wiki=$(cd ~/.local/vimwiki && fd | fzf --reverse)
    [ "$wiki" ] && "$EDITOR" "$HOME/.local/vimwiki/$wiki"
}

#### Save lf Dir #################################
lfcd () {
    tmp="$(mktemp)"
    # ~/repos/lf/lf-hiddenfiles -last-dir-path="$tmp" "$@"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

#### Jump ########################################
# jump FOO: jump to a mark named FOO
# mark FOO: create a mark named FOO
# unmark FOO: delete a mark
# marks: lists all marks

markfile="$XDG_DATA_HOME/lf/marks"

marks() {
    cat "$markfile" | tr ':' ' '

}

jump() {
    new_dir=$(marks | fzf --reverse | cut -f 2 -d ' ')
    [ "$new_dir" ] && cd "$new_dir"
}

mark() {
    [[ $# != 1 ]] &&
        echo "Must be 1 char" &&
        return 1

    grep "^${1}:" "$markfile" &&
        echo "Char already assigned" &&
        return 1

    echo "${1}:$PWD" >> "$markfile"
}

unmark() {
    [[ $(uname -s) == Darwin ]] &&
        sed -i '' -e "/^${1}:/d" "$markfile" &&
        return 0

    sed -i "/^${1}:/d" "$markfile"
}
