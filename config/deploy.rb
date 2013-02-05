require "bundler/capistrano"
require 'fileutils'
require "coalmine/capistrano"

set :stages, %w(production staging)
set :default_stage, "production"
require 'capistrano/ext/multistage'

set :application, "gaymercon"
set :repository,  "git@github.com:agius/gaymercon.git"

set :scm, :git
set :branch, fetch(:branch, "master")
set :env, fetch(:env, "production")
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user,    'deploy'
set :group,   user
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# This is needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :unicorn_env, 'production'
require 'capistrano-unicorn'

# desc "deploy the precompiled assets"
# task :deploy_assets, :except => { :no_release => true } do
#    run_locally("RAILS_ENV=production bundle exec rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile")
#    upload("public/assets", "#{release_path}/public/assets", :via => :scp, :recursive => true)
#    asset_path = File.join(File.dirname(__FILE__), "../", "public", "assets")
#    FileUtils.rm_rf(asset_path)
# end

desc "Establishes sudo"
task :sudo_ls do
  sudo "ls"
end

namespace :deploy do
  task :restart_solr do
    run "rm -rf #{release_path}/solr/data"
    run "ln -sf #{deploy_to}/shared/solr/data #{release_path}/solr/data"
    run "ln -sf #{deploy_to}/shared/solr/pids #{release_path}/solr/pids"
    run "cd #{release_path} && bundle exec rake sunspot:solr:stop RAILS_ENV=production; true"
    sudo "killall java; true"
    run "cd #{release_path} && bundle exec rake sunspot:solr:start RAILS_ENV=production"
  end
  
  task :symlink do
    # for capistrano-unicorn -- kill path is hard-coded to look for pid here :(
    run "mkdir -p #{deploy_to}/tmp/pids && ln -s #{deploy_to}/tmp  #{release_path}/tmp"
    run "cp -r #{deploy_to}/config/* #{release_path}/config"
  end
  
  task :upload_assets do
    `bundle exec rake assets:precompile`
    `tar -czf assets.tar.gz public/assets`
    top.upload(File.join(Dir.pwd, "assets.tar.gz"), "#{release_path}/assets.tar.gz")
    run "cd #{release_path} && tar -xzf assets.tar.gz"
    `rm -rf public/assets`
    `rm -rf assets.tar.gz`
  end
  
  task :restart do
    unicorn.restart
  end
  
  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake paperclip:refresh:missing_styles"
  end
end

namespace :solr do
  task :reindex do
    run "cd #{deploy_to}/current && bundle exec rake sunspot:reindex RAILS_ENV=production"
  end
  
  task :stop do
    run "cd #{deploy_to}/current && bundle exec rake sunspot:solr:stop RAILS_ENV=production; true"
  end
  
  task :start do
    run "cd #{deploy_to}/current && bundle exec rake sunspot:solr:start RAILS_ENV=production"
  end
end

namespace :unicorn do
  task :restart do
    unicorn.stop
    sleep(2)
    unicorn.start
  end
end

before 'deploy:update', 'sudo_ls'
before 'deploy:finalize_update', 'deploy:upload_assets'
after "deploy:finalize_update", "deploy:build_missing_paperclip_styles"
after 'deploy:finalize_update', 'deploy:symlink'
after 'deploy:finalize_update', 'deploy:restart_solr'

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end