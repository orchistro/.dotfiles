############################
# BEGIN bashrc for orchistro
############################

export PATH=${PATH}:/usr/local/bin

export LC_MESSAGES=C
export LC_TIME=C

export LS_COLORS=':di=00;34:ex=00;32:ln=00;36'  # for linux
export LSCOLORS='exgxcxdxcxegedabagacad'        # for macos

prompt_color='0;34'
host_name=$(hostname)
#
export PS1="\[\033[${prompt_color}m\]\u@${host_name}:\w\$ \[\033[0m\]"

alias gco='git commit'
alias gst='git status'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias ll='ls -laF --color'

alias kubectl="minikube kubectl --"

##########################
# END bashrc for orchistro
##########################
