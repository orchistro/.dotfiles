ZDOTDIR=${HOME}/.config/zsh

export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state

export CARGO_HOME=${HOME}/.local/cargo
export RUSTUP_HOME=${HOME}/.local/rustup

if [ -e "${HOME}/.local/cargo/env" ]; then
  source "${HOME}/.local/cargo/env"
fi

if [ -e "$HOME/.local/share/../bin/env" ]; then
  source "$HOME/.local/share/../bin/env"
fi
