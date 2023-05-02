// this will start an executor on a Jenkins agent with the docker label
pipeline {
  agent any
  stages {
    stage('Build base image') {
      steps {
        sh 'make build-base'
      }
    }
    stage('Run tests') {
      steps {
        // sh 'make build-test'
        // sh 'make test-unit'
        sh 'ls'
        // junit 'report/report.xml'
      }
    }
    stage('Build image') {
      steps {
        sh 'make build'
      }
    }

    stage('Install Docker to EC2'){
      steps {
        sshagent(['my-creds']) {
          sh """
          echo "${WORKSPACE}"
          ls -l
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo apt-get -y update'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo apt install -y apt-transport-https ca-certificates curl software-properties-common'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'apt-cache policy docker-ce'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo apt install -y docker-ce'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo systemctl status docker' 
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo systemctl enable docker'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo docker ps'
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'sudo apt install -y make'
          """
        }
      }
    }
    stage('Deploy'){
      steps {
        sshagent(['my-creds']) {
          sh """
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} "rm -rf /home/ubuntu/golang-app/*"
          scp -o StrictHostKeyChecking=no -r ${WORKSPACE}/  ubuntu@${ec2_instanse}:/home/ubuntu/golang-app/
          ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} 'cd /home/ubuntu/golang-app/GOLANG/ && sudo make build-base && sudo make build && sudo make run'
          """
        }
      }
    }
    stage('Push to registry'){
      steps{
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {                
            sh 'docker login -u $USERNAME -p $PASSWORD'
            sh "docker tag charlires/webapp:\$(git rev-parse --short HEAD) kpiatigorskii/webapp"
            sh "docker push kpiatigorskii/webapp"
        }
        
      }
    }

    stage('Push with latest release tag'){
      steps{
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {                
          sh 'docker login -u $USERNAME -p $PASSWORD'
          sh "docker tag charlires/webapp:\$(git rev-parse --short HEAD) kpiatigorskii/webapp:release"
          sh "docker push kpiatigorskii/webapp:release"
        }
      }      
    }
  }

  post {
        always {
            script {
                def currentBuildStatus = currentBuild.result

                if (currentBuildStatus == 'SUCCESS') {
                    slackSend(
                        color: "#00FF00",
                        channel: "jenkins-notify",
                        message: "${currentBuild.fullDisplayName} succeeded",
                        tokenCredentialId: 'slack-token'
                    )
                } else {
                    slackSend(
                        color: "#FF0000",
                        channel: "jenkins-notify",
                        message: "${currentBuild.fullDisplayName} was failed",
                        tokenCredentialId: 'slack-token'
                    )
                }
            }
        }
    }
}