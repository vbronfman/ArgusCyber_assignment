pipeline {
  options {
    timeout (time: 35, unit:"MINUTES")
  }
  agent any // or none?
    // dockerfile true ? 
    // docker 161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller:latest

  triggers {
         parameterizedCron('''
            # leave spaces where you want them around the parameters. They'll be trimmed.
            # we let the build run with the default name
            0 17 * * * %FLOW=TEST;PLANET=Pluto
 #           */3 * * * * %FLOW=TEST;PLANET=Pluto
        ''')
    
      //  githubPullRequest(
   //         autotest: true,
    //        branches: [[pattern: 'master']])
    }


  parameters {
            booleanParam(name: 'RELEASE_BUILD', defaultValue: false, description: 'Is the build for release?')  
            string(name: 'S3_BUCKET', defaultValue: 'vlad.bronfman', description: 'S3 bucket artefact')
            choice(name: 'FLOW', choices: ['DEPLOY','BUILD', 'TEST', 'PULL'], description: 'Select flow')
            choice(name: 'BRANCH', choices: ['main', 'develop'], description: 'Select branch') 
            string(name:  'AWS_ACCOUNT', defaultValue: '161192472568', description: 'AWS account')


        }

 environment {
    COMMITTER_EMAIL = sh (
      returnStdout: true,
      script: "echo vladimirb3@amdocs.com"
    ).trim()
    
    AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id') // secret text 
    AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
  }

stages {

    stage ("Build and Deploy") {
        when {  
               branch 'main'
               anyOf { triggeredBy cause: 'UserIdCause'  ;   triggeredBy 'GitHubPushCause' } // start on push , have to change on push to pr branch
               expression { params.FLOW != 'TEST' }   
        }  
        steps {
            echo "build docker image python with Dockerfile"
            git branch: "${params.BRANCH}", credentialsId: 'Argus-Cyber-Security-challenge', url: 'https://github.com/vbronfman/ArgusCyber_assignment.git'

            sh "docker build -f Dockerfile.python -t ${params.AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/vlad.bronfman:latest ."
            sh "docker run --rm -v ${env.WORKSPACE}:/out ${params.AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/vlad.bronfman:latest"
            
            script{
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                   sh "ls ${env.WORKSPACE} "
                  sh "ls ${env.WORKSPACE}/artifact.txt"
            
            
            sh "aws ecr get-login-password --region us-east-1  | docker login --username AWS --password-stdin ${params.AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com"
            echo "Pushing image to ${params.AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/vlad.bronfman:latest"
            sh "docker push ${params.AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/vlad.bronfman:latest"
            echo "Pushing artefact to ${params.S3_BUCKET}"
            sh "aws s3 cp ${env.WORKSPACE}/artifact.txt s3://${params.S3_BUCKET}/ "
           } // script 
        }
    }

    }
    stage ("Pull and Test") {
        //when { expression { params.FLOW == 'TEST' }  }
         when { anyOf { triggeredBy cause: 'UserIdCause'  ;   triggeredBy 'ParameterizedTimerTriggerCause' }
                expression { params.FLOW == 'TEST' } 
 }
        steps {
            echo "Download most recent artifact from S3 and check if it is empty"
            sh "aws s3 ls"
            sh "aws s3api get-object --bucket ${params.S3_BUCKET} --key  artifact.txt" // !!! update with proper path!!!! 

            script {
            if (fileExists('./artifact.txt')) {
                echo "File artifact.txt exists!"
                String out = readFile('./artifact.txt').trim()
                if (out?.trim()) {
                    print out // not empty
                  }
                  else {
                    echo "ARTIFACT is empty file!"
                  }
            }
            }
        }
        
        }
    

    

} //stages

post {
        always {
            // Clean up or notifications can go here
            echo 'Cleanup'
        }
                 success {
              echo "Success"
                 }
    }
}