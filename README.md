# How to install

Make sure you clone this repo to `${HOME}/.dotfiles` directory.

## Macos
* install [macports](https://www.macports.org/)
* install `cargo` : to install `protols`(lsp for google's protocolbuf)
```bash
sudo port install cargo
cargo install protols
```
* install [GNU Stow](https://www.gnu.org/software/stow/) to install .dot files.
```bash
sudo port install stow
```
* install `neovim`
```bash
sudo port install neo-vim
```
* run `install.sh`

## Linux
* install [zsh](https://www.zsh.org/)
* change your shell to `zsh`
* install [GNU Stow](https://www.gnu.org/software/stow/) to install `.` files.
(Most linux distros do not have this program, you may need to install it yourself)
* run `install.sh`
