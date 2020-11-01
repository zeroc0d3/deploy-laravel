# Deployment Laravel with Jenkins & Capistrano

## Prerequirements
* Jenkins
* Docker
* Docker-Compose

## Setup Jenkinse
### Jenkins Plugin
* ThinBackup (optional)
* Blue Ocean
* JIRA Integration for Blue Ocean
* Bitbucket Pipeline for Blue Ocean
* GitHub Pipeline for Blue Ocean
* Git Pipeline for Blue Ocean

### Setup Jenkins Credential
* SSH Private Key
  ```
  MYAPP_SSH_PRIVATE_KEY
  ```
* Known Hosts
  ```
  MYAPP_KNOWN_HOSTS
  ```
* Add your SSH Private Key as deployment key to
  - CI/CD Repository GitHub / GitLab / BitBucket
- Add your SSH Private Key as `authorized_keys` inside your VPS

## Container Jenkins Pipeline
### Running Docker Jenkins
* Clone this repository
  ```
  git clone git@github.com:zeroc0d3/deploy-laravel.git
  ```
* Running container jenkins
  ```
  ./run-jenkins.sh
  ```
* Access Jenkins in browser
  ```
  http://0.0.0.0:8185
  ```
* Initial Admin Password for Jenkins Master
  ```
  docker exec -it zeroc0d3lab_jenkins bash
  cat /home/jenkins/secrets/initialAdminPassword
  ```
* Create jenkins pipeline project
* Add script `Jenkinsfile` for pipeline deployment staging in "staging" folder.
* Add script `Jenkinsfile` for pipeline deployment production in "production" folder.

## Tested Environment
### Versioning
* Docker version
  ```
  Docker version 19.03.13, build 4484c46d9d
  ```
* Docker-Compose version
  ```
  docker-compose version 1.27.4, build 40524192
  ```
* Jenkins version
  ```
  Jenkins 2.249.2
  ```