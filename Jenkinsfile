pipeline {
    agent any

    environment {
        IMAGE_TAG = "techdocker24/java:${BUILD_NUMBER}"
        DOCKER_USERNAME = "techdocker24"
        DOCKER_PASSWORD = "Manikandan@2422"
    }

    stages {
        stage ("Clone repository") {
            steps {
                git branch: 'main', url: 'https://github.com/MANIKANDAN242221/Sample-java-spring-app.git'
            }
        }

        stage ("Check for [skip ci] or Jenkins commit") {
            steps {
                script {
                    def commitMessage = sh(
                        script: "git log -1 --pretty=%B",
                        returnStdout: true
                    ).trim()

                    def lastAuthor = sh(
                        script: "git log -1 --pretty=%an",
                        returnStdout: true
                    ).trim()

                    echo "Last commit message: ${commitMessage}"
                    echo "Last author: ${lastAuthor}"

                    if (commitMessage.contains("[skip ci]")) {
                        echo "🛑 Found [skip ci] in commit message. Skipping pipeline."
                        currentBuild.result = 'SUCCESS'
                        return
                    }

                    if (lastAuthor.toLowerCase().contains("jenkins")) {
                        echo "🛑 Last commit was by Jenkins (${lastAuthor}). Skipping to avoid loop."
                        currentBuild.result = 'SUCCESS'
                        return
                    }
                }
            }
        }

        stage ("Build Maven") {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }

        stage ("Docker build & push") {
            steps {
                sh """
                    docker build -t $IMAGE_TAG .
                    echo '$DOCKER_PASSWORD' | docker login -u '$DOCKER_USERNAME' --password-stdin
                    docker push $IMAGE_TAG
                """
            }
        }

        stage ("Update ArgoCD manifest & push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'GitHub-rep', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh """
                        git config user.email 'jenkins@ci.com'
                        git config user.name 'jenkins'

                        sed -i 's|image:.*|image: $IMAGE_TAG|' argocd-manifest/deployment.yaml

                        git add argocd-manifest/deployment.yaml
                        if git diff --cached --quiet; then
                            echo "✅ No changes to commit."
                        else
                            git commit -m 'Update ArgoCD manifest to $IMAGE_TAG [skip ci]'
                            git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/MANIKANDAN242221/Sample-java-spring-app.git
                            git push origin main
                            echo "🚀 Updated ArgoCD manifest pushed."
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
