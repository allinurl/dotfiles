#
# ~/.bashrc
#

# bash options ------------------------------------
shopt -s cdspell            # autocorrects cd misspellings
shopt -s checkwinsize       # update the value of LINES and COLUMNS after each command if altered
shopt -s hostcomplete       # attempt hostname expansion when @ is at the beginning of a word

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=never'
PS1='[\u@\h \W]\$ '

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi

# for tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

set_prompt_style () {
	PS1="\[$(tput bold)\]\[$(tput setaf 0)\]\t \[$(tput setaf 1)\][\[$(tput setaf 7)\]\u\[$(tput setaf 1)\]@\[$(tput setaf 1)\]\h \[$(tput setaf 7)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 1)\]\\$ \[$(tput sgr0)\]"
}

set_prompt_style

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1500
