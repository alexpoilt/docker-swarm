def img

pipeline {
    // agent any // localhost
    agent { label 'docker-agent' } // swarm
    environment {
      REGISTRY = credentials('dockerhub') // _USR e _PSW
    }
    stages {
        stage('Build') {
            steps {
                cleanWs()
                git 'http://gitea.172-27-11-10.nip.io/developer/php.git'
                withDockerServer([credentialsId: 'docker-certs', uri: 'tcp://172.27.11.10:2376']) {
                    //sh "docker build -t ${REGISTRY_USR}/php-app:$BUILD_NUMBER ."
                    script { img = docker.build("${REGISTRY_USR}/php-app:${BUILD_NUMBER}") }
                }
            }
        }
        stage('Test') {
            steps {
                withDockerServer([credentialsId: 'docker-certs', uri: 'tcp://172.27.11.10:2376']) {
                    //sh 'docker run -dti --name php-app php-app'
                    //sh 'docker exec -ti php-app "wget -O - localhost:8080 > /dev/null"'
                    //sh 'docker rm -f php-app || /bin/true'
                    script {
                        img.withRun() { c -> // swarm
                            sh "docker exec ${c.id} sh -c 'wget -O - localhost:8080 > /dev/null'"
                        }
                        /*img.inside() { // localhost
                            sh 'php -S 0.0.0.0:8080 -t /app &'
                            sleep 5
                            sh 'wget -O - localhost:8080 > /dev/null'
                        }*/
                    }
                }
            }
        }
        stage('Save') {
            steps {
                withDockerServer([credentialsId: 'docker-certs', uri: 'tcp://172.27.11.10:2376']) {
                    sh "docker login -u ${REGISTRY_USR} -p ${REGISTRY_PSW}"
                    //sh "docker push ${REGISTRY_USR}/php-app:$BUILD_NUMBER"
                    //sh "docker rmi -f ${REGISTRY_USR}/php-app:$BUILD_NUMBER"
                    script { img.push() }
                }
            }
        }
        stage('Deploy') {
            steps {
                withDockerServer([credentialsId: 'docker-certs', uri: 'tcp://172.27.11.10:2376']) {
                    sh '''docker service ps php-app && 
                            docker service update --quiet --image $REGISTRY_USR/php-app:$BUILD_NUMBER --publish-add 9090:8080 php-app ||
                            docker service create --quiet --name php-app -p 9090:8080 $REGISTRY_USR/php-app:$BUILD_NUMBER'''
                }
            }
        }
    }
    post {
        always {
            withDockerServer([credentialsId: 'docker-certs', uri: 'tcp://172.27.11.10:2376']) {
              sh "docker rmi -f ${img.id}"
            }
        }
    }
}
