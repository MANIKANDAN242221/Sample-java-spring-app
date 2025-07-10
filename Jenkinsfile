pipeline {
    agent any

    environment {
        IMAGE_TAG = "techdocker24/java:latest"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
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

        stage ("update ArgoCD manifest & push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'GitHub-rep', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh """
                        git config user.email 'jenkins@ci.com'
                        git config user.name 'jenkins'

                        # Update the image in argocd manifest
                        sed -i 's|image:.*|image: $IMAGE_TAG|' argocd-manifest/deployment.yaml || true

                        git add argocd-manifest/deployment.yaml || true

                        # Only commit & push if changed
                        if git diff --cached --quiet; then
                            echo "✅ No changes to commit in ArgoCD manifest."
                        else
                            git commit -m 'Update ArgoCD manifest to $IMAGE_TAG'
                            git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/MANIKANDAN242221/Sample-java-spring-app.git
                            git push origin main
                            echo "🚀 Updated ArgoCD manifest pushed to repo."
                        fi
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Please check the logs."
        }
        always {
            echo "ℹ️ Pipeline finished."
        }
    }
}
