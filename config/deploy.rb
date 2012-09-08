require "bundler/capistrano"

default_run_options[:pty] = false
ssh_options[:forward_agent] = true

set :bundle_cmd, "/usr/local/bin/bundle"
set :bundle_flags, "--quiet"
set :bundle_without, [:development, :test]
set :use_sudo, false;
set :deploy_via, :remote_cache

set :application, "aswebsite"
set :repository, "git@github.com:inntran/AsiaSupermarketWebsite.git"
set :scm, :git

set :user, "ec2-user"

#after("bundle:install","deploy:dbyml")

task :production do
  set :domain , "184.73.175.56"
  role :web, domain
  role :app, domain
  role :db, domain, :primary => true
  set :deploy_to, "/srv/www/#{application}-production"
  set :branch, "master"
end

namespace :deploy do
  task :start do ; end

  task :dbyml do
    run "cd #{current_release}/config && ln -s #{deploy_to}/shared/database.yml database.yml"
    run "cd #{current_release} && rake db:create:all"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end