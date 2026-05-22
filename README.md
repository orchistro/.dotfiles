# How to install

Make sure you clone this repo to `${HOME}/.dotfiles` directory.

`cargo`, `go`, and `neovim` will be installed via `install.sh` script, no need to install them.

## Macos
* install [macports](https://www.macports.org/)
* install [GNU Stow](https://www.gnu.org/software/stow/) to install `.` files.
```bash
sudo port install stow
```
* install node/npm for installing pyright
* run `install.sh`

## Linux (ubuntu)
* install [zsh](https://www.zsh.org/)
* change your shell to `zsh`
* install [GNU Stow](https://www.gnu.org/software/stow/) to install `.` files. (Most linux distros do not have this program, you may need to install it yourself)
* install node/npm for installing pyright
* run `install.sh`

# DAP
nvim-dap wiki page ([Debug Adapter installation](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)) introduces 4 debug adaptor: gdb native, codelldb, lldb-vscode, and vscode-cpptools.
My nvim configuration uses codelldb

Currently installing codelldb directly. Need to have mason to handle installing adapters. 
