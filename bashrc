# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Git completion
source /etc/bash_completion.d/git-completion.bash
source /usr/share/git-core/contrib/completion/git-prompt.sh

export PS1='\[\e[1;33m\][`basename "$(pwd)"`$(__git_ps1 " (%s)")]>\[\033[0m\] '
export PATH="/home/mtjandra/programs/anaconda3/bin:$PATH"

alias gits='git status'
alias setbackground='feh --bg-scale'
alias ppttopdf='libreoffice --headless --invisible --convert-to pdf *.ppt'

# Unlimited bash history
HISTSIZE=-1
HISTFILESIZE=-1
