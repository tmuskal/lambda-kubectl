# AWS Lambda Kubectl

####   by Tal Muskal

##### based on AWS Lambda Bash Function Blueprint Template at https://github.com/jacov/lambda-bash

#### tags: aws lambda, kubernetes

### Description:

 
### Prerequisites

* install aws cli - http://docs.aws.amazon.com/cli/latest/userguide/installing.html
* run 'aws configure' to create your ~/.aws/credentials & ~/.aws/config file 
* make sure your user has permissions to create lambda functions
* before you deploy. make sure kubectl works and has the config file under ~/.kube/config

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


### Usage

#### Apply ConfigMap

```
{
	"command":"kubectl", 
	"params":["apply","-f" , "-"],
	"stdin":{
		  "apiVersion": "v1",
		  "data": {
		    "aws.region": "test"
		  },
		  "kind": "ConfigMap",
		  "metadata": {
		    "name": "clusterconfiguration2"
		  }
		}
}
```


#### List Pods
```
{
	"command":"kubectl", 
	"params":["get","pods"]
}
```
