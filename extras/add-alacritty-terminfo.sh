#!/bin/sh

temp=$(mktemp)
raw_url="https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info"

curl --silent "$raw_url" > "$temp"
sudo tic -xe alacritty,alacritty-direct "$temp" && echo "done"

rm "$temp"
