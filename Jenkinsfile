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
            string(name: 'BRANCH', defaultValue: '', description: 'Branch to build?')
            choice(name: 'FLOW', choices: ['DEPLOY','BUILD', 'TEST', 'PULL'], description: 'Select flow')
            choice(name: 'BRANCH', choices: ['master', 'develop'], description: 'Select branch')            
        }

 environment {
    COMMITTER_EMAIL = sh (
      returnStdout: true,
      script: "echo emailtonotify@email.org"
    ).trim()
    
    AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id') // secret text 
    AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
  }

stages {

    stage ("Build and Deploy") {
        when {  
         anyOf { triggeredBy cause: 'UserIdCause'  ;   triggeredBy 'GitHubPushCause' }
                expression { params.FLOW != 'TEST' } 
        }  
        steps {
            echo "build docker image python with Dockerfile"
            sh "docker build -f Dockerfile.python -t argus/python ."
            sh "docker run --rm -v ${PWD}:/app argus/python"
            sh "cat artifact.txt"
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