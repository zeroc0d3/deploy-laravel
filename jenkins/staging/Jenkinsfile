def GITHUB_REPO = 'git@github.com:zeroc0d3/deploy-laravel.git'
def workspace = env.WORKSPACE

pipeline {
    agent any
    stages {
        stage('Testing Application') {
            failFast true
            parallel {

                stage('Initialize Database') {
                    steps {
                        sh 'docker-compose -f /opt/mariadb/docker-compose.yml up -d'
                        sh "echo '>> Starting Container MariaDB... DONE !'"
                        sh '''
                            docker inspect jenkins_mariadb | grep "IP"
                            "echo '>> Checking for MariaDB services... DONE !'"
                        '''
                    }
                }

                stage('Unit Test') {
                    agent {
                        docker {
                            image 'edbizarro/gitlab-ci-pipeline-php:7.4-alpine'
                            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
                        }
                    }

                    steps {
                        checkout([$class: 'GitSCM', branches: [[name: '*/dev-staging']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'MYAPP_SSH_PRIVATE_KEY', url: GITHUB_REPO]]])
                        sh "echo '>> Checkout Repository... DONE !'"

                        sh '''
                            cd "${workspace}"
                            cp ./src/.env.pipeline.jenkins ./src/.env
                            make fixing-cache
                            make composer-install-cicd
                            make key-generate
                            make composer-dumpautoload
                            make run-migrate-all
                            make clear-all
                        '''
                    }
                }

            }
        }

        stage('Deploy Staging') {
            when {
                anyOf {
                    branch 'dev-staging'
                    environment name: 'DEPLOY_TO', value: 'staging'
                }
            }
            agent {
                docker {
                    image 'ruby:2.7.1-slim-buster'
                    args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            environment {
                MYAPP_SSH_PRIVATE_KEY = credentials('MYAPP_SSH_PRIVATE_KEY')
                MYAPP_SSH_PEM_KEY = credentials('MYAPP_SSH_PEM_KEY')
                MYAPP_KNOWN_HOSTS = credentials('MYAPP_KNOWN_HOSTS')
            }
            steps {
                withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'MYAPP_SSH_PRIVATE_KEY', \
                                                             keyFileVariable: 'MYAPP_SSH_PRIVATE_KEY')]) {
                    sh '''
                        #################
                        ### SETUP SSH ###
                        #################
                        apt-get update -qq
                        apt-get install -qq git build-essential
                        apt-get install -qq openssh-client
                        mkdir -p ~/.ssh
                        echo "${MYAPP_SSH_PRIVATE_KEY}" | tr -d '\r' > ~/.ssh/id_rsa
                        echo "${MYAPP_KNOWN_HOSTS}" | tr -d '\r' > ~/.ssh/known_hosts
                        chmod 700 ~/.ssh/id_rsa
                        eval "$(ssh-agent -s)"
                        ssh-add ~/.ssh/id_rsa
                        ssh-keyscan -H 'gitlab.com' >> ~/.ssh/known_hosts
                        chmod 644 ~/.ssh/known_hosts

                        #######################
                        ### INSTALL LIBRARY ###
                        #######################
                        cd "${workspace}"
                        cp "${MYAPP_SSH_PEM_KEY}" > keys/myapp.pem
                        chmod 400 keys/MYAPP.pem

                        gem install bundler
                        bundle install
                        echo "--- ---"
                        make deploy-staging
                    '''
                }
            }
        }
    }
    options {
        // Only keep the 10 most recent builds
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }
}
