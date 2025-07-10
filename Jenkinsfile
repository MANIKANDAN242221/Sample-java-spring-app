pipeline {
    agent any

    environment {
        IMAGE_TAG = "techdocker24/java:latest"
    }

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

        stage ("docker build & push") {
            steps {
                sh "docker build -t $IMAGE_TAG ."
                sh "docker login -u techdocker24 -p 'Manikandan@2422'"
                sh "docker push $IMAGE_TAG"
            }
        }

        stage ("update manifest & push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'GitHub-rep', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh """
                        git config user.email 'jenkins@ci.com'
                        git config user.name 'jenkins'
                        sed -i 's|image:.*|image: $IMAGE_TAG|' deployment.yaml
                        git add deployment.yaml
                        git commit -m 'Update image to $IMAGE_TAG'
                        git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/MANIKANDAN242221/Sample-java-spring-app.git
                        git push origin main
                    """
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline completed SUCCESSFULLY. Docker image pushed & ArgoCD manifest updated!"
        }
        failure {
            echo "💥 Pipeline FAILED. Please check above logs for errors."
        }
    }
}
