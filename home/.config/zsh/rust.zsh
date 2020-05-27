export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PATH="$CARGO_HOME/bin:$PATH"
which -s rustc > /dev/null 2>&1 &&
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
