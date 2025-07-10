pipeline {
    agent any

    environment {
        IMAGE_TAG = "techdocker24/java:${BUILD_NUMBER}"
        GIT_REPO = "https://github.com/MANIKANDAN242221/Sample-java-spring-app.git"
    }

    stages {
        stage ("clone") {
            steps {
                git branch: 'main', url: "$GIT_REPO"
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
                // replace the image line in deployment.yaml with our new tag
                sh "sed -i 's|image: techdocker24/java.*|image: $IMAGE_TAG|' deployment.yaml"

                // commit & push changes back to git so ArgoCD can deploy
                sh "git config user.email 'jenkins@ci.com'"
                sh "git config user.name 'jenkins'"
                sh "git commit -am 'Update image to $IMAGE_TAG'"
                sh "git push origin main"
            }
        }
    }
}
