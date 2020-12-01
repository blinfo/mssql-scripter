pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    environment {
        APP_IMAGE = 'blinfo/mssql-scripter'
        DOCKER_CREDS = credentials('docker-hub-credentials')
    }
    stages {
        stage('Docker login'){
            steps {
                sh "docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}"
            }
        }
        stage('Build') {
            steps {
                sh 'docker image build -t ${APP_IMAGE}:${BRANCH_NAME} .'
            }
        }
        stage('Tag') {
            steps {
                sh 'docker image tag ${APP_IMAGE}:${BRANCH_NAME} ${APP_IMAGE}:latest'
            }
        }
        stage('Push') {
            steps {
                sh 'docker image push ${APP_IMAGE}:${BRANCH_NAME}'
                sh 'docker image push ${APP_IMAGE}:latest'
            }
        }
    }
    post {
        failure {
        // Email Ext plugin:
            emailext body: '${DEFAULT_CONTENT}', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: '${DEFAULT_SUBJECT}'
            script {
              COMMITER_EMAIL = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%ae"')
            }
            emailext body: '${JELLY_SCRIPT,template="bl"}', subject: "${JOB_NAME} build ${BUILD_NUMBER} ${currentBuild.currentResult}", to: "${COMMITER_EMAIL}"
        }
    }
}
