ZSH=/usr/share/oh-my-zsh/

export LANG=zh_CN.UTF-8



alias sstart='sudo sslocal -c ~/.shadowsocks.json -d start'
alias sstop='sudo sslocal -c ~/.shadowsocks.json -d stop'
		

ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"

plugins=(
  git
)



ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
