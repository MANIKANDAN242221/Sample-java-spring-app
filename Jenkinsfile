pipeline {
    agent any

    environment {
        IMAGE_TAG = "techdocker24/java:${BUILD_NUMBER}"
        DOCKER_USERNAME = "techdocker24"
        DOCKER_PASSWORD = "Manikandan@2422"
    }

    stages {
        stage ("Check last commit author/message to skip loop") {
            steps {
                script {
                    // Do a shallow clone in a tmp folder just to check last commit
                    sh """
                        rm -rf tmp-check || true
                        git clone --depth 1 -b main https://github.com/MANIKANDAN242221/Sample-java-spring-app.git tmp-check
                    """

                    def commitMsg = sh(script: "git -C tmp-check log -1 --pretty=%B", returnStdout: true).trim()
                    def lastAuthor = sh(script: "git -C tmp-check log -1 --pretty=format:'%an'", returnStdout: true).trim()

                    echo "🔍 Last commit author: ${lastAuthor}"
                    echo "🔍 Last commit message: ${commitMsg}"

                    if (commitMsg.contains("[skip ci]")) {
                        echo "🛑 Found [skip ci] in last commit message. Skipping build."
                        currentBuild.result = 'SUCCESS'
                        return
                    }

                    if (lastAuthor.toLowerCase().contains("jenkins")) {
                        echo "🛑 Last commit was by Jenkins (${lastAuthor}). Skipping to avoid loop."
                        currentBuild.result = 'SUCCESS'
                        return
                    }

                    echo "✅ Passed skip checks, proceeding."
                }
            }
        }

        stage ("Clone repository") {
            steps {
                git branch: 'main', url: 'https://github.com/MANIKANDAN242221/Sample-java-spring-app.git'
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
                            echo "🚀 Manifest pushed with [skip ci]."
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
            echo "❌ Pipeline failed. Please check logs."
        }
        always {
            echo "ℹ️ Pipeline done."
        }
    }
}
