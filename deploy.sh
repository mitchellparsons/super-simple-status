#!/bin/bash

STACK_NAME=simplestatus

S3_BUCKET=$(aws cloudformation describe-stacks --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs[?OutputKey==`S3Bucket`].OutputValue' \
  --output text)

sed -e "s|<replace s3 bucket>|$S3_BUCKET|g" ./client/index.html > ./client/dist-index.html

aws s3 cp ./client/dist-index.html s3://$S3_BUCKET/index.html
