#!/bin/sh

# Usage $bash filter.sh $1
# if  $1 = all, done all test
# else done selected test
# now(2018/02/01): summary_delete, created_delete, location_delete test is supported

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

Summary_delete_test () {
	Test_start $1
	bundle exec ruby exe/goohub share kjtbw1219@gmail.com 954l9ls11tue0mrirtu7se71hs --filter=summary_delete --action=stdout
	Test_end $1
}

Location_delete_test () {
	Test_start $1
	bundle exec ruby exe/goohub share kjtbw1219@gmail.com 954l9ls11tue0mrirtu7se71hs --filter=location_delete --action=stdout
	Test_end $1
}

Created_delete_test () {
	Test_start $1
	bundle exec ruby exe/goohub share kjtbw1219@gmail.com 954l9ls11tue0mrirtu7se71hs --filter=created_delete --action=stdout
	Test_end $1
}

Puts_help () {
	echo "This script is test script for goohub filter"
	echo "You should use this script in '~/Project/goohub'"
	echo "Usage: 'bash filter.sh type'"
	echo "If type == all then done all test"
	echo "If type == help then puts this help"
	echo "If type == test_name then done selected test"
	echo "Supported test is summary_delete, created_delete and location_delete"
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

echo "Start filter test"
echo "Cheking test type is ${type}"
case "${type}" in
	"summary_delete") Summary_delete_test ${type}
			  ;;
	"created_delete") Created_delete_test ${type}
				;;
	"location_delete") Location_delete_test ${type}
			 ;;
	"all")
		Summary_delete_test summary_delete
		Created_delete_test created_delete
		Location_delete_test location_delete
		;;
	"help") Puts_help
			;;
	*) echo "If you want to show help, please type 'bash filter.sh help'"
	   ;;
esac
echo "All filter test done"
