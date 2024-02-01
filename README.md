# ArgusCyber_assignment

## Pipeline setup
1. Create EC2 instance with Docker 

sudo yum install docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -a -G docker ec2-user

Security groups allow SSH and HTTP access 

2. Pull and run image of Jenkins image with providedAWS creds
 
_aws ecr get-login-password --region us-east-1  | docker login --username AWS --password-stdin 161192472568.dkr.ecr.us-east-1.amazonaws.com
WARNING! Your password will be stored unencrypted in /home/ec2-user/.docker/config.json._

 _docker pull 161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller:latest_

 _docker run -d -u root --name /argus-jenkins -v //var/run/docker.sock:/var/run/docker.sock -v jenkins_argus:/var/jenkins_home --restart unless-stopped -p 50000:50000 -p 48080:8080  161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller_


Jenkins admin pass # cat /var/jenkins_home/secrets/initialAdminPassword
ce29967b507b4396ba6d060a3c1baf35

User jenkins/jenkins_vlad.bronfman

# 

3. JENKINS plugins to install :
   For time sake I'm going to istall it manuall/ Proper way is to update image with forged plugins.txt
   
- Parameterized Scheduler  to use instead of regular https://plugins.jenkins.io/parameterized-scheduler/ 
        
- Github Pull Request Builder

4 Create GitHub application and  webhook

Settings -> Development -> New app 

http://ec2-44-204-45-219.compute-1.amazonaws.com/github-webhook/

Permissions:

- Administration Read-Only
- Checks Read-Writes
- Contents Read Only 
- Metadata Read-Only 
- Pull Requests Read-Only 
 - Commit Statuses Read and Write 


Subscribe to events:

Pull request review thread ....

Push

 Generate a private key
 
 - save it localy
 - openssl pkcs8 -topk8 -inform PEM -outform PEM -in /mnt/c/temp/argus-cyber-security-challenge.2024-01-30.private-key.pem -out converted-github-app.pem -nocrypt

 Install webhook

5. Install webhook to jenkins with application number

6. Create AWS credentials : (or use AWS as cewntials provider?)

_secret text jenkins-aws-secret-key-id_

_jenkins-aws-secret-access-key_

[!NOTE] Another possible way is  to use  AWS secret manager  plugin and Secret manager.


## Pipeline 

### Stage Build and Deploy 
1. Builds 'main' branch
2.  Builds with Dockerfile an image to run [python main.py]
3. Triggers by merge/push to 'main' branch or manually by selecting "DEPLOY"
4. Script main.py creates writes to file 'artifact.txt' in CWD of container. The folder mapped to //var/jenkins_home/workspace/ArgusCyber of Jenkins container
[!NOTE] There is an issue with finding out the file 'artifact.txt': it doesn't uppear in /var/jenkins_home/workspace/ArgusCyber . For debug sake, created file 
   
5. File copied to S3 bucket 'vlad.bronfman'
6. Image pushed to ECR


### Stage TEst
1.  Triggers by cron or manually  by selecting "TEST"
3. Downloads file artifact.txt'  from S3 bucket vlad.bronfman to workspace 
4. Tests file is empty and prints out result  to terminal



 ## TODO
 1. Fix issue of artifact.txt
 2. Set proper condition to select stage: by PR branch 
 3. Review checkout    git branch: "${params.BRANCH}"
