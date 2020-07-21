#!/bin/bash
set -x
awslocal s3 mb s3://${S3FS_BUCKET}
awslocal s3 website s3://${S3FS_BUCKET} --index-document index.html
set +x