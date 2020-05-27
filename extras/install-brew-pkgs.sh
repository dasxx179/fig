#!/bin/sh
# Generate list of installed progs: brew leaves

progs_list=" \
neovim
zsh
zsh-syntax-highlighting
pacapt
lazygit
git-delta
hub
bat
fzf
ripgrep
fd
lf
jq
yq
htop
coreutils
sc-im
tree
tokei
watch
lazydocker
docker-completion
kubernetes-cli
kubernetes-helm
golangci/tap/golangci-lint
shellcheck"

echo "$progs_list" | xargs brew install
