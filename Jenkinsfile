pipeline {
    agent any
      stages {
          stage('Lint HTML') {
            steps{
                sh '~/devopscapston_master@tmp/durable-f8cb27b1/script.sh'
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
