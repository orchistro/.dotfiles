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

source ${self_dir}/zsh/.zshenv # XDG_* definitions

function usage() {
  cat <<EOF
Usage:
  $(basename "$0") [OPTIONS]

Options:
  -c, --cargo
        Install Cargo (Rust toolchain)

  -n, --nvimoldglibc
        Install Neovim build compatible with older glibc

  -h, --help
        Show this help message and exit

Description:
  This script installs and configures development tools.
  Long options are supported via an internal compatibility layer
  and mapped to short options before parsing.

Examples:
  $(basename "$0") -c
  $(basename "$0") --cargo
  $(basename "$0") -c -n
  $(basename "$0") --cargo --nvimoldglibc

Notes:
  - Options must appear before positional arguments.
  - '--' can be used to explicitly terminate option parsing.

EOF
  exit 0
}


args=()
for arg in "$@"; do
  case "$arg" in
    --cargo) args+=("-c") ;;
    --nvimoldglibc) args+=("-n") ;;
    --help) args+=("-h") ;;
    *) args+=("$arg") ;;
  esac
done

set -- "${args[@]}"

opt_install_cargo="no"
opt_nvim="latest"

while getopts "cnh" opt; do
  case "$opt" in
    c)
      echo "[OPT] cargo option set"
      opt_install_cargo="yes"
      ;;
    n)
      echo "[OPT] neovim for older glibc option set"
      opt_nvim="older-glibc"
      ;;
    h)
      usage
      ;;
    ?)
      usage
      ;;
  esac
done

shift $((OPTIND - 1))

# checking stow
echo "########################################################"
echo "Checking stow"
STOW=stow
if ! command -v ${STOW} >/dev/null 2>&1; then
  STOW=/opt/local/bin/stow
  if ! command -v ${STOW} >/dev/null 2>&1; then
    echo "❌ GNU stow not found. Aborting."
    exit 1
  fi
fi
echo "..OK"
echo "########################################################"

function prepdir() {
  local parent=$1
  shift 1
  local dirs=( $@ )

  for d in ${dirs[@]}; do
    run rm -rf ${HOME}/${parent}/${d}
    run mkdir -p ${HOME}/${parent}/${d}
  done
}

echo "########################################################"
echo "Preparing .config directory"
echo "########################################################"
prepdir .config zsh nvim tmux

echo "########################################################"
echo "Preparing .local directory"
echo "########################################################"
prepdir .local state fzf # share : .local/share .local/bin may contain zsh installation

echo "########################################################"
echo "Preparing .local/state directory"
echo "########################################################"
prepdir .local/state zsh less

# oh my zsh
echo "########################################################"
echo "Setting up oh my zsh"
echo "########################################################"
OMZ_DIR=${XDG_CONFIG_HOME}/oh-my-zsh
run rm -rf ${OMZ_DIR}
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
TMUX_DIR=${XDG_CONFIG_HOME}/tmux
run rm -rf ${TMUX_DIR}
run mkdir ${TMUX_DIR}
run git clone https://github.com/tmux-plugins/tpm ${TMUX_DIR}/plugins/tpm

# .local/bin 은 디렉토리여야만 한다.
# 각 시스템 고유의 bin이 필요하면 설치할 것이고,
# 그것들이 repo에 들어와서는 안되기 때문
# 이미 디렉토리로 존재하면 그냥 두고, 그렇지 않으면 디렉토리를 만들어 주어서
# bin 통째로 링크가 걸리는 것은 막아야 한다
echo "########################################################"
echo "Preparing .local/bin"
echo "########################################################"
if [ ! -e ${HOME}/.local/bin ]; then
  mkdir -p ${HOME}/.local/bin
fi

if [ -L ${HOME}/.local/bin ]; then
  rm -f ${HOME}/.local/bin
  mkdir -p ${HOME}/.local/bin
fi

# 기존에 설치되어 있을지도 모르는 것들을 제거
echo "########################################################"
echo "Cleaning up installations that might have been installed"
echo "########################################################"
run rm -f ~/.zshrc*  # OMZ 설치시 만들어준 .zshrc제거 (추후 stow로 zshrc 설치할 것임)

run rm -rf ~/.oh-my-zsh
run rm -rf ~/.tmux
run rm -rf ~/.tmux.conf

run rm -rf ~/.local/bin/nvim

echo "########################################################"
echo "Installing nvim"
echo "########################################################"

run rm -rf ${HOME}/.local/nvim*

# nvim 실행시 생성되는 lock파일 등이 repo에 생성되는 것을 막으려면
# .config/nvim 디렉토리를 생성해 두어서 .config/nvim이 디렉토리 통째로
# 링크가 걸리는 것을 막아야 한다
run rm -rf ${XDG_CONFIG_HOME}/nvim
run mkdir -p ${XDG_CONFIG_HOME}/nvim

function install_latest_nvim() {
  local os=
  if [ "$(uname)" == "Linux" ]; then
    os="linux-x86_64"
  elif [ "$(uname)" == "Darwin" ]; then
    os="macos-arm64"
  fi
  echo "Installing latest nvim for ${os}"
  run curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-${os}.tar.gz
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
  echo "Installing nvim linked with older glibc(version < 2.31) for ${os}"
  run curl -LO https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.tar.gz
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
# run stow -D nvim zsh tmux local # 먼저 지운 후에
run ${STOW} nvim
run ${STOW} zsh
run ${STOW} tmux
run ${STOW} local

echo "########################################################"
echo "installing cargo for protols"
echo "########################################################"
# installing protols for parsing protobuf files
function install_cargo_protols() {
  # rustup!
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

  cargo install protols
}

if [ "${opt_install_cargo}" == "yes" ]; then
  run cargo --version && cargo install protols || install_cargo_protols
fi

echo "########################################################"
echo "Installing tree-sitter-cli"
echo "########################################################"
cargo install --locked tree-sitter-cli

echo "########################################################"
echo "Installing fzf"
echo "########################################################"
FZF_DIR=${HOME}/.local/fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ${FZF_DIR}
${FZF_DIR}/install --xdg --key-bindings --completion --no-update-rc

echo "########################################################"
echo "Installing fzf-tab"
echo "########################################################"
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-${OMZ_DIR}/custom}/plugins/fzf-tab

echo "########################################################"
echo "Installing codelldb"
echo "########################################################"
run rm -rf ~/.local/codelldb
run mkdir -p ~/.local/codelldb
run curl -LO https://github.com/vadimcn/codelldb/releases/download/v1.11.4/codelldb-linux-x64.vsix
run mv codelldb-linux-x64.vsix ~/.local/codelldb
run cd ~/.local/codelldb
run unzip -q codelldb-linux-x64.vsix

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
