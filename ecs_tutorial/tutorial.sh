#!/usr/bin/env sh
REGION='us-east-1'
ROLE_NAME='ecsTaskExecutionRole'
ASSUME_ROLE_POLICY_DOCUMENT='file://task-execution-assume-role.json'
POLICY_ARN='arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy'
PROJECT_NAME='tutorial'
SECURITY_GROUP_NAME='tutorialSecurityGroup'
SECURITY_GROUP_DESCRIPTION='tutorial security group'
alias aws='python -m awscli'
aws iam --region $REGION create-role --role-name $ROLE_NAME \
	--assume-role-policy-document $ASSUME_ROLE_POLICY_DOCUMENT
aws iam --region $REGION attach-role-policy --role-name $ROLE_NAME \
	--policy-arn $POLICY_ARN
ecs-cli configure --cluster $PROJECT_NAME --region $REGION \
	--default-launch-type FARGATE --config-name $PROJECT_NAME
ecs-cli configure profile --access-key $AWS_ACCESS_KEY_ID \
	--secret-key $AWS_SECRET_ACCESS_KEY --profile-name $PROJECT_NAME
eval $(ecs-cli up | grep --only-matching '\(vpc\|subnet\)-[[:xdigit:]]\{17\}' \
	| awk '{print "TMP"NR"="$1}')
VPC_ID=$TMP1
SUBNET_1=$TMP2
SUBNET_2=$TMP3
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name \
	"$SECURITY_GROUP_NAME" --description "$SECURITY_GROUP_DESCRIPTION" \
	--vpc-id $VPC_ID | grep --only-matching 'sg-[[:xdigit:]]\{17\}')
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID \
	--protocol tcp --port 80 --cidr 0.0.0.0/0 
sed "s/SUBNET_1/$SUBNET_1/;s/SUBNET_2/$SUBNET_2/;s/SECURITY_GROUP_ID/$SECURITY_GROUP_ID/;w ecs-params.yml" \
	ecs-params-template.yml
ecs-cli compose --project-name $PROJECT_NAME service up --create-log-groups \
	--cluster-config $PROJECT_NAME
TASK_ID=$(ecs-cli compose --project-name $PROJECT_NAME service ps \
	--cluster-config $PROJECT_NAME | grep --only-matching \
	'[[:xdigit:]]\{8\}-[[:xdigit:]]\{4\}-[[:xdigit:]]\{4\}-[[:xdigit:]]\{4\}-[[:xdigit:]]\{12\}')
URL=$(ecs-cli compose --project-name $PROJECT_NAME service ps \
	--cluster-config $PROJECT_NAME | grep --only-matching \
	'[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}:80')
curl $URL
timeout 10 ecs-cli logs --task-id $TASK_ID --follow --cluster-config $PROJECT_NAME
ecs-cli compose --project-name $PROJECT_NAME service scale 2 --cluster-config $PROJECT_NAME
ecs-cli compose --project-name $PROJECT_NAME service ps \
	--cluster-config $PROJECT_NAME
ecs-cli compose --project-name $PROJECT_NAME service down \
	--cluster-config $PROJECT_NAME
aws ec2 delete-vpc --vpc-id $VPC_ID
ecs-cli down --force --cluster-config $PROJECT_NAME
aws iam --region $REGION detach-role-policy --role-name $ROLE_NAME \
	--policy-arn $POLICY_ARN
aws iam --region $REGION delete-role --role-name $ROLE_NAME
aws logs delete-log-group --log-group-name $PROJECT_NAME
