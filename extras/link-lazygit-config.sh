#!/bin/sh

apple_path="${HOME}/Library/Application Support/jesseduffield/lazygit"
desired_path="${HOME}/.config/jesseduffield/lazygit"

temp_dir=$(mktemp -d)
mkdir -p "$temp_dir/{library,config}"

[ ! -L "$apple_path" ] && [ -d "$apple_path" ] &&
    mv "$apple_path/" "$temp_dir/library" &&
    echo "Moved existing lazygit configs in ~/Library to $temp_dir"

[ ! -L "$desired_path" ] && [ -d "$desired_path" ] &&
    mv "$desired_path/" "$temp_dir/config" &&
    echo "Moved existing lazygit configs in ~/.config to $temp_dir"

mkdir -p "$(dirname "$desired_path")" "$(dirname "$apple_path")"

ln -sFh "$desired_path" "$apple_path"
