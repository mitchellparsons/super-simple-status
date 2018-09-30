#!/bin/bash

STACK_NAME=simplestatus

SNS_Topic=$(aws cloudformation describe-stacks --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs[?OutputKey==`SNSTopic`].OutputValue' \
  --output text)

S3_BUCKET=$(aws cloudformation describe-stacks --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs[?OutputKey==`S3Bucket`].OutputValue' \
  --output text)

aws cloudwatch put-metric-alarm \
  --alarm-name TestService1 \
  --alarm-description "Simple Status Test Alarm" \
  --metric-name NumberOfObjects \
  --namespace AWS/S3 \
  --statistic Average \
  --period 60 \
  --threshold 1 \
  --comparison-operator GreaterThanThreshold  \
  --dimensions "Name=StorageType,Value=AllStorageTypes Name=BucketName,Value=$S3_BUCKET" \
  --evaluation-periods 1 \
  --alarm-actions $SNS_Topic \
  --ok-actions $SNS_Topic \
  --insufficient-data-actions $SNS_Topic

aws cloudwatch put-metric-alarm \
  --alarm-name TestService2 \
  --alarm-description "Simple Status Test Alarm" \
  --metric-name NumberOfObjects \
  --namespace AWS/S3 \
  --statistic Average \
  --period 60 \
  --threshold 1 \
  --comparison-operator GreaterThanThreshold  \
  --dimensions "Name=StorageType,Value=AllStorageTypes Name=BucketName,Value=$S3_BUCKET" \
  --evaluation-periods 1 \
  --alarm-actions $SNS_Topic \
  --ok-actions $SNS_Topic \
  --insufficient-data-actions $SNS_Topic

aws cloudwatch put-metric-alarm \
  --alarm-name TestService3 \
  --alarm-description "Simple Status Test Alarm" \
  --metric-name NumberOfObjects \
  --namespace AWS/S3 \
  --statistic Average \
  --period 60 \
  --threshold 1 \
  --comparison-operator GreaterThanThreshold  \
  --dimensions "Name=StorageType,Value=AllStorageTypes Name=BucketName,Value=$S3_BUCKET" \
  --evaluation-periods 1 \
  --alarm-actions $SNS_Topic \
  --ok-actions $SNS_Topic \
  --insufficient-data-actions $SNS_Topic
