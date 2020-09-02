pipeline {
    agent any
      stages {
          stage('Lint HTML') {
            steps{
                sh 'sudo cd ~/devopscapston/app/src/static'
                sh 'tidy -q -e *.html'
            }
          }
          stage('Upload to AWS') {
            steps{
              withAWS(credentials:'awscred', region: 'us-west-2') {
              
              }
              sh 'echo "Hello World!"'
            }
          }
      }
}
