node {
    stage('Build') {
        sh 'process_all_projects.sh' 
        archiveArtifacts artifacts: '**/projects/*.gz', fingerprint: true 
    }
}
