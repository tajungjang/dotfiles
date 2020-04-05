# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# Import the colors.
. "${HOME}/.cache/wal/colors.sh"

# Create the alias.
alias dmen='dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"'

#Aliases
#alias alias_name="command_to_run"
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias xin="sudo xbps-install"
alias shutdown="sudo shutdown -P now"
alias sleep="sudo zzz"
alias wall="sudo wal -R"
alias tasty="/opt/opt/tastyworks/bin/tastyworks"

export PATH="/home/tjang/Scripts:${PATH}"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
