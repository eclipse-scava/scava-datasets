pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '5'))
  }
  stages {
    stage('SCM') {
        git url: 'https://github.com/borisbaldassari/scava-datasets.git'
    }
    stage('Build') {
        sh 'pwd'
        sh 'ls'
        sh 'process_all_projects.sh' 
        archiveArtifacts artifacts: '**/projects/*.gz', fingerprint: true 
    }
  }
}

