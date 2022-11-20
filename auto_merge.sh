#!/bin/sh

#################################################
### Functions
#################################################
Puts_help () {
    MY_BASENAME=$(basename $0)
	echo "This script is auto exec for merge_calendar command．"
    echo "\nCaution!"
    echo "You should use this script in '~/Project/goohub'"
    echo "\nUsage:"
    echo "bash ${MY_BASENAME} <options>"
    echo "<options>"
    echo "help(or -h): Puts this help"
    echo "exec-test(or -et): Exec test"
    echo "exec-production(or -ep) : Exec server production"

}

Test () {
    bundle exec ruby exe/goohub merge_calendar
}

Exec () {
    while true; do
        bundle exec ruby exe/goohub merge_calendar
        sleep 1d;
    done
}


#################################################
### Main part
#################################################
if [ -z "$1" ]
then
	type="no"
else
	type="$1"
fi

case "${type}" in
	"help" | "-h") Puts_help
			       ;;
    "exec-test" | "-et") Test
			             ;;
    "exec-production" | "-ep") Exec
			                   ;;
	*) echo "If you want to show help, please type 'auto_merge.sh -h'"
	   ;;
esac
