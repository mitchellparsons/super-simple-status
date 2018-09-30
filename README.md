# super-simple-status
The purpose of this repository is to create a simple health status site for internal/external services.  A Lambda function will consume events triggered via CloudWatch Alarms. These alarms are your services and as they change from OK to ALARM or INSUFFICIENT_DATA the lambda will consume that event and output the service status to an S3 bucket.  This same S3 bucket will host not only the service status data, but also an index.html.  Make this S3 bucket publicly available and you have yourself a super simple status page!

# Setup
Package and Deploy the AWS resources using SAM.  If you need a refresher on AWS SAM please checkout [https://github.com/awslabs/serverless-application-model](https://github.com/awslabs/serverless-application-model)

First package the sam template and lambda function
```
sam package --template-file sam.yaml --s3-bucket <your s3 bucket for deployments> --s3-prefix simplestatus --output-template-file sam-output.yaml
```

Now deploy
```
sam deploy --template-file sam-output.yaml --stack-name simplestatus --capabilities CAPABILITY_IAM
```

Lets go ahead and deploy the index.html to the newly created S3 bucket

```
./deploy.sh
```

At this point everything is ready to go.  The last step is to create CloudWatch alarms.  To make dummy alarms you can run the following

```
./create-dummy-alarms.sh
```

The script above created three alarms `TestService1`, `TestService2`, and `TestService3`.

To simulate the alarms going into different states you can run the following

```
aws cloudwatch set-alarm-state \
  --alarm-name "TestService1" \
  --state-value OK \
  --state-reason "testing purposes"
```

To view your status page just navigate to the website url for the S3 Bucket. You can get that value by running
```
aws cloudformation describe-stacks --stack-name simplestatus \
  --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' \
  --output text
```