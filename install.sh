#!/bin/bash

unset ZSH

run() {
  if [ -t 1 ]; then
    CYAN="\033[0;36m"
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    RESET="\033[0m"
  else
    CYAN=""; RED=""; GREEN=""; RESET=""
  fi

  printf "${CYAN}+ "
  printf '%q ' "$@"
  printf "${RESET}\n"

  "$@"
  status=$?

  if [ $status -eq 0 ]; then
    printf "${GREEN}✔ success${RESET}\n"
  else
    printf "${RED}✘ failed (exit %d)${RESET}\n" "$status"
  fi

  return $status
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
  -n, --nvimoldglibc
        Install Neovim build compatible with older glibc

  -h, --help
        Show this help message and exit

Description:
  This script installs and configures development tools.
  Long options are supported via an internal compatibility layer
  and mapped to short options before parsing.

Examples:
  $(basename "$0") -n
  $(basename "$0") --nvimoldglibc

Notes:
  - Options must appear before positional arguments.
  - '--' can be used to explicitly terminate option parsing.

EOF
  exit 0
}


args=()
for arg in "$@"; do
  case "$arg" in
    --nvimoldglibc) args+=("-n") ;;
    --help) args+=("-h") ;;
    *) args+=("$arg") ;;
  esac
done

set -- "${args[@]}"

opt_install_protols="no"
opt_nvim="latest"

while getopts "nh" opt; do
  case "$opt" in
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
prepdir .config zsh nvim tmux alacritty
# opencode: opencode.json 등 기존 설정을 보존하기 위해 디렉토리 통째로 날리지 않고
# stow가 관리하는 파일만 정리. themes/는 디렉토리 통째로 심링크
run mkdir -p ${HOME}/.config/opencode
run rm -rf ${HOME}/.config/opencode/themes
run rm -f ${HOME}/.config/opencode/tui.json

echo "########################################################"
echo "Preparing .local directory"
echo "########################################################"
prepdir .local state fzf # share : .local/share .local/bin may contain zsh installation

echo "########################################################"
echo "Preparing .local/state directory"
echo "########################################################"
prepdir .local/state zsh less

# zsh plugins
# oh-my-zsh / powerlevel10k 없이 ~/.local 에 독립 설치한다.
# (프롬프트는 starship, TAB 완성은 fzf-tab, 플러그인 source 는 .zshrc 가 직접 처리)
echo "########################################################"
echo "Setting up zsh plugins"
echo "########################################################"
run rm -rf ${HOME}/.local/zsh-syntax-highlighting
run git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.local/zsh-syntax-highlighting
run rm -rf ${HOME}/.local/zsh-autosuggestions
run git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions          ${HOME}/.local/zsh-autosuggestions

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
run rm -f ~/.zshrc*  # 혹시 남아있을 ~/.zshrc + OMZ 백업(.zshrc.pre-oh-my-zsh 등) 제거 (zsh 설정은 stow 로 ZDOTDIR 에 설치됨)

# oh-my-zsh / powerlevel10k 잔재를 모두 찾아 제거 (이제 starship + 독립 플러그인으로 대체)
run rm -rf ~/.oh-my-zsh ${XDG_CONFIG_HOME}/oh-my-zsh   # OMZ 본체 (custom/plugins/themes 포함)
run rm -rf ${XDG_CACHE_HOME}/oh-my-zsh                  # OMZ 캐시/로그
run rm -f  ~/.p10k.zsh ${ZDOTDIR}/.p10k.zsh            # powerlevel10k 설정 파일
run rm -rf ${XDG_CACHE_HOME}/p10k-*                     # p10k instant-prompt 캐시/덤프
run rm -f  ${ZDOTDIR}/.zcompdump* ~/.zcompdump*        # 스테일 compinit 덤프 (재생성됨)
run rm -f  ~/.bashrc ~/.vimrc                          # 예전 install.sh 가 만들던 파일 (이제 미사용)
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
run ${STOW} alacritty
run ${STOW} opencode
run ${STOW} starship
run ${STOW} local

echo "########################################################"
echo "installing rustup"
echo "########################################################"
run rm -rf ${HOME}/.local/cargo
run rm -rf ${HOME}/.local/rustup
rustup_install=rustup_install.sh
export RUSTUP_INIT_SKIP_PATH_CHECK=y
# --no-modify-path: keep rustup from adding source cargo/env at the end of .zshenv
run curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf --output ${rustup_install}
run chmod +x ${rustup_install}
run ./${rustup_install} -y --no-modify-path
run rm -f ${rustup_install}
run source ${HOME}/.local/cargo/env

