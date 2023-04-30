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
          """
          //         ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} "rm -rf /home/ubuntu/my-blog-master/*"
          // scp -o StrictHostKeyChecking=no -r ${WORKSPACE}/my-blog  ubuntu@${ec2_instanse}:/home/ubuntu/my-blog-master/
        }
      }
    }
    stage('Deploy'){
      steps {
        sshagent(['my-creds']) {
          sh """
          echo "${WORKSPACE}"
          ls -l
          """
          //         ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} "rm -rf /home/ubuntu/my-blog-master/*"
          // scp -o StrictHostKeyChecking=no -r ${WORKSPACE}/my-blog  ubuntu@${ec2_instanse}:/home/ubuntu/my-blog-master/
        }
      }
    }
  }
}