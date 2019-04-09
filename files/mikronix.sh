shopt -s histappend

HISTSIZE=2500
HISTFILESIZE=3000

HISTTIMEFORMAT="%F %T "

# Reset Color
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

#get current virtualenv
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      echo ""
  else
			echo "($(basename "$VIRTUAL_ENV"))"
  fi
}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

if [[ ! -z $BASH ]]; then
    if [[ $EUID -eq 0 ]]; then
			export PS1="${Cyan}\d \t${Color_Off} ${Yellow}[${Color_Off}${Red}\u@\h${Color_Off} ${Cyan}\w${Color_Off}${Yellow}]${Color_Off} ${Green}\`parse_git_branch\`${Color_Off}\n$ "
    else
			export PS1="${Cyan}\d \t${Color_Off} ${Yellow}[${Color_Off}${Blue}\u@\h${Color_Off} ${Cyan}\w${Color_Off}${Yellow}]${Color_Off} ${Green}\`parse_git_branch\`${Color_Off}\n$ "
    fi
fi
