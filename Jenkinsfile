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
    tools {
        nodejs 'node18'
    }
    steps {
        sh 'node -v'
        sh 'npm -v'
        sh 'npm install'
    }
}

      stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'TOKEN')]) {
                        sh """
                            /var/jenkins_home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/bin/sonar-scanner \
                            -Dsonar.projectKey=devsecops-node \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://host.docker.internal:9000 \
                            -Dsonar.login=$TOKEN
                        """
                    }
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







