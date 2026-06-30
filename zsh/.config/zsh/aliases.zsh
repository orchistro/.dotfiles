alias vi="LANG=ko_KR.UTF-8 nvim"  # clangd 에서 AST 관련 오류 발생 방지하기 위해서 LANG 변수 지정
alias ll="ls -laF --color"
alias tmux="tmux -u"

# git aliases
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias gd='git diff'
alias gp='git push'
alias gl='git pull'
alias gb='git branch'
alias gst='git status'
alias gco='git checkout'
alias gs='git switch'

command -v fdfind >/dev/null 2>&1 && alias fd='fdfind'

