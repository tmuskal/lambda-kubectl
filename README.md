# AWS Lambda Bash Function Blueprint Template

####   by Jacob Baloul

#### tags: aws lambda bash template, lambda bash shell script wrapped in nodejs handler

### Description:
   Currently, aws lambda does not support running bash functions directly.
   This basic lambda function wraps a bash shell script with a nodejs handler. 
   The nodejs lambda handler calls the "core" bash script, that includes example random generator code.
   Replace or modify the core.sh script to include your own shell-fu.
   You can use core.sh to call ./yourScripts.sh

   Currently logging stdout to cloudwatch
 


### Prerequisites

* install aws cli - http://docs.aws.amazon.com/cli/latest/userguide/installing.html
* run 'aws configure' to create your ~/.aws/credentials & ~/.aws/config file 
* make sure your user has permissions to create lambda functions


### Recommended

* brew install nodejs



### Step 1: setup settings file

* Create the Execution Role (IAM Role), and use the arn string in the IAMARN variable
http://docs.aws.amazon.com/lambda/latest/dg/with-userapp-walkthrough-custom-events-create-iam-role.html 

* Edit settings.conf and replace IAMARN with your iam roles arn



### Step 2: Package, Deploy & Test lambda bash function on your aws account:

```
$ ./deploy.sh
```




##### more...

### Test locally

```
$ node lambdabash.js
```


### Test lambdabash function, defaults to 10 loops, control with first arg
```
$ ./test.sh

$ ./test.sh 1

$ ./test.sh 5
```


### Simple Load Test, 2K invocations, with some parallel execution
```
$ seq 1 200 | while read cnt 
  do 
    ./test.sh 10 & 
  done
```


### Ex: Create Lambda Function
```
aws lambda create-function \
--function-name lambdabash \
--zip-file fileb://lambdabash.zip \ 
--role arn:aws:iam::292361995972:role/lambda_s3_exec_role \
--handler lambdabash.handler \
--runtime nodejs
```

### Ex: Invoke Lambda Function
```
aws lambda invoke \
--invocation-type RequestResponse \
--function-name lambdabash \
--region us-east-1 \
--log-type Tail \
--payload file://input.txt \
--output json \
outputfile.txt
```

OR

```
aws lambda invoke \
--invocation-type RequestResponse \
--function-name lambdabash \
--region us-east-1 \
--log-type Tail \
--payload '{"key1":"value1", "key2":"value2", "key3":"value3"}' \
outputfile.txt
```

### Delete the Lambda Function
```
aws lambda delete-function \
 --function-name lambdabash \
 --region us-east-1
```


### Ex: Successful output after uploading the new zip to lambda...

```
-------------------------------------------------------------------------------
|                               CreateFunction                                |
+--------------+--------------------------------------------------------------+
|  CodeSha256  |  WDYd3sOWHej9r5HmhsJAiSPUzupAwBUvhrAuAc+rqEI=                |
|  CodeSize    |  1862                                                        |
|  Description |                                                              |
|  FunctionArn |  arn:aws:lambda:us-east-1:292361995972:function:lambdabash   |
|  FunctionName|  lambdabash                                                  |
|  Handler     |  lambdabash.handler                                          |
|  LastModified|  2016-03-02T16:05:32.917+0000                                |
|  MemorySize  |  128                                                         |
|  Role        |  arn:aws:iam::292361995972:role/lambda_s3_exec_role          |
|  Runtime     |  nodejs                                                      |
|  Timeout     |  3                                                           |
|  Version     |  $LATEST                                                     |
+--------------+--------------------------------------------------------------+
```

### Ex: Successful test of new lambda function by invoking...

```
{
    "LogResult": "U1RBUlQgUmVxdWVzdElkOiA5OGExNTM1My1lMDkwLTExZTUtOTA0MC1mNTliMGZkNjIzOTQgVmVyc2lvbjogJExBVEVTVAoyMDE2LTAzLTAyVDE2OjA1OjM1LjMzM1oJOThhMTUzNTMtZTA5MC0xMWU1LTkwNDAtZjU5YjBmZDYyMzk0CXN0ZG91dDogQkFTSCBSQU5ET006IDEzNDQKCkVORCBSZXF1ZXN0SWQ6IDk4YTE1MzUzLWUwOTAtMTFlNS05MDQwLWY1OWIwZmQ2MjM5NApSRVBPUlQgUmVxdWVzdElkOiA5OGExNTM1My1lMDkwLTExZTUtOTA0MC1mNTliMGZkNjIzOTQJRHVyYXRpb246IDE1OS40NyBtcwlCaWxsZWQgRHVyYXRpb246IDIwMCBtcyAJTWVtb3J5IFNpemU6IDEyOCBNQglNYXggTWVtb3J5IFVzZWQ6IDI5IE1CCQo=",
    "StatusCode": 200
}
```


### Decoding the response

```
$ echo "_LogResult_" | base64 --decode
```

```
$ echo "U1RBUlQgUmVxdWVzdElkOiA5OGExNTM1My1lMDkwLTExZTUtOTA0MC1mNTliMGZkNjIzOTQgVmVyc2lvbjogJExBVEVTVAoyMDE2LTAzLTAyVDE2OjA1OjM1LjMzM1oJOThhMTUzNTMtZTA5MC0xMWU1LTkwNDAtZjU5YjBmZDYyMzk0CXN0ZG91dDogQkFTSCBSQU5ET006IDEzNDQKCkVORCBSZXF1ZXN0SWQ6IDk4YTE1MzUzLWUwOTAtMTFlNS05MDQwLWY1OWIwZmQ2MjM5NApSRVBPUlQgUmVxdWVzdElkOiA5OGExNTM1My1lMDkwLTExZTUtOTA0MC1mNTliMGZkNjIzOTQJRHVyYXRpb246IDE1OS40NyBtcwlCaWxsZWQgRHVyYXRpb246IDIwMCBtcyAJTWVtb3J5IFNpemU6IDEyOCBNQglNYXggTWVtb3J5IFVzZWQ6IDI5IE1CCQo=" | base64 --decode
START RequestId: 98a15353-e090-11e5-9040-f59b0fd62394 Version: $LATEST
2016-03-02T16:05:35.333Z	98a15353-e090-11e5-9040-f59b0fd62394	stdout: BASH RANDOM: 1344

END RequestId: 98a15353-e090-11e5-9040-f59b0fd62394
REPORT RequestId: 98a15353-e090-11e5-9040-f59b0fd62394	Duration: 159.47 ms	Billed Duration: 200 ms 	Memory Size: 128 MB	Max Memory Used: 29 MB
```


### More Documentation
*  http://docs.aws.amazon.com/lambda/latest/dg/with-userapp-walkthrough-custom-events-create-test-function.html
