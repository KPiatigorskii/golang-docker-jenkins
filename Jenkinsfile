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
    stage('Deploy'){
      steps {
        sshagent(['my-creds']) {
          sh """
          echo "${WORKSPACE}"
          ls -l
          sudo yum update -y
          sudo amazon-linux-extras install docker
          sudo service docker start
          sudo systemctl enable docker
          sudo usermod -a -G docker ec2-user
          docker ps
          """
          //         ssh -o StrictHostKeyChecking=no ubuntu@${ec2_instanse} "rm -rf /home/ubuntu/my-blog-master/*"
          // scp -o StrictHostKeyChecking=no -r ${WORKSPACE}/my-blog  ubuntu@${ec2_instanse}:/home/ubuntu/my-blog-master/
        }
      }
    }
  }
}