#!/bin/bash

clear

echo $0

if [ "$#" -ne 1 ]
then
  echo "$@\n\nUsage: one NAMESPACE argument required."
  exit 1
fi


stackName=$1
keyName=www
cfnFile="file://cloudformation.json"
cliOpts=" --region us-east-1 --output json --profile hex7 "
echo -e "\n\n==> update stack:\n\t$stackName\n\t$keyName\n\t$cfnFile\n\t$cliOpts"

envVarTest1=$(env|grep WWW_VPC_CIDR |cut -f2 -d=)
envVarTest2=$(env|grep WWW_PUBLIC_CIDR |cut -f2 -d=)
envVarTest3=$(env|grep WWW_TRUSTED_IP |cut -f2 -d=)

if [ -z "$envVarTest1" ] ||
   [ -z "$envVarTest2" ] ||
   [ -z "$envVarTest3" ]
then
    echo -e "\nEnvironment variables must be set:\n"
    echo -e "\n\t\tWWW_VPC_CIDR: $envVarTest1"
    echo -e "\t\tWWW_PUBLIC_CIDR: $envVarTest2"
    echo -e "\t\tWWW_TRUSTED_IP: $envVarTest3\n"
    exit
fi

cfnParameters=" ParameterKey=wwwStackName,ParameterValue=$stackName "
cfnParameters+=" ParameterKey=vpcCIDR,ParameterValue=$WWW_VPC_CIDR "
cfnParameters+=" ParameterKey=publicCIDR,ParameterValue=$WWW_PUBLIC_CIDR "
cfnParameters+=" ParameterKey=wwwTrustedIP,ParameterValue=$WWW_TRUSTED_IP "
cfnParameters+=" ParameterKey=KeyName,ParameterValue=$keyName "
echo -e "\n\n==> load variables:\n\t$cfnParameters"
echo -e "\n\n==> update cloudformation stack:\n\t$stackName\n\n"

aws $cliOpts cloudformation update-stack --stack-name $stackName --template-body $cfnFile --parameters "ParameterKey=PrivateKey,ParameterValue=$privateKeyValue" $cfnParameters
