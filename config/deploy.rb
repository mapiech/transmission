# Change these
server '77.91.50.219', port: 2222, roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:mapiech/transmission.git'
set :application,     'transmission'
set :user,            'salat'
set :puma_threads,    [1, 4]
set :puma_workers,    4
set :puma_active_record_establish_connection, true
set :puma_init_active_record, true

# Don't change these unless you know what you're doing
set :pty,             true
set :ssh_options, paranoid: false

set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

# sidekiq
#set :sidekiq_processes, 2
#set :sidekiq_queue, [ 'default,1', 'mailers,1' ]
set :sidekiq_config, "config/sidekiq.yml"

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
set :keep_releases, 2

## Linked Files & Directories (Default None):
set :linked_files, %w{config/database.yml .env config/asterisk.yml}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :bundle_binstubs, nil

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  task :restart_asterisk_sync do
    on roles(:app) do
      execute "/home/salat/.rvm/wrappers/ruby-2.4.0/ruby #{current_path}/asterisk-sync/server-control.rb stop"
      execute "/home/salat/.rvm/wrappers/ruby-2.4.0/ruby #{current_path}/asterisk-sync/server-control.rb start"
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  after  :finishing,    :restart_asterisk_sync
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
