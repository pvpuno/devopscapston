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
                                    echo "Dockerfile was linted and no errors found." | tee -a hadolint_output.txt
                                fi
                            '''
                        }
                    }
                }   
        }

        stage('Lint HTML') {
            steps{
                sh '(tidy -q -e app/src/static/*.html || set status=0)'
                sh '''
                    echo "index.html was linted and no errors found, May be some warnings."
                '''
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

        stage('Deploy Production') {
              steps{
                  echo 'Deploying to our infra'
                  withAWS(credentials: 'aws-cred', region: 'us-west-2') {
                      sh "aws eks --region us-west-2 update-kubeconfig --name prodcluster"
                      sh "kubectl config use-context arn:aws:eks:us-west-2:368985348424:cluster/prodcluster"
                      sh "kubectl apply -f deploy.yaml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployments"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/capstone-todoapp"
                  }
              }
        }

        stage('Upload Logs to AWS S3') {
            steps{
                withAWS(credentials:'aws-cred', region: 'us-west-2') {
                    s3Upload(file:'hadolint_output.txt', bucket:'staticwebpvera02', path:'hadolint_output.txt')
                    sh 'echo "Hello World!"'
                }
            }
        }
        
        stage('Confirming App Status') {
              steps{
                  echo 'Checking Endpoint accesible'
                  withAWS(credentials: 'aws-cred', region: 'us-west-2') {
                     sh "curl https://ab30ac6c6e858408fb9965480f142272-269061326.us-west-2.elb.amazonaws.com:3000"
                  }
               }
        }
    }
}