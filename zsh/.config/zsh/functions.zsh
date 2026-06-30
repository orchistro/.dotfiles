my_passwd="1803"

function genpw() {
  local count=$1

  for i in {1..${count}}; do
    printf "%d: " "$i"
    LC_ALL=C tr -dc 'A-Z' < /dev/urandom | head -c1
    LC_ALL=C tr -dc 'a-z' < /dev/urandom | head -c1
    LC_ALL=C tr -dc '0-9' < /dev/urandom | head -c1
    LC_ALL=C tr -dc '%^*_=' < /dev/urandom | head -c1
    LC_ALL=C tr -dc 'A-Za-z0-9%^*_=' < /dev/urandom | head -c16
    echo
  done
}

function run_macos_specifics() {
  # 매 쉘 시작마다 sudo 가 여러 번 실행되지 않도록, 권한이 필요한 작업을
  # 단일 sudo 호출 안에서 모두 수행한다. ($1=HOME, $2=user 를 주입 — root
  # 쉘 안에서는 $HOME/whoami 가 root 가 되므로 실제 사용자 값을 넘겨준다)
  local root_script='
    ok()   { printf "\033[32m[ok]\033[0m   %s\n" "$1"; }
    fail() { printf "\033[31m[fail]\033[0m %s (rc=%s)\n" "$2" "$1"; }
    home=$1; user=$2

    # ssh alive interval 조정
    label="ssh ServerAliveInterval=30"
    if grep -q "ServerAliveInterval.*30" /etc/ssh/ssh_config 2>/dev/null; then
      ok "$label"
    elif printf "\tServerAliveInterval 30\n" >> /etc/ssh/ssh_config; then
      ok "$label"
    else
      fail $? "$label"
    fi

    # lock screen 버벅임 해결: 정책이 존재하면(readpl 성공) 삭제
    if dscl . readpl "$home" accountPolicyData history >/dev/null 2>&1; then
      label="dscl deletepl accountPolicyData history"
      if dscl . deletepl "$home" accountPolicyData history >/dev/null 2>&1; then
        ok "$label"
      else
        fail $? "$label"
      fi
    fi

    label="pwpolicy -clearaccountpolicies -u $user"
    if pwpolicy -clearaccountpolicies -u "$user" >/dev/null 2>&1; then
      ok "$label"
    else
      fail $? "$label"
    fi
  '
  echo "$my_passwd" | sudo -S /bin/bash -c "$root_script" _ "$HOME" "$(whoami)" 2>/dev/null
}

