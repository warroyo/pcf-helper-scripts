#!/bin/bash

aws iam create-policy --policy-name PCFInstallationPolicy --policy-document file://policies/PCFInstallationPolicy.json

aws iam create-policy --policy-name PCFAppDeveloperPolicy-s3 --policy-document file://policies/PCFAppDeveloperPolicy-s3.json

aws iam create-policy --policy-name PCFAppDeveloperPolicy-sqs --policy-document file://policies/PCFAppDeveloperPolicy-sqs.json

aws iam create-policy --policy-name PCFAppDeveloperPolicy-rds --policy-document file://policies/PCFAppDeveloperPolicy-s3.json

aws iam create-policy --policy-name PCFAppDeveloperPolicy-dynamodb --policy-document file://policies/PCFAppDeveloperPolicy-dynamodb.json