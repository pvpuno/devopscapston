pipeline {
    agent any
    stages {

        stage('Lint Dockerfile') {
                steps {
                    script{
                        docker.image('hadolint/hadolint:latest-alpine').inside()
                        {
                            sh 'echo "Started Pipeline, Start linting Dockerfile"'
                            sh 'hadolint ./Dockerfile | tee -a hadolint_output.txt'
                            sh '''
                                lintErrors=$(stat -c "%s" hadolint_output.txt)
                                if [ "$lintErrors" -gt "0" ]; then
                                    echo "Errors found in Dockerfile, please see below"
                                    cat hadolint_output.txt
                                    exit 1
                                else
                                    echo "Dockerfile was linted and no errors found."
                                fi
                            '''
                        }
                    }
                }   
        }

        stage('Lint HTML') {
            steps{
                sh 'tidy --show-warnings no app/src/static/*.html'
            }
        }

        stage('Security Scan') {
            steps { 
                aquaMicroscanner imageName: 'node:10-alpine', notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
            }
        }

        stage('Build Docker Image') {
              steps {
                sh 'docker build -t todoapp .'
            }
        }

         stage('Push Image to DockerHub') {
              steps {
                  withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
                      sh "docker tag todoapp pvpuno/todoapp"
                      sh 'docker push pvpuno/todoapp'
                  }
              }
        }

        stage('Upload Logs to AWS S3') {
            steps{
                withAWS(credentials:'awscred', region: 'us-west-2') {
                    s3Upload(file:'hadolint_output.txt', bucket:'staticwebpvera02', path:'hadolint_output.txt')
                    sh 'echo "Hello World!"'
                }
            }
        }
    }
}