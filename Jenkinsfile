pipeline {
  options {
    timeout (time: 35, unit:"MINUTES")
  }
  agent any // or none?
    // dockerfile true ? 
    // docker 161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller:latest


  
  parameters {
            booleanParam(name: 'RELEASE_BUILD', defaultValue: false, description: 'Is the build for release?')  
            string(name: 'BRANCH', defaultValue: '', description: 'Branch to build?')
            choice(name: 'FLOW', choices: ['BUILD', 'TEST', 'PULL'], description: 'Select flow')
            choice(name: 'BRANCH', choices: ['master', 'develop'], description: 'Select branch')            
        }

 environment {
    COMMITTER_EMAIL = sh (
      returnStdout: true,
      script: "echo emailtonotify@email.org"
    ).trim()
  }

stages {
    stage ("Build and Deploy") {
        when {  expression { params.FLOW == 'BUILD' }  }
        steps {
            sh "echo build docker image python with Dockerfile"
        }
    }


    stage ("Pull and Test") {
        when { expression { params.FLOW == 'TEST' }  }
        steps {
            sh "echo build docker image python with Dockerfile"
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