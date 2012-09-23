require "bundler/capistrano"
require 'fileutils'

set :application, "gaymercon"
set :repository,  "git@github.com:agius/gaymercon.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user,    'deploy'
set :group,   user
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

role :web, "gibson.gaymercon.org"                          # Your HTTP server, Apache/etc
role :app, "gibson.gaymercon.org"                          # This may be the same as your `Web` server
role :db,  "gibson.gaymercon.org", :primary => true # This is where Rails migrations will run

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
  task :symlink do
    # for capistrano-unicorn -- kill path is hard-coded to look for pid here :(
    run "mkdir -p #{deploy_to}/tmp/pids && ln -s #{deploy_to}/tmp  #{release_path}/tmp"
    run "cp -r #{deploy_to}/config/* #{release_path}/config"
  end
  
  task :restart do
    unicorn.restart
  end
  
  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake paperclip:refresh:missing_styles"
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
# before 'deploy:finalize_update', 'deploy_assets'
after "deploy:update_code", "deploy:build_missing_paperclip_styles"
after 'deploy:finalize_update', 'deploy:symlink'

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end