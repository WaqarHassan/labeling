# config/unicorn.rb
# set path to application
app_dir = "/home/deploy"
shared_dir = "#{app_dir}/shared"
working_directory "#{app_dir}/current"


# Set unicorn options
worker_processes 2
preload_app true
timeout 2500

# Set up socket location
listen "#{shared_dir}/tmp/sockets/unicorn.sock", :backlog => 64
listen  3000 ,  :TCP_NOPUSH  =>  true

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
  # Comment out if running workers in separate processes via Procfile
  if defined? Sidekiq
    @sidekiq_pid ||= spawn("bundle exec sidekiq -C config/sidekiq.yml -e production")
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
