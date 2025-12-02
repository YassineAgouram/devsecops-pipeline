pipeline {
  agent any

  environment {
    // adapter si besoin
    DOCKER_IMAGE = "starbucks_app_yass:${env.BUILD_NUMBER}"
    // SONAR_HOST_URL and SONAR_TOKEN must be configured in Jenkins credentials/global config
    SONAR_HOST = credentials('SONAR_HOST') // ex: http://localhost:9000
    SONAR_TOKEN = credentials('SONAR_TOKEN')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'npm ci'
      }
    }

    stage('Lint & Test') {
      steps {
        // adapte selon ton projet
        sh 'npm run lint || true'
        sh 'npm test || true'
      }
    }

  stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('sonarqube') {
            sh 'npm install'
            sh 'node --version'
            sh 'sonar-scanner'
        }
    }
}


    stage('Build Docker image') {
      steps {
        script {
          // if Jenkins runs in container and needs Docker socket, ensure the Jenkins container has access to host docker
          sh "docker build -t ${DOCKER_IMAGE} ."
        }
      }
    }

    stage('Trivy Scan image') {
      steps {
        // run trivy to scan image
        sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_IMAGE} || true"
        // The '|| true' prevents pipeline failing; remove it if you want to fail on findings.
      }
    }

    stage('Push image to registry (optional)') {
      steps {
        // For local minikube we will use image load, for external registry use docker push
        echo 'If you use Docker Hub, login and push here. For minikube we will load image into minikube in deploy stage.'
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        // use kubectl installed on Jenkins or call a script that kubectl apply the k8s manifests
        sh 'kubectl apply -f k8s/deployment.yaml -n default'
        sh 'kubectl apply -f k8s/service.yaml -n default'
      }
    }
  }

post {
    always {
        script {
            node {
                archiveArtifacts artifacts: "reports/**", allowEmptyArchive: true
            }
        }
    }
}


