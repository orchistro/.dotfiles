#!/bin/bash

unset ZSH

function run() {
  echo "> [$(pwd)] $@"
  eval "$@"
}

self_dir=$(cd -- "$(dirname "$0")" > /dev/null 2>&1; pwd -P)

function usage() {
  cat <<EOF
Usage: $(basename $0) [OPT]

DESCRIPTION
       sets up environment

Options:
  --nocargo  Skip installing cargo and protols
  --nvim09   Install neovim0.9 instead of latest (for older distros like CentOS7)

EOF
  exit
}

ARGS=$(getopt -o 'h' --long 'nocargo,nvim09,help' -n "$(basename $0)" -- "$@") || usage
eval set -- "${ARGS}"

opt_install_cargo="yes"
opt_nvim="latest"

while true; do
  case "$1" in
    --nocargo)
      echo "[OPT] no cargo option set"
      opt_install_cargo="no"
      shift
      ;;
    --nvim09)
      echo "[OPT] neovim 0.9 option set"
      opt_nvim="0.9"
      shift
      ;;
    -h | --help)
      usage
      ;;
    --)
      shift
      break
      ;;
    -*)
      error "unknown option: $1"
      ;;
    *)
      error 'internal error'
      ;;
  esac
done

# oh my zsh
echo "########################################################"
echo "Setting up oh my zsh"
echo "########################################################"
OMZ_DIR=${self_dir}/zsh/.config/oh-my-zsh
run rm -rf ${OMZ_DIR}
# mkdir -p zsh/.config
ZSH=${OMZ_DIR} sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  "" \
  --unattended

# powerlevel10k
echo "########################################################"
echo "Setting up powerlover10k"
echo "########################################################"
run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${OMZ_DIR}/custom/themes/powerlevel10k

# tpm
# tmux 처음 실행시 <leader>I  를 이용해서 .config/tmux/tmux.conf의 플러그인 설치 필요
# tpm은 수동으로 설치
echo "########################################################"
echo "Setting up tpm (tmux plugin manager)"
echo "########################################################"
TMUX_DIR=${self_dir}/tmux/.config/tmux
run rm -rf ${TMUX_DIR}/plugins
run git clone https://github.com/tmux-plugins/tpm ${TMUX_DIR}/plugins/tpm

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
run rm -rf ~/.local/bin/nvim

echo "########################################################"
echo "Cleaning up ~/.local/bin/"
echo "########################################################"
for f in local/.local/bin/*;do
  run rm -f ~/.local/bin/$(basename $f)
done
run git checkout local/.local/bin

function install_latest_nvim() {
  local os=
  if [ "$(uname)" == "Linux" ]; then
    os="linux-x86_64"
  elif [ "$(uname)" == "Darwin" ]; then
    os="macos-arm64"
  fi
  echo "########################################################"
  echo "Installing latest nvim for ${os}"
  echo "########################################################"
  run curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-${os}.tar.gz
  run rm -rf ~/.local/nvim*
  run tar -C ~/.local -xzf nvim-${os}.tar.gz
  run ln -s ~/.local/nvim-${os}/bin/nvim ~/.local/bin/nvim
  run rm -f nvim-${os}.tar.gz
}

function install_nvim_0_9() {
  local os=
  if [ "$(uname)" == "Linux" ]; then
    os="linux64"
  elif [ "$(uname)" == "Darwin" ]; then
    os="macos"
  fi
  echo "########################################################"
  echo "Installing old nvim(0.9) for ${os}"
  echo "########################################################"
  run curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-${os}.tar.gz
  run rm -rf ~/.local/nvim*
  run tar -C ~/.local -xzf nvim-${os}.tar.gz
  run ln -s ~/.local/nvim-${os}/bin/nvim ~/.local/bin/nvim
  run rm -f nvim-${os}.tar.gz
}

if [ "${opt_nvim}" == "latest" ]; then
  install_latest_nvim
else
  install_nvim_0_9
fi


# GNU stow 로 링크!
echo "########################################################"
echo "Stow!!!"
echo "########################################################"
run stow nvim zsh tmux local

echo "########################################################"
echo "installing cargo for protols"
echo "########################################################"
# installing protols for parsing protobuf files
function install_cargo_protols() {
  if [ "$(uname)" == "Linux" ];then
    run sudo apt install cargo --yes
  elif [ "$(uname)" == "Darwin" ]; then
    run sudo port -N install cargo
  fi

  cargo install protols
}

if [ "${opt_install_cargo}" == "yes" ]; then
  run cargo --version && cargo install protols || install_cargo_protols
fi

echo "########################################################"
echo "adding essentials to .bashrc"
echo "########################################################"
function clear_bashrc() {
  begin=$(grep -n '# BEGIN bashrc for orchistro' ~/.bashrc | cut -d : -f 1)
  end=$(grep -n '# END bashrc for orchistro' ~/.bashrc | cut -d : -f 1)
  head -n $((begin - 2)) ~/.bashrc > clean_bashrc
  tail -n +$((end + 2)) ~/.bashrc >> clean_bashrc
  mv clean_bashrc ~/.bashrc
}

grep -n '# BEGIN bashrc for orchistro' ~/.bashrc && clear_bashrc
cat ${self_dir}/bashrc >> ${HOME}/.bashrc

echo "########################################################"
echo "Done!!"
echo "In case you want to use tmux, you should type <prefix>I"
echo "inside your tmux session to install tmux plugins"
echo "########################################################"
