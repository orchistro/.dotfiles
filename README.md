# How to install

Make sure you clone this repo to `${HOME}/.dotfiles` directory.

## Macos
* install [macports](https://www.macports.org/)
* install `cargo` : to install [protols](https://github.com/coder3101/protols)(lsp for google's [protocol buffers](https://protobuf.dev/))
```bash
sudo port install cargo
cargo install protols
```
* install [GNU Stow](https://www.gnu.org/software/stow/) to install `.` files.
```bash
sudo port install stow
```
* run `install.sh`
* note that you don't need to install neovim. The `install.sh` script downloads the latest neovim and put it in `.local/bin/`.

## Linux (ubuntu)
* install [zsh](https://www.zsh.org/)
* install `cargo` : to install [protols](https://github.com/coder3101/protols)(lsp for google's [protocol buffers](https://protobuf.dev/))
```bash
sudo apt install cargo
cargo install protols
```
* change your shell to `zsh`
* install [GNU Stow](https://www.gnu.org/software/stow/) to install `.` files.
(Most linux distros do not have this program, you may need to install it yourself)
* run `install.sh`

# DAP
nvim-dap wiki page ([Debug Adapter installation](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)) introduces 4 debug adaptor: gdb native, codelldb, lldb-vscode, and vscode-cpptools.
My nvim configuration uses codelldb

Currently installing codelldb directly. Need to have mason to handle installing adapters. 
