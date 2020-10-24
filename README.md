# Deploy Laravel (with Capistrano)

![license](https://img.shields.io/badge/license-Apache_2-blue)

Zero downtime deployment Laravel with Capistrano

## Prerequirements
* Ruby Environment (RBENV) or Ruby Version Manager (RVM)

* Clone this repo
  ```
  git clone git@github.com:zeroc0d3/deploy-laravel.git
  ```
* Running bundle
  ```
  cd deploy-laravel
  bundle install
  ```
* Edit Laravel source target in `config/deploy.rb`
  ```
  set :repo_url, "[YOUR_LARAVEL_REPO]"
  ```
* Edit target server environment in `config/deploy/[environment].rb`
  ```
  server '[YOUR_TARGET_SERVER]'
  ```
* Upload your shared files & folders in your server / VPS
  ```
  /data/[laravel-project]/[environment]/shared/src
  ---
  .env
  composer.json
  composer.lock
  node_modules
  package.json
  storage/debugbar
  storage/framework
  storage/logs
  vendor
  yarn.lock
  ```

* Setup number of release folder in `config/deploy.rb`
  ```
  set :keep_releases, 5    ## keep 5 release folder
  ```

## Symlink Files (Default)
```
append :linked_files, "#{fetch(:source)}/.env", "#{fetch(:source)}/composer.json", "#{fetch(:source)}/composer.lock", "#{fetch(:source)}/package.json", "#{fetch(:source)}/yarn.lock",
---
.env
composer.json
composer.lock
package.json
yarn.lock
```

## Symlink Folders (Default)
```
append :linked_dirs, "#{fetch(:source)}/vendor", "#{fetch(:source)}/node_modules", "#{fetch(:source)}/storage"
---
vendor
node_modules
storage
```

## Folder Structure
```
[laravel-project]
├── staging
│   ├── current -> /data/[laravel-project]/staging/releases/20200823134641/
│   ├── releases
│   │   ├── 20200823081119
│   │   └── 20200823134641   ## the latest symlink
│   │       ├── .env -> /data/[laravel-project]/staging/shared/src/.env
│   │       ├── composer.json -> /data/[laravel-project]/staging/shared/src/composer.json
│   │       ├── composer.lock -> /data/[laravel-project]/staging/shared/src/composer.lock
│   │       ├── vendor -> /data/[laravel-project]/staging/shared/src/vendor/
│   │       ├── node_modules -> /data/[laravel-project]/staging/shared/src/node_modules/
│   │       ├── storage -> /data/[laravel-project]/staging/shared/src/storage/
│   │       └── yarn.lock -> /data/[laravel-project]/staging/shared/src/yarn.lock
│   ├── shared
│   │   ├── log
│   │   └── src
│   │       ├── .env
│   │       ├── composer.json
│   │       ├── vendor
│   │       ├── node_modules
│   │       └── storage
│   │           ├── debugbar
│   │           ├── framework
│   │           │   ├── cache
│   │           │   ├── sessions
│   │           │   └── views
│   │           ├── logs
│   │           └── users
│   └── tmp
└── [environments]
```

## Deployment
* Staging
  ```
  cap staging deploy
  ```
* Production
  ```
  cap production deploy
  ```

## Manual Trigger
* Reload / Restart NGINX
  ```
  cap [environment] nginx:[manual_reload|manual_restart]
  ---
  cap staging nginx:manual_reload
  cap staging nginx:manual_restart
  ```
* Reload / Restart PHP-FPM (php7.4-fpm)
  ```
  cap [environment] phpfpm:[manual_reload|manual_restart]
  ---
  cap staging phpfpm:manual_reload
  cap staging phpfpm:manual_restart
  ```
* Install / Dump Autoload Composer
  ```
  cap [environment] composer:[install|dumpautoload|initialize]
  ---
  cap staging composer:install
  cap staging composer:dumpautoload
  cap staging composer:initialize      ## (will run install & dumpautoload)
  ```
* Clear View / Clear Cache Framework
  ```
  cap [environment] artisan:[clear_view|clear_cache|clear_all]
  ---
  cap staging artisan:clear_view
  cap staging artisan:clear_cache
  cap staging artisan:clear_all        ## (will run clear_view & clear_cache)
  ```
* NPM Package Dependencies
  ```
  cap [environment] npm:[install|update|cleanup|reinstall]
  ---
  cap staging npm:install
  cap staging npm:update
  cap staging npm:cleanup
  cap staging npm:reinstall            ## (will run cleanup & install)
  ```
* Yarn Package Dependencies
  ```
  cap [environment] yarn:[install|update|cleanup|reinstall]
  ---
  cap staging yarn:install
  cap staging yarn:update
  cap staging yarn:cleanup
  cap staging yarn:reinstall           ## (will run cleanup & install)
  ```

## How to Use Docker
### Running All Docker Compose
* Set environment `.env`
  ```
  cp .env.example .env
  ```
* Running script docker container
  ```
  ./run-docker.sh
  ```
* Running for container deployment only
  ```
  ./run-deploy.sh
  ```

### Running with Makefile
* Running docker compose
  ```
  make run-docker
  make run-deploy
  ```
* Stop docker compose
  ```
  make stop-docker
  make stop-deploy
  ```
* Remove docker compose
  ```
  make remove-docker
  make remove-deploy
  ```

## Cleanup Environment
* Remove all container
  ```
  docker-compose -f compose/app-compose.yml down
  --- or ---
  make remove
  ```
* Remove container deployment only
  ```
  docker-compose -f compose/app-compose-deploy.yml down
  --- or ---
  make remove-deploy
  ```

## Git Pipeline CI/CD
* GitLab Configuration Variable
  : [.gitlab-ci.yml](.gitlab-ci.yml)
  ```
  MYAPP_SSH_PRIVATE_KEY=
  MYAPP_SSH_PUBLIC_KEY=
  MYAPP_KNOWN_HOSTS=
  ```
* BitBucket Configuration Variable (base64 encode)
  : [bitbucket-pipelines.yml](bitbucket-pipelines.yml)
  ```
  MYAPP_SSH_PRIVATE_KEY=
  MYAPP_SSH_PUBLIC_KEY=
  MYAPP_KNOWN_HOSTS=
  ```
* CircleCI Configuration Variable
  : [.circleci/config.yml](.circleci/config.yml)
  ```
  MYAPP_SSH_PRIVATE_KEY=
  MYAPP_SSH_PUBLIC_KEY=
  MYAPP_KNOWN_HOSTS=
  ```
* OpenShift Configuration
  : [.openshift/action_hooks](.openshift/action_hooks)
* Trigger Pipeline CI/CD
  ```
  - Commit
    git commit -m "[messages]"

  - Merge / Checkout Branch `dev-master` for production
    git checkout dev-master
    git merge [from_branch]
    --- or ---
    git branch -D dev-master    # delete dev-master branch
    git branch dev-master

  - Merge / Checkout Branch `dev-staging` for staging
    git checkout dev-staging
    git merge [from_branch]
    --- or ---
    git branch -D dev-staging   # delete dev-staging branch
    git branch dev-staging

  - Push all branch & tags
    git push --all -u && git push --tags
  ```


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

## TODO
* [ ] Provisioning with Terraform & Terragrunt
* [ ] Deployment with Helm Chart
* [ ] Deployment with K8S
* [ ] Add K8S Playground Sample

## Properties
* Author  : **Dwi Fahni Denni (@zeroc0d3)**
* License : **Apache ver-2**