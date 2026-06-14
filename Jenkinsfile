pipeline {
    agent any

    tools {
        nodejs 'node18'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking Source Code'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'SonarQube Scan Stage'
            }
        }

        stage('Build') {
            steps {
                sh 'echo Building Application'
            }
        }

        stage('Test') {
            steps {
                sh 'echo Running Tests'
            }
        }
    }
}