echo "########################################################"
echo "Installing tree-sitter-cli"
echo "########################################################"
run cargo install --locked tree-sitter-cli

echo "########################################################"
echo "installing protols ripgrep fdfind"
echo "########################################################"
run cargo install protols ripgrep fd-find

echo "########################################################"
echo "installing starship (prompt; powerlevel10k 대체)"
echo "########################################################"
# 다른 방법(공식 스크립트·brew 등)으로 깔려 있을 수 있는 기존 starship 을 먼저 지우고 cargo 로 재설치.
# .zshrc PATH 에서 ~/.local/bin 이 cargo/bin 보다 앞서므로, 떠도는 ~/.local/bin/starship 도 제거한다.
run rm -f ${HOME}/.local/bin/starship
run cargo install --locked --force starship

echo "########################################################"
echo "installing nvm + node.js"
echo "########################################################"
run rm -rf ${XDG_CONFIG_HOME}/nvm
# nvm 설치 위치를 XDG 로 고정한다. 설치 스크립트가 NVM_DIR 을 참조하므로 실행 *전에* export 해야
# ~/.nvm 가 아니라 ${XDG_CONFIG_HOME}/nvm 에 설치되고, 이후 nvm.sh source 경로와 일치한다.
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
nvm_install=nvm_install.sh
run curl -L https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh --output ${nvm_install}
run chmod +x ${nvm_install}
run ./${nvm_install}
run rm -f ${nvm_install}

[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

run nvm install 24  # this installs node 24

echo "########################################################"
echo "installing pyright"
echo "########################################################"
run npm install -g pyright

echo "########################################################"
echo "installing golang"
echo "########################################################"
function install_golang() {
  local os=
  if [ "$(uname)" == "Linux" ]; then
    os="linux-amd64"
  elif [ "$(uname)" == "Darwin" ]; then
    os="darwin-arm64"
  fi
  local pkg=go1.26.0.${os}.tar.gz
  rm -rf ${HOME}/.local/go
  echo "Installing golang for $(uname)"
  run curl -LO https://go.dev/dl/${pkg}
  run tar -C ~/.local -xzf ${pkg}
  run rm -f ${pkg}
}

install_golang

echo "########################################################"
echo "Installing fzf"
echo "########################################################"
FZF_DIR=${HOME}/.local/fzf
run git clone --depth 1 https://github.com/junegunn/fzf.git ${FZF_DIR}
run ${FZF_DIR}/install --xdg --key-bindings --completion --no-update-rc

echo "########################################################"
echo "Installing fzf-tab"
echo "########################################################"
run rm -rf ${HOME}/.local/fzf-tab
run git clone --depth=1 https://github.com/Aloxaf/fzf-tab ${HOME}/.local/fzf-tab

echo "########################################################"
echo "Installing codelldb"
echo "########################################################"
# OS·아키텍처에 맞는 vsix 를 받는다.
# 에셋 이름: codelldb-{darwin|linux|win32}-{arm64|x64|armhf}.vsix
function install_codelldb() {
  local os= arch=
  case "$(uname)" in
    Linux)  os="linux" ;;
    Darwin) os="darwin" ;;
    *)      echo "error: unsupported OS for codelldb: $(uname)"; return ;;
  esac
  case "$(uname -m)" in
    arm64|aarch64) arch="arm64" ;;
    x86_64)        arch="x64" ;;
    *)             echo "error: unsupported arch for codelldb: $(uname -m)"; return ;;
  esac
  local vsix="codelldb-${os}-${arch}.vsix"
  echo "Installing codelldb (${vsix})"
  run rm -rf ~/.local/codelldb
  run mkdir -p ~/.local/codelldb
  run curl -LO https://github.com/vadimcn/codelldb/releases/download/v1.11.4/${vsix}
  run mv ${vsix} ~/.local/codelldb
  run cd ~/.local/codelldb
  run unzip -q ${vsix}
}

install_codelldb

echo "########################################################"
echo "Done!!"
echo "In case you want to use tmux, you should type <prefix>I"
echo "inside your tmux session to install tmux plugins"
echo "########################################################"
