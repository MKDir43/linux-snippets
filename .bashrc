# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#===================================
# bash completion
#===================================
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

#===================================
# Prompt
#===================================
reset=$(tput sgr0)
red=$(tput setaf 1)
blue=$(tput setaf 4)
green=$(tput setaf 2)
hg_branch() {
	hg branch 2> /dev/null | awk '{printf "(hg:" $1 ")"}'
}
git_branch() {
	__git_ps1 '(git:%s)'
}

PS1='\[$red\](\!)$(git_branch)$(hg_branch)\[$reset\]\[$green\][\u@\[$reset\]\[$blue\]\w\[$reset\] \[$green\]]\$ \[$reset\]'

#===================================
# shopt
#===================================
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s direxpand
shopt -s dirspell
shopt -s execfail
shopt -s globstar

#===================================
# History
#===================================
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT='%y/%m/%d %H:%M:%S  '
HISTIGNORE=ls:la:ll:lla:history:h:pwd
HISTCONTROL=ignoreboth

#===================================
# Alias(builtin)
#===================================
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias mv='mv -i'
alias cp='cp -i'

#===================================
# Alias(short)
#===================================
alias sc='screen'
alias ps='ps --sort=start_time'
alias df='df -h'			# show block by MB

#===================================
# Alias(useful)
#===================================
alias tarx='tar zxvf'
alias tarc='tar zcvf'
alias nogrep='grep -v'
adlias diffdir='diff -rq'

#===================================
# Function(useful)
#===================================
rec_list_file ()
{
    for fi in "$@"; do
        thisf=$thisf/$fi
    
        if [ -d "$thisf" ]; then
            rec_list_file $(command ls $thisf)
        else
            echo -e $thisf
        fi

        thisf=${thisf%/*}
    done
}

list_file ()
{
    for fi in "$@"; do
      if [ -d "$fi" ]; then
        thisf=${fi%\/}
        rec_list_file $(command ls $fi)
      fi
    done
}

flatten_dir ()
{
    input_dir=$1
    output_dir=$2

    inputs=$(list_file $input_dir)
    for fi in $inputs; do
        output_fi=${fi//\//_}
        mkdir -p $output_fi
    done
}

rec_list_dir ()
{
    for fi in "$@"; do
        thisf=$thisf/$fi
    
        if [ -d "$thisf" ]; then
            echo -e $thisf
            rec_list_dir $(command ls $thisf)
        fi

        thisf=${thisf%/*}
    done
}

list_dir ()
{
    for fi in "$@"; do
      if [ -d "$fi" ]; then
        thisf=${fi%/}
        rec_list_dir $(command ls $fi)
      fi
    done
}

copy_dir ()
{
    input_dir=$1
    output_dir=${2%/}

    inputs=$(list_dir $input_dir)
    for fi in $inputs; do
        output_fi=$output_dir/${fi#*/}
        echo -e $output_fi
    done
}

#===================================
# history cd
#===================================
cd_func()
{
	local x2 the_new_dir adir index
	local -i cnt

	if [[ $1 ==  "--" ]]; then
		dirs -v
		return 0
	fi

	the_new_dir=$1
	[[ -z $1 ]] && the_new_dir=$HOME

	if [[ ${the_new_dir:0:1} == '-' ]]; then
		#
		# Extract dir N from dirs
		index=${the_new_dir:1}
		[[ -z $index ]] && index=1
		adir=$(dirs +$index)
		[[ -z $adir ]] && return 1
		the_new_dir=$adir
		fi

	#
	# '~' has to be substituted by ${HOME}
	[[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

	#
	# Now change to the new dir and add to the top of the stack
	pushd "${the_new_dir}" > /dev/null
	[[ $? -ne 0 ]] && return 1
	the_new_dir=$(pwd)

	#
	# Trim down everything beyond 11th entry
	popd -n +11 2>/dev/null 1>/dev/null

	#
	# Remove any other occurence of this dir, skipping the top of the stack
	for ((cnt=1; cnt <= 10; cnt++)); do
		x2=$(dirs +${cnt} 2>/dev/null)
		[[ $? -ne 0 ]] && return 0
		[[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
		if [[ "${x2}" == "${the_new_dir}" ]]; then
			popd -n +$cnt 2>/dev/null 1>/dev/null
			cnt=cnt-1
		fi
	done

	return 0
}

alias cd=cd_func

if [[ $BASH_VERSION > "2.05a" ]]; then
	# ctrl+w shows the menu
	bind -x "\"\C-a\":cd_func -- ;"
fi
