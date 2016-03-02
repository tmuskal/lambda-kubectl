#!/bin/bash
# deploy lambdabash function to aws
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

echo "
deleting old zip...
"
rm lambdabash.zip
# check_error

echo "
packaging lambdabash, creating new zip...
"
zip lambdabash.zip lambdabash.js README.md package.json core.sh
check_error

echo "
removing old lambda function (deleting zip remotely) from amazon aws lambda...
"
aws lambda delete-function \
 --function-name lambdabash \
 --region $REGION

check_error

echo "
uploading new zip to lambda...
"
aws lambda create-function --function-name lambdabash --zip-file fileb://lambdabash.zip --role $IAMARN --handler lambdabash.handler --runtime nodejs

check_error

echo "
testing new lambda function by invoking...
"
aws lambda invoke \
--invocation-type RequestResponse \
--function-name lambdabash \
--region $REGION \
--log-type Tail \
--payload file://input.txt \
--output json \
outputfile.txt

check_error

echo "
=======
SUCCESS: lambdabash has been deployed
=======
"
