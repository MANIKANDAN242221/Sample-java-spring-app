pipeline {
    agent any
    stages{
        stage ("clone") {
            steps {
                git branch: 'main', url:'https://github.com/MANIKANDAN242221/Sample-java-spring-app.git'
            }
        }
        stage ("build") {
            steps {
                sh "mvn clean install"
            }
        }
        stage ("docker image"){
            steps {
                sh "docker build -t techdocker24/java ."
                sh "docker images"
            }
        }
        stage("docker hub") {
            steps {
                sh "docker login -u techdocker24 -p Manikandan@2422"
                sh "docker push techdocker24/java"
            }
        }
        stage ("docker conatainer"){
            steps {
                sh "docker rm -f java"
                sh "docker run -d --name java -p 8087:8080 techdocker24/java"
            }
        }
    }
}
