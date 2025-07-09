pipeline {
    agent { label 'k8s' }

    environment {
        DOCKER_IMAGE = "techdocker24/java:${env.BUILD_NUMBER}"
    }

    stages {
        stage ("Clone") {
            steps {
                git branch: 'main', url: 'https://github.com/MANIKANDAN242221/Sample-java-spring-app.git'
            }
        }

        stage ("Build Maven") {
            steps {
                sh "mvn clean install"
            }
        }

        stage ("Build Docker Image") {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage ("Push Docker Image") {
            steps {
                sh "docker login -u techdocker24 -p Manikandan@2422"
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage ("Deploy to Kubernetes") {
            steps {
                script {
                    sh """
                        sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' k8s-deployment.yaml
                        kubectl apply -f k8s-deployment.yaml
                        kubectl get pods
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build, Push & Kubernetes deploy completed!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
