#!/bin/bash

unset ZSH

function run() {
  echo "> [$(pwd)] $@"
  eval $@
}

function error() {
  >&2 echo $@
  exit 1
}

self_dir=$(cd -- "$(dirname "$0")" > /dev/null 2>&1; pwd -P)

function usage() {
  cat <<EOF
Usage: $(basename $0) [OPT]

DESCRIPTION
       sets up environment

Options:
  --cargo         Install cargo and protols
  --nvimoldglibc  Install neovim linked with glibc of version less than 2.31.
                  (For older distros like CentOS7, available only for Linuxes)

EOF
  exit
}

ARGS=$(getopt -o 'h' --long 'cargo,nvimoldglibc,help' -n "$(basename $0)" -- "$@") || usage
eval set -- "${ARGS}"

opt_install_cargo="no"
opt_nvim="latest"

while true; do
  case "$1" in
    --cargo)
      echo "[OPT] no cargo option set"
      opt_install_cargo="yes"
      shift
      ;;
    --nvimoldglibc)
      echo "[OPT] neovim for older glibc option set"
      opt_nvim="older-glibc"
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
      error "internal error"
      ;;
  esac
done

# checking stow
echo "########################################################"
echo "Checking stow"
echo "########################################################"
which stow || (echo "You should install GNU stow first.";exit 1)

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

echo "########################################################"
echo "Setting up zsh plugins"
echo "########################################################"
run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git    ${OMZ_DIR}/custom/themes/powerlevel10k
run git clone https://github.com/zsh-users/zsh-syntax-highlighting.git  ${OMZ_DIR}/plugins/zsh-syntax-highlighting
run git clone https://github.com/zsh-users/zsh-autosuggestions          ${OMZ_DIR}/plugins/zsh-autosuggestions
run cp autosuggestions.zsh ${OMZ_DIR}/custom/autosuggestions.zsh

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

function install_nvim_older_glibc() {
  local os=
  if [ "$(uname)" == "Linux" ]; then
    os="linux-x86_64"
  else
    echo "error: nvim for older glibc is available only for Linux."
    return
  fi
  echo "#################################################################"
  echo "Installing nvim linked with older glibc(version < 2.31) for ${os}"
  echo "#################################################################"
  run curl -LO https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.tar.gz
  run rm -rf ~/.local/nvim*
  run tar -C ~/.local -xzf nvim-${os}.tar.gz
  run ln -s ~/.local/nvim-${os}/bin/nvim ~/.local/bin/nvim
  run rm -f nvim-${os}.tar.gz
}

if [ "${opt_nvim}" == "latest" ]; then
  install_latest_nvim
else
  install_nvim_older_glibc
fi

# GNU stow 로 링크!
echo "########################################################"
echo "Stow!!!"
echo "########################################################"
run stow -D nvim zsh tmux local # 먼저 지운 후에
run stow nvim zsh tmux local    # 설치

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
echo "Installing codelldb"
echo "########################################################"
run rm -rf ~/.local/codelldb
run mkdir -p ~/.local/codelldb
run curl -LO https://github.com/vadimcn/codelldb/releases/download/v1.11.4/codelldb-linux-x64.vsix
run mv codelldb-linux-x64.vsix ~/.local/codelldb
run cd ~/.local/codelldb
run unzip codelldb-linux-x64.vsix

echo "########################################################"
echo "Configuring bashrc and vimrc"
echo "########################################################"
function clear_bashrc() {
  begin=$(grep -n '# BEGIN bashrc for orchistro' ~/.bashrc | cut -d : -f 1)
  end=$(grep -n '# END bashrc for orchistro' ~/.bashrc | cut -d : -f 1)
  head -n $((begin - 2)) ~/.bashrc > clean_bashrc
  tail -n +$((end + 2)) ~/.bashrc >> clean_bashrc
  mv clean_bashrc ~/.bashrc
}

if [[ -e ${HOME}/.bashrc ]]; then
  grep -n '# BEGIN bashrc for orchistro' ~/.bashrc && clear_bashrc
fi
cat ${self_dir}/bashrc >> ${HOME}/.bashrc

cp ${self_dir}/vimrc ${HOME}/.vimrc

echo "########################################################"
echo "Done!!"
echo "In case you want to use tmux, you should type <prefix>I"
echo "inside your tmux session to install tmux plugins"
echo "########################################################"
