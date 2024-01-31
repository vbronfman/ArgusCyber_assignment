# ArgusCyber_assignment





EC2 instance with docker

sudo yum install docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -a -G docker ec2-user


## Ctreat AWS profile

--profile argus

## Login to ECR
aws ecr get-login-password --region us-east-1 --profile argus 
docker login --username AWS -p xxxxxxxxxx 161192472568.dkr.ecr.us-east-1.amazonaws.com
actually  aws ecr get-login-password --region us-east-1 --profile argus | docker login --username AWS --password-stdin 161192472568.dkr.ecr.us-east-1.amazonaws.com
WARNING! Your password will be stored unencrypted in /home/ec2-user/.docker/config.json.

 docker pull 161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller:latest

 docker run -d -u root --name /argus-jenkins -v //var/run/docker.sock:/var/run/docker.sock -v jenkins_argus:/var/jenkins_home --restart unless-stopped -p 50000:50000 -p 48080:8080  161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller


Jenkins admin pass # cat /var/jenkins_home/secrets/initialAdminPassword
ce29967b507b4396ba6d060a3c1baf35
# 

4. JENKINS plugins to install :
   For time sake I'm going to istall it manuall/ Proper way is to update image with forged plugins.txt
- Parameterized Scheduler  to use instead of regular https://plugins.jenkins.io/parameterized-scheduler/ 
    triggers {
        cron('H 0 * * *')
        
- Install plugin Github Pull Request Builder
add credentials 
https://devopscube.com/jenkins-build-trigger-github-pull-request/ 
https://plugins.jenkins.io/ghprb/ 

https://dev.to/oliverjumpertz/setting-up-jenkins-to-handle-github-pull-requests-5bjc ++?

https://youtu.be/aDmeeVDrp0o?si=2kFMXuxJBbVa79ua   https://github.com/darinpope/multibranch-sample-app/tree/main 

Set webhook
Settings -> Development -> New app 
http://ec2-3-82-35-54.compute-1.amazonaws.com:48080/github-webhook/

Permissions
Administration Read-Only
Checks Read-Writes
Contents Read Only 
Metadata Read-Only 
Pull Requests Read-Only 
Commit Statuses Read and Write 
# WEBHOOKS in case Jenkins supposes to manage webhook. not in current case.

Subscribe to events
Pull request review thread 

Save it

 Generate a private key
 - save it localy
 - openssl pkcs8 -topk8 -inform PEM -outform PEM -in /mnt/c/temp/argus-cyber-security-challenge.2024-01-30.private-key.pem -out converted-github-app.pem -nocrypt

   install webhook

5. Install webhook to jenkins
6. 
=======

https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com 



6. Create AWS credentials : (or use AWS as cewntials provider?)
secret text jenkins-aws-secret-key-id
jenkins-aws-secret-access-key
Another possible way is  to use  AWS secret manager  plugin and Secret manager

 
