#!/bin/sh

#################################################
### Functions
#################################################
Puts_help () {
    MY_BASENAME=$(basename $0)
	echo "This script is auto exec for exec command．"
    echo "\nCaution!"
    echo "And, You should use this script in '~/Project/goohub'"
    echo "\nUsage:"
    echo "bash ${MY_BASENAME} <options>"
    echo "<options>"
    echo "help(or -h): Puts this help"
    echo "exec-test(or -et): Exec test"
    echo "exec-production(or -ep) : Exec server production"

}

Test () {
    # If comment out while ~ done, this script become server
    # In test, only 1 share exec
    # while true; do
    etag=`(bundle exec ruby exe/goohub exec etag)`
    echo "etag: $etag"
    #     sleep 60;
    # done
}

Exec () {
    while true; do
        echo "$etag_list"
        etag_list=`(bundle exec ruby exe/goohub exec $etag_list)`
        sleep 8;
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
	*) echo "If you want to show help, please type 'auto_exec.sh -h'"
	   ;;
esac
