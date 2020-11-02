# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "myapp-deploy"
set :repo_url, "git@github.com:zeroc0d3/deploy-laravel.git"

# Default branch is :master
set :branch, "dev-master"
set :source, "src"

# Default deploy_to directory is /var/www/my_app_name
set :root_path, "/var/www"
set :deploy_to, "#{fetch(:root_path)}/#{fetch(:branch)}"
set :shared_folder, "#{fetch(:deploy_to)}/shared"
set :tmp_dir, "#{fetch(:deploy_to)}/tmp"

set :src_current, "#{current_path}/#{fetch(:source)}"
set :src_release, "#{release_path}/#{fetch(:source)}"
set :current_storage, "#{fetch(:src_current)}/storage"
set :release_storage, "#{fetch(:src_release)}/storage"

set :pty, true

# Default value for :linked_files is []
append :linked_files, "#{fetch(:source)}/.env", "#{fetch(:source)}/composer.json", "#{fetch(:source)}/composer.lock", "#{fetch(:source)}/package.json", "#{fetch(:source)}/yarn.lock"

# Default value for :linked_dirs []
append :linked_dirs, "#{fetch(:source)}/vendor", "#{fetch(:source)}/node_modules", "#{fetch(:source)}/storage"

# Default value for keep_releases is 5
set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

namespace :cleanup do
  desc 'Cleanup Current'
  task :prev_current do
    on roles(:web) do
      if test("[ -d #{fetch(:deploy_to)}/current ]")
        execute "rm -rf #{fetch(:deploy_to)}/current"
      else
        info "Can't find: #{fetch(:deploy_to)}/current folder!"
      end
    end
  end

  desc 'Cleanup Release'
  task :prev_release do
    on roles(:web) do
      if test("[ -d #{fetch(:deploy_to)}/releases ]")
        execute "rm -rf #{fetch(:deploy_to)}/releases"
      else
        info "Can't find: #{fetch(:deploy_to)}/releases folder!"
      end
    end
  end

  task :all do
    on roles(:all) do
      invoke 'cleanup:prev_current'
      invoke 'cleanup:prev_release'
    end
  end
end

namespace :deploy do
  desc 'Restart Deploy'
  task :restart do
    on roles(:web) do
      if test("[ -d #{fetch(:current_storage)} ]")
        execute "chmod 777 -R #{fetch(:current_storage)}"
      else
        info "Can't find: #{fetch(:current_storage)} folder!"
      end
    end
  end
end

namespace :chown do
  desc 'Restore Ownership Folder'
  task :restore do
    on roles(:all) do
      if test("[ -d #{release_storage}]")
        execute! :sudo, "chown www-data:www-data -R #{release_storage}"
      else
        info "Can't find: #{release_storage} folder!"
      end
    end
  end

  task :change do
    on roles(:all) do
      if test("[ -d #{fetch(:current_storage)} ]")
        execute! :sudo, "chown www-data:www-data -R #{fetch(:current_storage)}"
      else
        info "Can't find: #{fetch(:current_storage)} folder!"
      end
    end
  end
end

namespace :artisan do
  desc 'Artisan Key Generate'
  task :key_generate do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan key:generate"
    end
  end

  desc 'Storage Link'
  task :storage_link do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan storage:link"
    end
  end

  desc 'Schedule Run'
  task :storage_link do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan schedule:run"
    end
  end

  desc 'Create Cached Event'
  task :cache_event do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan event:cache"
    end
  end

  desc 'Rebuild Cached Package'
  task :cache_package do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan package:discover"
    end
  end

  desc 'Create Cached Route'
  task :cache_route do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan route:cache"
    end
  end

  desc 'Create Cached View'
  task :cache_view do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan view:cache"
    end
  end

  task :build_cache do
    on roles(:all) do
      invoke 'artisan:cache_event'
      invoke 'artisan:cache_package'
      invoke 'artisan:cache_route'
      invoke 'artisan:cache_view'
    end
  end
end

