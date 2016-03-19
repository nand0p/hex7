#!/bin/bash

clear

stackName="www-$(date +%Y%m%d-%H%M)"
keyName=$stackName
cfnFile="file://cloudformation.json"
cliOpts=" --region us-east-1 --output json --profile hex7 "
echo -e "\n\n==> STACK: $stackName\n\tKeyname: $keyName\n\tcloudformation: $cfnFile\n\tcliopts: $cliOpts\n\n"

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

echo -e "\n\n==> create key-pair:\n\t$keyName"
aws $cliOpts ec2 delete-key-pair --key-name $keyName
privateKeyValue=$(aws $cliOpts ec2 create-key-pair --key-name $keyName --query 'KeyMaterial' --output text)

cfnParameters=" ParameterKey=wwwStackName,ParameterValue=$stackName "
cfnParameters+=" ParameterKey=vpcCIDR,ParameterValue=$WWW_VPC_CIDR "
cfnParameters+=" ParameterKey=publicCIDR,ParameterValue=$WWW_PUBLIC_CIDR "
cfnParameters+=" ParameterKey=wwwTrustedIP,ParameterValue=$WWW_TRUSTED_IP "
cfnParameters+=" ParameterKey=KeyName,ParameterValue=$keyName "
echo -e "\n\n==> load variables:\n\t$cfnParameters"
echo -e "\n==> launch cloudformation stack:\n\t$stackName"

aws $cliOpts cloudformation create-stack --stack-name $stackName --disable-rollback --template-body $cfnFile --parameters "ParameterKey=PrivateKey,ParameterValue=$privateKeyValue" $cfnParameters

echo -e "\n\n==> wait for stack:\n\t$stackName"
sleep 10

echo -e "\n\n==> Write out private key:\n\t$keyName.pem\n\n"
aws $cliOpts cloudformation describe-stacks --stack-name $stackName|grep PrivateKey -A22|cut -f3 > $keyName.pem
chmod -c 0400 $keyName.pem
echo
ls -la $keyName.pem
