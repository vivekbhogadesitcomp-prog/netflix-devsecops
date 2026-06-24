pipeline {
    agent any

    tools {
        nodejs 'node18'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        IMAGE_NAME = "vivek5151/netflix-clone:v3"
    }

    stages {

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    dependencyCheck(
                        additionalArguments: '--scan . --noupdate',
                        odcInstallation: 'dependency-check'
                    )
                }

                dependencyCheckPublisher(
                    pattern: '**/dependency-check-report.xml'
                )
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectKey=netflix-clone \
                    -Dsonar.projectName=Netflix-Clone \
                    -Dsonar.sources=src
                    '''
                }
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image $IMAGE_NAME'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

	stage('Deploy to Kubernetes') {
    steps {
        withCredentials([
            file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
        ]) {
            sh '''
            kubectl set image deployment/netflix-deployment \
            netflix=$IMAGE_NAME

            kubectl rollout status deployment/netflix-deployment

            kubectl get pods
            '''
        }
    }
}

        stage('Email Test') {
            steps {
                mail(
                    to: 'vivekbhogade.sit.comp@gmail.com',
                    subject: 'Pipeline Email Test',
                    body: 'Email sent successfully from Jenkins pipeline'
                )
            }
        }
    }

    post {

        success {
            mail(
                to: 'vivekbhogade.sit.comp@gmail.com',
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
Build Successful

Job Name: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}

Build URL:
${env.BUILD_URL}
"""
            )
        }

        unstable {
            mail(
                to: 'vivekbhogade.sit.comp@gmail.com',
                subject: "UNSTABLE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
Build Unstable

Job Name: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}

Build URL:
${env.BUILD_URL}
"""
            )
        }

        failure {
            mail(
                to: 'vivekbhogade.sit.comp@gmail.com',
                subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
Build Failed

Job Name: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}

Build URL:
${env.BUILD_URL}
"""
            )
        }
    }
}
