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
* ~install [Neovim](https://neovim.io/)~ the `install.sh` script downloads the latest neovim and put it in `.local/bin/`
```bash
sudo port install neovim
```
* run `install.sh`

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
