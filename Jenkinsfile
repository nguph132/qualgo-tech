List dockerRepository = ["qualgo-backend","qualgo-frontend"]

pipeline {
  environment {
    awsRegion = "ap-southeast-1"
    registry = '888577040857.dkr.ecr.ap-southeast-1.amazonaws.com'
    registryCredential = "aws-credentials"
    dockerImage = ''
    dockerArgs = '--platform linux/amd64'
    qualgoMysqlConnection = credentials("qualgo_mysql_connection")
  }
  agent any
  stages {
    stage("Prepare") {
        steps {
            script {
                imageTag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                currentDir = steps.sh(script: 'pwd', returnStdout: true).trim()
            }
        }
    }
    stage('Build and push image to ECR') {
        steps{
            script{
                withCredentials([usernamePassword(credentialsId: registryCredential, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh "aws ecr get-login-password --region ${awsRegion} | docker login --username AWS --password-stdin ${registry}"
                    dockerRepository.each { repo ->
                        sh """
                            echo "Building Docker image for ${repo}..."
                            cd ${currentDir}/apps/${repo}
                            docker build -t ${registry}/${repo}:${imageTag} --platform linux/amd64 .
                            docker push ${registry}/${repo}:${imageTag}
                        """
                    }
                }
            }
        }
    }
    stage('Deploy with canary') {
        steps{
            script{
                dir("deploy") {
                    withCredentials([usernamePassword(credentialsId: registryCredential, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh """
                            yq e -i \'.apps.canary-qualgo-backend.tag = \"${imageTag}\"\' charts/qualgo-apps/values.yaml
                            bash deploy-apps.sh
                        """
                    }
                }
            }
        }
    }
    stage('Automation test with 30% weight in canary') {
        steps{
            script{
                dir("deploy") {
                    sh """
                        docker run -v $currentDir/deploy/autotests:/autotests postman/newman:latest run -n 50 /autotests/qualgo.postman_collection.json \
                            --environment /autotests/qualgo.postman_environment.json \
                            --reporters cli,json \
                            --reporter-json-export /autotests/newman-report.json
                    """
                }
            }
        }
    }
    stage('Deploy to production') {
        steps{
            script{
                dir("deploy") {
                    withCredentials([usernamePassword(credentialsId: registryCredential, usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh """
                            yq e -i \'.apps.qualgo-backend.tag = \"${imageTag}\"\' charts/qualgo-apps/values.yaml
                            yq e -i \'.apps.qualgo-frontend.tag = \"${imageTag}\"\' charts/qualgo-apps/values.yaml
                            bash deploy-apps.sh
                        """
                    }
                }
            }
        }
    }
  }
  post {
    always {
        archiveArtifacts artifacts: "deploy/autotests/newman-report.json", fingerprint: true
    }
  }
}