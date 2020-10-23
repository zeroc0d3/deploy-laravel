# -----------------------------------------------------------------------------
#  MAKEFILE RUNNING COMMAND
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  License    : Apache version 2
# -----------------------------------------------------------------------------
# Notes:
# use [TAB] instead [SPACE]

export CI_REGISTRY     ?= hub.docker.com/
export CI_PROJECT_PATH ?= zeroc0d3lab

IMAGE          = $(CI_REGISTRY)/${CI_PROJECT_PATH}/deploy-laravel
DIR            = $(shell pwd)
VERSION       ?= 1.3.0

BASE_IMAGE     = ubuntu
BASE_VERSION   = 20.04

export PATH_WORKSPACE="src"
export PATH_COMPOSE="compose"
export PATH_DOCKER="compose/docker"
export PATH_SCRIPTS="scripts"
export PATH_SCRIPT_INSTALLER="scripts/installer"
export PROJECT_NAME="deploy-laravel"
export SSH_PRIVATE_KEY=${MYAPP_SSH_PRIVATE_KEY}
export KNOWN_HOSTS=${MYAPP_KNOWN_HOSTS}
export GIT_SYNC_URL=${MYAPP_GIT_SYNC_URL}
export GIT_SYNC_BRANCH=${MYAPP_GIT_SYNC_BRANCH}
export GIT_SYNC_TARGET_URL=${MYAPP_GIT_SYNC_TARGET_URL}

# -----------------------------------------------------------------------------
.PHONY: run stop remove build push push-container

run:
	@echo "============================================"
	@echo " Task      : Docker Container "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@./run-docker.sh
	@echo '- DONE -'

stop:
	@echo "============================================"
	@echo " Task      : Stopping Docker Container "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@docker-compose -f ${PATH_COMPOSE}/app-compose.yml stop
	@echo '- DONE -'

remove:
	@echo "============================================"
	@echo " Task      : Remove Docker Container "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@docker-compose -f ${PATH_COMPOSE}/app-compose.yml down
	@echo '- DONE -'

build:
	@echo "============================================"
	@echo " Task      : Create Docker Image "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_DOCKER} && ./docker-build.sh
	@echo '- DONE -'

push:
	@echo "============================================"
	@echo " Task      : Push Docker Image "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_DOCKER} && ./docker-push.sh
	@echo '- DONE -'

push-container:
	@echo "============================================"
	@echo " Task      : Push Docker Hub "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_DOCKER} && ./docker-build.sh
	@cd ${PATH_DOCKER} && ./docker-push.sh
	@echo '- DONE -'

# -----------------------------------------------------------------------------
# Deploy Container
# -----------------------------------------------------------------------------
.PHONY: run-deploy stop-deploy remove-deploy

run-deploy:
	@echo "============================================"
	@echo " Task      : Docker Test Container "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@./run-deploy.sh
	@echo '- DONE -'

stop-deploy:
	@echo "============================================"
	@echo " Task      : Stopping Docker Test Container "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@docker-compose -f ${PATH_COMPOSE}/app-compose-deploy.yml stop
	@echo '- DONE -'

remove-deploy:
	@echo "============================================"
	@echo " Task      : Remove Docker Test Container "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@docker-compose -f ${PATH_COMPOSE}/app-compose-deploy.yml down
	@echo '- DONE -'

# -----------------------------------------------------------------------------
.PHONY: composer-install composer-install-cicd composer-update composer-update-cicd composer-dumpautoload composer-dumpautoload composer-selfupdate

composer-install:
	@echo "============================================"
	@echo " Task      : Composer Install "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && composer install
	@echo "- DONE -"

composer-install-cicd:
	@echo "============================================"
	@echo " Task      : Composer Install CI/CD"
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && composer install --prefer-dist --no-ansi --no-interaction --no-progress --no-scripts --no-suggest
	@echo "- DONE -"

composer-update:
	@echo "============================================"
	@echo " Task      : Composer Update "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && composer update
	@echo "- DONE -"

composer-update-cicd:
	@echo "============================================"
	@echo " Task      : Composer Update CI/CD"
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && composer update --no-interaction --no-progress  --prefer-dist --optimize-autoloader --ignore-platform-reqs
	@echo "- DONE -"

composer-dumpautoload:
	@echo "============================================"
	@echo " Task      : Composer Dump Autoload "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && composer dumpautoload -o
	@echo "- DONE -"

composer-selfupdate:
	@echo "============================================"
	@echo " Task      : Composer Update "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && composer self-update
	@echo "- DONE -"

# -----------------------------------------------------------------------------
.PHONY: key-generate clear-view clear-cache clear-config clear-event clear-debug clear-all optimize fixing-cache fixing-chmod storage-symlink

key-generate:
	@echo "============================================"
	@echo " Task      : Generate Key "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan key:generate
	@echo "- DONE -"

clear-view:
	@echo "============================================"
	@echo " Task      : Clear Compiled Views "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan view:clear
	@echo "- DONE -"

clear-cache:
	@echo "============================================"
	@echo " Task      : Clear Application Cache "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan cache:clear
	@echo "- DONE -"

