# zsh prompt expansion 의 %x (현재 소스 중인 파일 경로) 사용
# - ${(%):-%x} → 현재 파일 경로
# - :A → 절대 경로(심링크 해소)
# - :h → 디렉터리(head)
# 이렇게 하면 외부 dirname·서브쉘 없이 zsh 만으로 안전하게 디렉터리를 구함.
self_dir=${${(%):-%x}:A:h}

source ${self_dir}/functions.zsh
source ${self_dir}/aliases.zsh

codelldb_path=${HOME}/.local/codelldb/extension/adapter
go_path=${HOME}/.local/go/bin
export PATH=${codelldb_path}:${go_path}:${HOME}/.local/bin:${HOME}/.local/cargo/bin:/opt/local/bin:/usr/local/bin:${PATH}

# The e is a way to exit when I hit the end of the file and try to page past it. 
# The F says to just exit if there is only one screens worth of content. 
# The R helps to interpret ANSI color codes,
# The X makes it stop clearing the screen before exiting.
export LESS=eFRX  # keep less contents on the terminal (especially for git diff)
export LESSCHARSET=utf-8

# You may need to manually set your language environment
unset LC_ALL                    # LC_ALL을 unset해 주는 것이 선행되어야 아래의 locale variable이 올바로 설정된다.
unset LANG
export LC_COLLATE="ko_KR.UTF-8"
export LC_CTYPE="ko_KR.UTF-8"   # macos ls 실행시 한글 파일이름이 ???로 나오는 문제 해결
export LC_MESSAGES="C"
export LC_MONETARY="ko_KR.UTF-8"
export LC_NUMERIC="ko_KR.UTF-8"
export LC_TIME="en_US.UTF-8"    # macos ls -l 실행시 날짜가 3 7 2025 이런식으로 나오지 않고 Mar 7 2025 이렇게 나오도록

export TZ='Asia/Seoul'

hostname=$(hostname)
me=$(whoami)

# disabling AUTO_CD zsh feature
unsetopt autocd

python_venv_activator=${HOME}/.venv/bin/activate
[[ -e ${python_venv_activator} ]] && source ${python_venv_activator}

setopt incappendhistory
setopt sharehistory
export HISTFILE="${XDG_STATE_HOME:-${HOME}/.local/state}/zsh/history"
export LESSHISTFILE="${XDG_STATE_HOME:-${HOME}/.local/state}/less/history"

# ls colors
export LS_COLORS=':di=00;34:ex=00;32:ln=00;36'  # for linux
export LSCOLORS='exgxcxdxcxegedabagacad'        # for macos

unset TMOUT # 쉘 타임아웃으로 인한 자동 로그아웃 방지

export GIT_EDITOR="LANG=ko_KR.UTF-8 nvim"

export DOTHOST=localhost
export BUTLERPORT=15034
export SERVERPORT=15035

autoload -Uz compinit
compinit

# fzf: PATH 추가 + key-bindings/completion 로드.
# compinit 이후여야 compdef 기반 완성(** 트리거 등)이 정상 설정된다.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# fzf-tab: 일반 TAB 완성을 fzf 메뉴로 띄운다 (cd M<TAB> 등).
# fzf 완성 로드 뒤에 와야 이전 ^I 바인딩(fzf-completion)을 위임받아 ** 트리거도 함께 동작한다.
[ -f "${HOME}/.local/fzf-tab/fzf-tab.plugin.zsh" ] && source "${HOME}/.local/fzf-tab/fzf-tab.plugin.zsh"

export GPG_TTY=${TTY:-$(tty 2>/dev/null)}

[[ "$(uname -s)" == "Darwin" ]] && run_macos_specifics

eval "$(starship init zsh)"

# zsh-autosuggestions: 히스토리 기반 회색 제안 (OMZ 없이 ~/.local 에 독립 설치)
if [ -f "${HOME}/.local/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${HOME}/.local/zsh-autosuggestions/zsh-autosuggestions.zsh"
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#c6c6c6"  # 회색 제안 텍스트 색
  bindkey '^Y' autosuggest-accept                       # Ctrl-Y 로 제안 수락
fi

# zsh-syntax-highlighting: 다른 위젯 래핑 이후여야 하므로 반드시 .zshrc 맨 끝에서 source
[ -f "${HOME}/.local/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "${HOME}/.local/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
