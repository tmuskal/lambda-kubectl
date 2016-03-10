#!/bin/bash
# test lambdabash function in aws
# author: @jacobbaloul
#
#
function check_error(){
if test $? -gt 0 ; then
 echo "oops! something went wrong, aborting."
 exit 1
fi
}
#

##
## BEGIN
##
source settings.conf
check_error



if [ "$1" = '' ]
then
   export CNT=10 # default to 10 loops for the test
else
   export CNT=$1
fi
 
# BEGIN
export CURRENTCNT=1

seq 1 $CNT | while read cnt 

do

echo " == Test #$CURRENTCNT: =="

# run the test
echo "
testing new lambda function by invoking...
"
aws lambda invoke \
--invocation-type RequestResponse \
--function-name lambdabash \
--region $REGION \
--log-type Tail \
--payload file://input.txt \
--profile $PROFILE \
--output json \
outputfile.txt


cat outputfile.txt

# increment current count
export CURRENTCNT=$[$CURRENTCNT+1]

done


echo "

=====

executed $CNT tests.

DONE

=====
"

# END
