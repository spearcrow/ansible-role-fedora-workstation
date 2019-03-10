shopt -s histappend

HISTSIZE=2500
HISTFILESIZE=3000

HISTTIMEFORMAT="%F %T "

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
        export PS1="\[\e[36m\]\d\[\e[m\]\[\e[37m\] \[\e[m\]\[\e[36m\]\t\[\e[m\]\[\e[37m\] \[\e[m\]\[\e[33m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[31m\]@\[\e[m\]\[\e[31m\]\h\[\e[m\] \[\e[36m\]\w\[\e[m\]\[\e[33m\]]\[\e[m\] \[\e[32m\]\`parse_git_branch\`\[\e[m\]\n# "
    else
export PS1="\[\e[36m\]\d\[\e[m\]\[\e[37m\] \[\e[m\]\[\e[36m\]\t\[\e[m\]\[\e[37m\] \[\e[m\]\[\e[33m\][\[\e[m\]\[\e[34m\]\u\[\e[m\]\[\e[34m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\] \[\e[36m\]\w\[\e[m\]\[\e[33m\]]\[\e[m\] \[\e[32m\]\`parse_git_branch\`\[\e[m\]\n$ "
    fi
fi
