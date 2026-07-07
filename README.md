# How to install

Make sure you clone this repo to `${HOME}/.dotfiles` directory.

`install.sh` installs the tools below into `~/.local`, no need to install them yourself:

* neovim (latest release; use `--nvimoldglibc` for Linux with glibc < 2.31)
* rustup/cargo, then via cargo: tree-sitter-cli, protols, ripgrep, fd-find, starship
* nvm + node 24, then pyright via npm
* golang
* fzf, fzf-tab
* zsh-syntax-highlighting, zsh-autosuggestions
* tpm (tmux plugin manager)

It then symlinks the config packages in this repo with GNU Stow:
`zsh`, `nvim`, `tmux`, `alacritty`, `opencode`, `starship`, `local` (`~/.local/bin` scripts).

## Macos
* install [macports](https://www.macports.org/)
* install [GNU Stow](https://www.gnu.org/software/stow/) to install `.` files.
```bash
sudo port install stow
```
* run `install.sh`

## Linux (ubuntu)
* install [zsh](https://www.zsh.org/)
* change your shell to `zsh`
* install [GNU Stow](https://www.gnu.org/software/stow/) to install `.` files. (Most linux distros do not have this program, you may need to install it yourself)
* install `unzip` (used by nvim's mason to unpack packages such as codelldb)
* run `install.sh`

## Options
* `-n`, `--nvimoldglibc` : install the neovim build linked against older glibc (< 2.31). Linux only.

# After install
* tmux: type `<prefix>I` inside a tmux session to install the plugins listed in `tmux.conf`.

# DAP
nvim-dap wiki page ([Debug Adapter installation](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)) introduces 4 debug adaptor: gdb native, codelldb, lldb-vscode, and vscode-cpptools.
My nvim configuration uses codelldb.

codelldb is installed and managed by mason (via mason-tool-installer, see `lsp-config.lua`); nvim-dap points directly at mason's binary, so it does not need to be on `$PATH`.
