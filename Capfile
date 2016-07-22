# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

#require 'capistrano/sitemap_generator'
# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
require 'rvm1/capistrano3'
require 'capistrano/bundler'
require 'capistrano3/unicorn'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
#require 'capistrano/sidekiq'
#require "whenever/capistrano"

set :services, [:nginx, :unicorn]
require 'capistrano/service'
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
