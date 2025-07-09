pipeline {
    agent any

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

        stage ("Update deployment.yaml for ArgoCD") {
            steps {
                script {
                    sh """
                        sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' argocd-manifest/deployment.yaml
                        git config user.name "ci-bot"
                        git config user.email "ci-bot@company.com"
                        git add argocd-manifest/deployment.yaml
                        git commit -m "Update image to ${DOCKER_IMAGE}" || echo 'No changes to commit'
                    """
                }
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        git config --unset credential.helper || true
                        git remote remove origin || true
                        git remote add origin https://${GIT_USER}:${GIT_PASS}@github.com/MANIKANDAN242221/Sample-java-spring-app.git
                        git push origin main
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build, Push & ArgoCD update completed!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
