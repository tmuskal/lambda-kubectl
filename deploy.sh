#!/bin/bash
# deploy lambdakubectl function to aws
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
rm lambdakubectl.zip
# check_error

cp ~/.kube/config ./config
chmod a+rw ./config
echo "
packaging lambdakubectl, creating new zip...
"
zip lambdakubectl.zip config lambdakubectl.js README.md package.json core.sh bin/*
check_error

echo "
removing old lambda function (deleting zip remotely) from amazon aws lambda...
"
aws lambda delete-function \
 --function-name lambdakubectl \
 --profile $PROFILE \
 --region $REGION

#--# add if exist logic ^
#--# check_error

echo "
uploading new zip to lambda...
"
aws lambda create-function --timeout 60 --function-name lambdakubectl --zip-file fileb://lambdakubectl.zip --role $IAMARN --handler lambdakubectl.handler --runtime nodejs6.10 --profile $PROFILE --region $REGION

check_error

echo "
testing new lambda function by invoking...
"
aws lambda invoke \
--invocation-type RequestResponse \
--function-name lambdakubectl \
--region $REGION \
--log-type Tail \
--payload file://input.txt \
--profile $PROFILE \
--output json \
outputfile.txt

check_error

echo "
=======
SUCCESS: lambdakubectl has been deployed
=======
"
