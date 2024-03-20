#!/bin/bash -ex


HEADERS=headers002.html
BUCKET=hex7.com


for FILE in ${HEADERS}; do

  echo upload object ${FILE}
  aws s3 cp ${FILE} s3://${BUCKET}/${FILE}

  echo set object acl ${FILE}
  sleep 2
  aws s3api put-object-acl --bucket ${BUCKET} --key ${FILE} --acl public-read

done
