#!/bin/sh

# Usage $bash action.sh $1
# if  $1 = all, done all test
# else done selected test
# now(2018/01/26): stdout, calendar, slack, and mail test is supported

#################################################
### Functions
#################################################
Test_start () {
	echo "#################################################"
	echo "$1 start"
	echo "#################################################"
}

Test_end () {
	echo "#################################################"
	echo "$1 end"
	echo "#################################################"
}

Stdout_test () {
	Test_start $1
	bundle exec ruby exe/goohub share kjtbw1219@gmail.com 954l9ls11tue0mrirtu7se71hs --filter=summary_delete --action=stdout
	Test_end $1
}

Calendar_test () {
	Test_start $1
	bundle exec ruby exe/goohub share kjtbw1219@gmail.com 954l9ls11tue0mrirtu7se71hs --filter=summary_delete --action=calendar:kjtbw1219@gmail.com
	Test_end $1
}

Mail_test () {
	Test_start $1
	bundle exec ruby exe/goohub share kjtbw1219@gmail.com 954l9ls11tue0mrirtu7se71hs --filter=summary_delete --action=mail:kjtbw1219@icloud.com
	Test_end $1
}

Slack_test () {
	Test_start $1
	bundle exec ruby exe/goohub share kjtbw1219@gmail.com 954l9ls11tue0mrirtu7se71hs --filter=summary_delete --action=slack
	Test_end $1
}

Puts_help () {
	echo "This script is test script for goohub action"
	echo "You should use this script in '~/Project/goohub'"
	echo "Usage: 'bash action.sh type'"
	echo "If type == all then done all test"
	echo "If type == help then puts this help"
	echo "If type == test_name then done selected test"
	echo "Supported test is stdout, calendar, slack, and mail"
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

echo "Start action test"
echo "Cheking test type is ${type}"
case "${type}" in
	"stdout") Stdout_test ${type}
			  ;;
	"calendar") Calendar_test ${type}
				;;
	"slack") Slack_test ${type}
			 ;;
	"mail") Mail_test ${type}
			;;
	"all")
		Stdout_test stdout
		Calendar_test calendar
		Slack_test slack
		Mail_test mail
		;;
	"help") Puts_help
			;;
	*) echo "If you want to show help, please type 'bash action.sh help'"
	   ;;
esac
echo "All action test done"