namespace :nginx do
  desc 'Reload NGINX'
  task :manual_reload do
    on roles(:all) do
      sudo :service, :nginx, :reload
    end
  end

  desc 'Restart NGINX'
  task :manual_start do
    on roles(:all), in: :sequence do
      execute! :sudo, :service, :nginx, :restart
    end
  end

  task :manual_restart do
    on roles(:all) do
      invoke 'nginx:manual_reload'
      invoke 'nginx:manual_start'
    end
  end
end

namespace :phpfpm do
  desc 'Reload PHP-FPM'
  task :manual_reload do
    on roles(:all) do
      sudo :service, :'php7.4-fpm', :reload
    end
  end

  desc 'Restart PHP-FPM'
  task :manual_start do
    on roles(:all), in: :sequence do
      execute! :sudo, :service, :'php7.4-fpm', :restart
    end
  end

  task :manual_restart do
    on roles(:all) do
      invoke 'phpfpm:manual_reload'
      invoke 'phpfpm:manual_start'
    end
  end
end

namespace :composer do
  desc 'Install Composer'
  task :install do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; composer install"
    end
  end

  desc 'Self Update Composer'
  task :self_update do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; composer self-update"
    end
  end

  desc 'Update Composer'
  task :update do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; composer update"
    end
  end

  desc 'Dump Autoload Composer'
  task :dumpautoload do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; composer dump-autoload -o"
    end
  end

  task :initialize do
    on roles(:all) do
      invoke 'composer:install'
      invoke 'composer:dumpautoload'
    end
  end
end

namespace :artisan do
  desc 'Clear View'
  task :clear_view do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan view:clear"
    end
  end

  desc 'Clear Cache'
  task :clear_cache do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan cache:clear"
    end
  end

  desc 'Clear Config'
  task :clear_config do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan config:clear"
    end
  end

  desc 'Clear Debugbar'
  task :clear_debug do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan debugbar:clear"
    end
  end

  desc 'Clear Event'
  task :clear_event do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; php artisan event:clear"
    end
  end

  task :clear_all do
    on roles(:all) do
      invoke 'artisan:clear_view'
      invoke 'artisan:clear_cache'
      invoke 'artisan:clear_config'
      invoke 'artisan:clear_debug'
      # invoke 'artisan:clear_event'
    end
  end
end

namespace :npm do
  desc 'Install NPM'
  task :install do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; npm install"
    end
  end

  desc 'Update NPM'
  task :update do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; npm update"
    end
  end

  desc 'Remove Old NPM'
  task :cleanup do
    on roles(:all) do
      # execute "cd #{fetch(:src_current)}; rm -rf node_modules"
      execute "cd #{fetch(:src_current)}; rm -f package-lock.json"
    end
  end

  task :reinstall do
    on roles(:all) do
      invoke 'npm:cleanup'
      invoke 'npm:install'
    end
  end
end

namespace :yarn do
  desc 'Install Yarn'
  task :install do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; yarn install"
    end
  end

  desc 'Update Yarn'
  task :update do
    on roles(:all) do
      execute "cd #{fetch(:src_current)}; yarn update"
    end
  end

  desc 'Remove Old Yarn'
  task :cleanup do
    on roles(:all) do
      # execute "cd #{fetch(:src_current)}; rm -rf node_modules"
      execute "cd #{fetch(:src_current)}; rm -f yarn.lock"
    end
  end

  task :reinstall do
    on roles(:all) do
      invoke 'yarn:cleanup'
      invoke 'yarn:install'
    end
  end
end

### CLEANUP ###
after 'git:check', 'cleanup:all'

after 'deploy:publishing', 'deploy:restart'
# after 'deploy:restart', 'composer:initialize'
after 'deploy:restart', 'composer:dumpautoload'
after 'deploy:restart', 'artisan:clear_all'

### NPM ###
# after 'deploy:restart', 'npm:reinstall'
### YARN ###
# after 'deploy:restart', 'yarn:reinstall'

#after 'deploy:restart', 'nginx:manual_reload'

#after 'chown:restore', 'nginx:manual_reload'
#after 'chown:change', 'nginx:manual_reload'

#after 'nginx:manual_reload', 'phpfpm:manual_reload'
