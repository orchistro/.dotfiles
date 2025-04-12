my_passwd="1803"

function alert_ssh_alive_interval()
{
    # echo "==============================================================================="
    # echo "Need to reset ServerAliveInterval in /etc/ssh/ssh_config."
    # echo "Running Following:"
    # echo "-------------------------------------------------------------------------------"
    # echo "grep 'ServerAliveInterval.*30' /etc/ssh/ssh_config 1> /dev/null || \\"
    # echo "sudo /bin/bash -c 'echo -e \"\tServerAliveInterval 30\" >> /etc/ssh/ssh_config'"
    # echo "==============================================================================="

    grep 'ServerAliveInterval.*30' /etc/ssh/ssh_config 1> /dev/null || \
      echo $my_passwd | sudo -S /bin/bash -c 'echo -e "\tServerAliveInterval 30" >> /etc/ssh/ssh_config'
}

function run_macos_specifics()
{
  # ssh alive interval 조정
  grep 'ServerAliveInterval.*30' /etc/ssh/ssh_config 1> /dev/null || alert_ssh_alive_interval

  # lock screen으로 들어갔을 때 버벅거리는 문제 해결
  dscl . readpl /Users/user accountPolicyData history > /dev/null 2>&1
  if [ $? -ne 181 ]; then
    sudo dscl . deletepl ${HOME} accountPolicyData history
  fi

  if [ "$(/usr/bin/uname)" = "Darwin" ]; then
    echo $my_passwd | sudo -S pwpolicy -clearaccountpolicies -u USER
  fi
}

(uname -a | grep Darwin 1> /dev/null) && run_macos_specifics
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=${HOME}/.local/codelldb/extension/adapter:${HOME}/.local/bin:/opt/local/bin:/usr/local/bin:${PATH}

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

# The e is a way to exit when I hit the end of the file and try to page past it. 
# The F says to just exit if there is only one screens worth of content. 
# The R helps to interpret ANSI color codes,
# The X makes it stop clearing the screen before exiting.
export LESS=eFRX  # keep less contents on the terminal (especially for git diff)
export LESSCHARSET=utf-8

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi=nvim
alias vim=nvim
alias ll="ls -laF --color"
alias tmux="tmux -u"
which fdfind > /dev/null 2>&1 &&      alias fd=fdfind # fdfind가 있을 경우에만 fd alias를 설정
which pygmentize > /dev/null 2>&1 &&  alias ccat=pygmentize # syntax highlight가 적용된 cat

source ${HOME}/.p10k.zsh

hostname=$(hostname)
me=$(whoami)

# window title을 변경하기 위해 oh my zsh 가 타이틀을 변경하는 함수를 override함
# Runs before showing the prompt
function omz_termsupport_precmd {
  [[ "${DISABLE_AUTO_TITLE:-}" != true ]] || return
  title "${me}@${hostname}:$ZSH_THEME_TERM_TAB_TITLE_IDLE"
}

# Runs before executing the command
function omz_termsupport_preexec {
  [[ "${DISABLE_AUTO_TITLE:-}" != true ]] || return

  emulate -L zsh
  setopt extended_glob

  # split command into array of arguments
  local -a cmdargs
  cmdargs=("${(z)2}")
  # if running fg, extract the command from the job description
  if [[ "${cmdargs[1]}" = fg ]]; then
    # get the job id from the first argument passed to the fg command
    local job_id jobspec="${cmdargs[2]#%}"
    # logic based on jobs arguments:
    # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
    # https://www.zsh.org/mla/users/2007/msg00704.html
    case "$jobspec" in
      <->) # %number argument:
        # use the same <number> passed as an argument
        job_id=${jobspec} ;;
      ""|%|+) # empty, %% or %+ argument:
        # use the current job, which appears with a + in $jobstates:
        # suspended:+:5071=suspended (tty output)
        job_id=${(k)jobstates[(r)*:+:*]} ;;
      -) # %- argument:
        # use the previous job, which appears with a - in $jobstates:
        # suspended:-:6493=suspended (signal)
        job_id=${(k)jobstates[(r)*:-:*]} ;;
      [?]*) # %?string argument:
        # use $jobtexts to match for a job whose command *contains* <string>
        job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
      *) # %string argument:
        # use $jobtexts to match for a job whose command *starts with* <string>
        job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
    esac

    # override preexec function arguments with job command
    if [[ -n "${jobtexts[$job_id]}" ]]; then
      1="${jobtexts[$job_id]}"
      2="${jobtexts[$job_id]}"
    fi
  fi

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  local LINE="${2:gs/%/%%}"

  title "${me}@${hostname}: %100>...>${LINE}%<<"
}

# disabling AUTO_CD zsh feature
unsetopt autocd

python_venv_activator=$HOME/.venv/bin/activate
[[ -e $python_venv_activator ]] && source $python_venv_activator

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt noincappendhistory
setopt nosharehistory

# ls colors
export LS_COLORS=':di=00;34:ex=00;32:ln=00;36'  # for linux
export LSCOLORS='exgxcxdxcxegedabagacad'        # for macos

# tab completion시 나오는 디렉토리 등에도 ls와 동일 색깔 적용
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

unset -f d

unset TMOUT # 쉘 타임아웃으로 인한 자동 로그아웃 방지

export DOTHOST=localhost
export BUTLERPORT=15034
export SERVERPORT=15035