clear-config:
	@echo "============================================"
	@echo " Task      : Clear Configuration Cache "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan config:clear
	@echo "- DONE -"

clear-event:
	@echo "============================================"
	@echo " Task      : Clear Cached Event "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan event:clear
	@echo "- DONE -"

clear-debug:
	@echo "============================================"
	@echo " Task      : Clear Debugbar Storage "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan debug:clear
	@echo "- DONE -"

clear-all:
	@echo "============================================"
	@echo " Task      : Clear All Cache "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan view:clear
	@cd ${PATH_WORKSPACE} && php artisan cache:clear
	@cd ${PATH_WORKSPACE} && php artisan config:clear
	@cd ${PATH_WORKSPACE} && php artisan event:clear
	@cd ${PATH_WORKSPACE} && php artisan debug:clear
	@echo "- DONE -"

optimize:
	@echo "============================================"
	@echo " Task      : Optimizing Laravel "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan optimize
	@echo "- DONE -"

fixing-cache:
	@echo "============================================"
	@echo " Task      : Fixing Cache Path"
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && for i in {"sessions","views","cache"}; do mkdir -p storage/framework/$i; done
	@echo "- DONE -"

fixing-chmod:
	@echo "============================================"
	@echo " Task      : Fixing Chmod Folders"
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && chmod -R ug+rwx storage bootstrap/cache
	@echo "- DONE -"

storage-symlink:
	@echo "============================================"
	@echo " Task      : Storage Symlink"
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && chmod -R ug+rwx storage bootstrap/cache
	@echo "- DONE -"

# -----------------------------------------------------------------------------
.PHONY: run-migrate run-seed run-migrate-all run-npm run-yarn run-mix-dev run-mix-prod run-mix-watch

run-migrate:
	@echo "============================================"
	@echo " Task      : Running Artisan Migrate "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan migrate
	@echo "- DONE -"

run-seed:
	@echo "============================================"
	@echo " Task      : Running Artisan Seed "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan db:seed
	@echo "- DONE -"

run-migrate-all:
	@echo "============================================"
	@echo " Task      : Running Artisan Migrate & Seed "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan migrate:install && php artisan migrate --seed
	@echo "- DONE -"

run-npm:
	@echo "============================================"
	@echo " Task      : Running NPM Install "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && npm install
	@echo "- DONE -"

run-yarn:
	@echo "============================================"
	@echo " Task      : Running YARN Install "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && yarn install
	@echo "- DONE -"

run-mix-dev:
	@echo "============================================"
	@echo " Task      : Running Mix Develop "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && npm run dev
	@echo "- DONE -"

run-mix-prod:
	@echo "============================================"
	@echo " Task      : Running Mix Production "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && npm run production
	@echo "- DONE -"

run-mix-watch:
	@echo "============================================"
	@echo " Task      : Running Mix Watch "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && npm run watch
	@echo "- DONE -"

# -----------------------------------------------------------------------------
.PHONY: run-project prepare-ci-bitbucket prepare-ci-gitlab synchronize-staging synchronize-production

run-project:
	@echo "============================================"
	@echo " Task      : Running Project "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cd ${PATH_WORKSPACE} && php artisan serve --host=0.0.0.0 --port=8080
	@echo "- DONE -"

prepare-ci-bitbucket:
	@chmod +x scripts/*.sh
	@./${PATH_SCRIPTS}/ci-bitbucket-preparation.sh ${SSH_PRIVATE_KEY} ${KNOWN_HOSTS}

prepare-ci-gitlab:
	@chmod +x scripts/*.sh
	@./${PATH_SCRIPTS}/ci-gitlab-preparation.sh ${SSH_PRIVATE_KEY} ${KNOWN_HOSTS}

synchronize-staging:
	@echo "============================================"
	@echo " Task      : Synchronize Repo ${PROJECT_NAME} "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@chmod +x ${PATH_SCRIPTS}/*.sh
	@cp ${PATH_SCRIPTS}/*.sh /tmp
	@./tmp/ci-synchronize-repository.sh $(GIT_SYNC_URL) dev-staging $(GIT_SYNC_TARGET_URL)

synchronize-production:
	@echo "============================================"
	@echo " Task      : Synchronize Repo ${PROJECT_NAME} "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@chmod +x ${PATH_SCRIPTS}/*.sh
	@cp ${PATH_SCRIPTS}/*.sh /tmp
	@./tmp/ci-synchronize-repository.sh $(GIT_SYNC_URL) dev-master $(GIT_SYNC_TARGET_URL)

# -----------------------------------------------------------------------------
.PHONY: deploy-staging deploy-production

deploy-staging:
	@echo "============================================"
	@echo " Task      : Deploy ${PROJECT_NAME} Staging "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cap myapp-staging deploy
	@echo "- DONE -"

deploy-production:
	@echo "============================================"
	@echo " Task      : Deploy ${PROJECT_NAME} Production "
	@echo " Date/Time : `date`"
	@echo "============================================"
	@cap myapp-production deploy
	@echo "- DONE -"
