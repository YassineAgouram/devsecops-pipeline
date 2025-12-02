param(
  [string]$imageTag = "starbucks_app_yass:local"
)

# builder image avec Docker local
docker build -t $imageTag .

# lancer trivy scan
Write-Host "Scanning $imageTag with Trivy..."
trivy image --exit-code 1 --severity HIGH,CRITICAL $imageTag

# sonar scan via docker sonar-scanner (requires SONAR_HOST env and SONAR_TOKEN)
if (-not $env:SONAR_HOST -or -not $env:SONAR_TOKEN) {
  Write-Warning "SONAR_HOST or SONAR_TOKEN not set. Skipping Sonar scan."
} else {
  docker run --rm -v "${PWD}:/usr/src" sonarsource/sonar-scanner-cli `
    -Dsonar.host.url=$env:SONAR_HOST -Dsonar.login=$env:SONAR_TOKEN -Dsonar.projectBaseDir=/usr/src
}
