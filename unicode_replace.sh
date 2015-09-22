#!/bin/sh

# usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-c] [-k] FILE
Unicode Replace v0.1 [Kieras <kieras@gmail.com>]
Replaces special characters of a FILE to the corresponding Unicode 
hexadecimal representation. By default it saves a backup of FILE in /tmp.

    -h display this help and exit
    -c just check and print lines that would be replaced
    -k keep the backup file in the same folder
EOF
}

# initialize our own variables:
REPLACEMENTS="$HOME/.unicode_replace/replacements.txt"
CHARACTERS="$HOME/.unicode_replace/characters.txt"
KEEP_BACKUP=0
CHECK_ONLY=0

# get command line options
# http://wiki.bash-hackers.org/howto/getopts_tutorial
OPTIND=1
while getopts "hkc" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        c)  CHECK_ONLY=$((CHECK_ONLY+1))
            ;;
        k)  KEEP_BACKUP=$((KEEP_BACKUP+1))
            ;;
        \?)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"


if [ $# -eq 0 ]; then
    show_help >&2
    exit 1
fi


# do stuff
if [ $CHECK_ONLY -gt 0 ]; then
    grep -n -f $CHARACTERS $1;
else
    sed -i .bkp -f $REPLACEMENTS $1
    if [ $KEEP_BACKUP -eq 0 ]; then
        mv $1.bkp /tmp/
    fi
fi

