pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '5'))
  }
  stages {
    stage('SCM') {
      steps {
        git url: 'https://github.com/borisbaldassari/scava-datasets.git'
      }
    }
    stage('Build') {
      steps {
        sh 'pwd'
        sh 'ls'
        sh 'sh ./process_all_projects.sh' 
        archiveArtifacts artifacts: '**/projects/*.gz', fingerprint: true 
      }
    }
  }
}

