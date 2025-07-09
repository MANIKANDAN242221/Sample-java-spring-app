pipeline {
    agent any

    stages {
        stage ("clone") {
            steps {
                git branch: 'main', url: 'https://github.com/MANIKANDAN242221/Sample-java-spring-app.git'
            }
        }

        stage ("build") {
            steps {
                sh "mvn clean install"
            }
        }

        stage ("docker image") {
            steps {
                sh "docker build -t techdocker24/java ."
            }
        }

        stage ("docker hub") {
            steps {
                sh "docker login -u techdocker24 -p Manikandan@2422"
                sh "docker push techdocker24/java"
            }
        }

        stage ("k8s deploy") {
            steps {
                sh "kubectl apply -f k8s-deployment.yaml"
                sh "kubectl get pods -o wide"
            }
        }
    }

    post {
        success {
            echo '✅ Build & Deployment successful!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
