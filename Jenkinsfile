pipeline {
    agent any
      stages {
          stage('Lint HTML') {
            steps{
                sh 'tidy -q -e ~/devopscapston/app/src/static/*.html'
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
