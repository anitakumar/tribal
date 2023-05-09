#!/bin/sh
set -x
app="python-api"
current_dir=`pwd`
region="eu-west-1"
cd ../terraform/ecr
terraform init
terraform apply -auto-approve > url.txt
repo_url=`cat url.txt | grep "app-repository-URL =" | gawk -F= '{ print $2 }'`
tag=`echo $repo_url | sed -e 's/["]//g'`
# repo_arn=`cat url.txt | grep "app-repository-ARN =" | gawk -F= '{ print $2 }'`
# reg=`echo $repo_arn | sed -e 's/["]//g'`


#build and deploy docker image to ecr
cd $current_dir/../$app
docker build -t $tag:1 .
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $tag
docker push  $tag:1
echo "repo_url = $tag:1" > $current_dir/../terraform/ecs/vars.tfvars

# build ecs
cd $current_dir/../terraform/ecs
terraform init
terraform apply -auto-approve > ecs-output.txt


# Check status of the container
cluster_name=`cat ecs-output.txt | grep "cluster-name =" | gawk -F= '{ print $2 }'`
service_name=`cat ecs-output.txt | grep "service-name =" | gawk -F= '{ print $2 }'`
check_status=`aws ecs describe-services --cluster $cluster_name --services $service_name | grep -w "failed container health checks"| wc -l`
if [ $check_status -gt 0 ]
then
    echo "Health check has failed"
fi




