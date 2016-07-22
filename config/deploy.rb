# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'labeling'
set :repo_url, 'git@github.com:gerwin-opexa/labeling.git'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

set :ssh_options, {:forward_agent => true}

set :deploy_via, :remote_cache

set :stage, :production


#set :rbenv_map_bins, fetch(:rbenv_map_bins).to_a.concat(%w(rake gem bundle ruby rails sidekiq sidekiqctl))
# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :bundle_path, ->{}
set :bundle_without, %w{development test}.join(' ')             # this is default
set :bundle_flags, ''                       # this is default
set :bundle_env_variables, {}

set :sidekiq_queue , ['default,1', 'mailer,1']
set :sidekiq_concurrency, 2



namespace :deploy do

  task :fix_absent_manifest_bug do
    on roles(:web) do
      within release_path do  execute :touch,
                                      release_path.join('public', fetch(:assets_prefix), 'manifest-fix.temp')
      end
    end
  end
  # desc "Update the crontab file"
  # task :update_crontab  do
  #   run "cd #{release_path} && whenever --update-crontab #{application}"
  # end
  after :updating, 'deploy:fix_absent_manifest_bug'
  # after :updating, 'deploy:sitemap:refresh'

  #after :publishing, 'service:nginx:restart'
  #after :publishing, 'service:unicorn:restart'

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end


end