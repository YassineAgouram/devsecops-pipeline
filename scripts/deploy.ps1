param(
  [string]$imageTag = "starbucks_app_yass:local"
)

# Option A: build image inside minikube docker daemon (recommended)
Write-Host "Switching env to minikube docker..."
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

docker build -t $imageTag .
# no need to push, minikube will have the image

# apply manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# revert docker env to default (if needed)
# & minikube -p minikube docker-env --unset --shell powershell | Invoke-Expression
