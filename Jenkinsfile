node {
    stage('Build') {
        sh 'pwd'
        sh 'ls && sh process_all_projects.sh' 
        archiveArtifacts artifacts: '**/projects/*.gz', fingerprint: true 
    }
}
