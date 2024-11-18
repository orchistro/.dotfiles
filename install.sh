#!/bin/bash

unset ZSH

function run()
{
  echo "$@"
  eval "$@"
}

self_dir=$(cd -- "$(dirname "$0")" > /dev/null 2>&1; pwd -P)

# oh my zsh
echo "########################################################"
echo "Setting up oh my zsh"
echo "########################################################"
OMZ_DIR=${self_dir}/zsh/.config/oh-my-zsh
rm -rf ${OMZ_DIR}
# mkdir -p zsh/.config
ZSH=${OMZ_DIR} sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  "" \
  --unattended

# powerlevel10k
echo "########################################################"
echo "Setting up powerlover10k"
echo "########################################################"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${OMZ_DIR}/custom/themes/powerlevel10k

# tpm
# tmux 처음 실행시 <leader>I  를 이용해서 .config/tmux/tmux.conf의 플러그인 설치 필요
# tpm은 수동으로 설치
echo "########################################################"
echo "Setting up tpm (tmux plugin manager)"
echo "########################################################"
TMUX_DIR=${self_dir}/tmux/.config/tmux
rm -rf ${TMUX_DIR}/plugins
git clone https://github.com/tmux-plugins/tpm ${TMUX_DIR}/plugins/tpm

# 기존에 설치되어 있을지도 모르는 것들을 제거
echo "########################################################"
echo "Cleaning up installations that might have been installed"
echo "########################################################"
run rm -f ~/.zshrc*  # OMZ 설치시 만들어준 .zshrc제거 (추후 stow로 zshrc 설치할 것임)
run rm -rf ~/.config/nvim
run rm -rf ~/.config/oh-my-zsh
run rm -rf ~/.oh-my-zsh
run rm -rf ~/.config/tmux
run rm -rf ~/.tmux
run rm -rf ~/.tmux.conf

run rm -rf ~/.local/share/nvim

echo "########################################################"
echo "Cleaning up .local/bin/"
echo "########################################################"
for f in local/.local/bin/*;do
  run rm -f ~/.local/bin/$(basename $f)
done
git checkout local/.local/bin

if [ "$(uname)" == "Linux" ];then
  echo "########################################################"
  echo "Installing latest nvim for linux"
  echo "########################################################"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  rm -rf ~/.local/nvim-linux64
  tar -C ~/.local -xzf nvim-linux64.tar.gz
  ln -s ~/.local/nvim-linux64/bin/nvim ~/.local/bin/nvim
  rm -f nvim-linux64.tar.gz
elif [ "$(uname)" == "Darwin" ]; then
  echo "########################################################"
  echo "Installing latest nvim for macos"
  echo "########################################################"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
  rm -rf ~/.local/nvim-macos-arm64
  xattr -c nvim-macos-arm64.tar.gz
  tar -C ~/.local -xzf nvim-macos-arm64.tar.gz
  ln -s ~/.local/nvim-macos-arm64/bin/nvim ~/.local/bin/nvim 
  rm -f nvim-macos-arm64.tar.gz
fi


# GNU stow 로 링크!
echo "########################################################"
echo "Stow!!!"
echo "########################################################"
run stow nvim zsh tmux local
