#!/bin/bash


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
--region us-east-1 \
--profile $PROFILE \
--log-type Tail \
--payload file://input.txt \
--output json \
outputfile.txt

cat outputfile.txt

# increment current count
export CURRENTCNT=$[$CURRENTCNT+1]

done
# END
