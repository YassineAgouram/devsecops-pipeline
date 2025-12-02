pipeline {
    agent any

    environment {
        REGISTRY = "myregistry"
        IMAGE_NAME = "starbucks-app"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Node Modules') {
            steps {
                sh 'npm install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy fs . --exit-code 0'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Run Minikube Deployment') {
            steps {
                sh "kubectl apply -f k8s/"
            }
        }
    }

    post {
        always {
            script {
                node {
                    archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
                }
            }
        }
    }
}
