# Aliases
alias sudo='sudo '
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias background='feh --bg-scale'
alias mplayerx='mplayer -heartbeat-cmd "xscreensaver-command -deactivate"'

# Allow auto-completion when using sudo or man
complete -cf sudo
complete -cf man

# Save a large chunk of your bash history
HISTFILESIZE=1000000
HISTSIZE=1000000

# Setup git auto-completion and PS1
source $HOME/tools/lib/git/git-prompt.sh
if [ -f $HOME/tools/lib/git/git-completion.bash ]; then
    sh $HOME/tools/lib/git/git-completion.bash
fi

# Set up git helpers
alias gits='git status'

export GIT_PS1_SHOWUPSTREAM=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

# Prompt
export PS1='\[\e[1;31m\][`basename "$(pwd)"`$(__git_ps1 " (%s)")]>\[\033[0m\] '

# Extend $PATH
PATH=$PATH:$HOME/tools/external_programs:$HOME/tools/bin
