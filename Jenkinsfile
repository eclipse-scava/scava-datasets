node {
    stage('Build') {
        sh 'ls && sh process_all_projects.sh' 
        archiveArtifacts artifacts: '**/projects/*.gz', fingerprint: true 
    }
}
