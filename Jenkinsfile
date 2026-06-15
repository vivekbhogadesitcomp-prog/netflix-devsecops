pipeline {
    agent any

    tools {
        nodejs 'node18'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

stage('OWASP Dependency Check') {
    steps {
        dependencyCheck additionalArguments: '--scan .',
                        odcInstallation: 'dependency-check'
        dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
    }
}	

    stages {

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
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

        stage('Build Application') {
            steps {
                sh 'npm run build'
            }
        }
    }
}
