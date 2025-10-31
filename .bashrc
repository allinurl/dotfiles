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
  #PS1='\d\n\w:\\$ '
}

set_prompt_style

# Function to display 256 colors in a 16x16 grid
function show_colors() {
    for row in {0..15}; do
        for col in {0..15}; do
            color=$((row * 16 + col))  # Calculate color index
            printf "\e[48;5;%sm%3d \e[0m " "$color" "$color"  # Print color number centered
        done
        echo  # New line for next row
    done
}

# Shortcut alias to display colors quickly
alias colors="show_colors"

source /etc/profile.d/debuginfod.sh
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1955
