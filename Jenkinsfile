pipeline {
    agent { label 'k8s' }

    environment {
        DOCKER_IMAGE = "techdocker24/java:${env.BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds' // Jenkins credentials ID
        DEPLOYMENT_NAME = 'sample-java-app' // Replace with your actual deployment name
    }

    stages {
        stage("Clone") {
            steps {
                git branch: 'main', url: 'https://github.com/MANIKANDAN242221/Sample-java-spring-app.git'
            }
        }

        stage("Build Maven") {
            steps {
                sh "mvn clean install"
            }
        }

        stage("Build Docker Image") {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage("Push Docker Image") {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage("Deploy to Kubernetes") {
            steps {
                script {
                    sh "ls -l deployment.yaml"

                    sh """
                        sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' deployment.yaml
                        kubectl apply -f deployment.yaml
                        kubectl rollout status deployment/${techdocker24/java}
                        kubectl get pods -o wide
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build & Kubernetes deploy completed!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
