pipeline {
    agent any
      stages {
          stage('Lint HTML') {
            steps{
                sh 'tidy -q -e *.html'
            }
          }
          stage('Upload to AWS') {
            steps{
              ### withAWS(credentials:'aws-static', region: 'us-west-2') {
              ###  s3Upload(file:'index.html', bucket:'staticwebpvera02', path:'index.html')
              ###}
              sh 'echo "Hello World!"'
            }
          }
      }
}