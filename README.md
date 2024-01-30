# ArgusCyber_assignment


 README


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

 docker pull 161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller:latest

 docker run -d -u root --name /argus-jenkins -v //var/run/docker.sock:/var/run/docker.sock -v jenkins_argus:/var/jenkins_home --restart unless-stopped -p 50000:50000 -p 48080:8080  161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller


Jenkins admin pass # cat /var/jenkins_home/secrets/initialAdminPassword
ce29967b507b4396ba6d060a3c1baf35
# 

JENKINS plugins to install :
- Parameterized Scheduler  to use instead of regular
    triggers {
        cron('H 0 * * *')
        
- Install plugin Github Pull Request Builder
add credentials 
https://devopscube.com/jenkins-build-trigger-github-pull-request/ 
https://plugins.jenkins.io/ghprb/ 

https://dev.to/oliverjumpertz/setting-up-jenkins-to-handle-github-pull-requests-5bjc ++?

https://youtu.be/aDmeeVDrp0o?si=2kFMXuxJBbVa79ua   https://github.com/darinpope/multibranch-sample-app/tree/main 

Set webhook

=======

https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com 




 
