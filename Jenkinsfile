node {
    stage('Build') {
        sh 'get_all.sh' 
        archiveArtifacts artifacts: '**/projects/*.gz', fingerprint: true 
    }
}