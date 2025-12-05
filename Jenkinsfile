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
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_TOKEN')]) {
            withSonarQubeEnv('SonarQube') {
                sh """
                    ${tool 'sonar-scanner'}/bin/sonar-scanner \
                      -Dsonar.projectKey=devsecops-node \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=http://host.docker.internal:9000 \
                      -Dsonar.login=$SONAR_TOKEN
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
stage('Install kubectl') {
    steps {
        sh """
        mkdir -p \$HOME/bin
        curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl
        chmod +x kubectl
        mv kubectl \$HOME/bin/kubectl
        export PATH=\$HOME/bin:\$PATH
        """
    }
}


        

stage('Run Kubernetes Deployment') {
            steps {
               // sh ' kubectl  --apply -f k8s/'
               sh 'ansible-playbook k8s/deploy_k8s.yml'

            }
        }

    

    stage('Monitoring') {
            steps {
                script {
                    def minikubeIP = sh(script: "minikube ip", returnStdout: true).trim()
                    sh "kubectl apply -f k8s/prometheus-deployment.yml"
                    sh "kubectl apply -f k8s/grafana-deployment.yml"
                    def prometheusPort = sh(script: "kubectl get svc prometheus -o jsonpath='{.spec.ports[0].nodePort}'", returnStdout: true).trim()
                    def grafanaPort = sh(script: "kubectl get svc grafana -o jsonpath='{.spec.ports[0].nodePort}'", returnStdout: true).trim()
                    echo "Monitoring déployé. URL Prometheus: http://${minikubeIP}:${prometheusPort}, Grafana: http://${minikubeIP}:${grafanaPort}"
                }
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













































