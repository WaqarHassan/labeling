# Route prefixes use a single letter to allow for vanity urls of two or more characters
Rails.application.routes.draw do
  
  resources :ia_lists

  get '/ia_lists/new(/:project_id)(.:format)' => 'ia_lists#new', as: 'add_new_ia_list'


  resources :rework_infos
  resources :archives
  resources :notes
  resources :stations
  resources :ecrs
  resources :holidays
  resources :projects
  if defined? Sidekiq
    require 'sidekiq/web'
    authenticate :user, lambda {|u| u.is_admin? } do
      mount Sidekiq::Web, at: '/admin/sidekiq/jobs', as: :sidekiq
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

  get '/ecrs/new(/:ia_list_id)' => 'ecrs#new', as: 'add_new_ecr'

  # Static pages
  match '/error' => 'pages#error', via: [:get, :post], as: 'error_page'
  get '/terms' => 'pages#terms', as: 'terms'
  get '/privacy' => 'pages#privacy', as: 'privacy'

  # OAuth
  oauth_prefix = Rails.application.config.auth.omniauth.path_prefix
  get "#{oauth_prefix}/:provider/callback" => 'users/oauth#create'
  get "#{oauth_prefix}/failure" => 'users/oauth#failure'
  get "#{oauth_prefix}/:provider" => 'users/oauth#passthru', as: 'provider_auth'
  get oauth_prefix => redirect("#{oauth_prefix}/login")

  # Devise
  devise_prefix = Rails.application.config.auth.devise.path_prefix
  devise_for :users, path: devise_prefix,
    controllers: {registrations: 'users/registrations', sessions: 'users/sessions',
      passwords: 'users/passwords', confirmations: 'users/confirmations', unlocks: 'users/unlocks'},
    path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  devise_scope :user do
    get "#{devise_prefix}/after" => 'users/registrations#after_auth', as: 'user_root'
  end
  get devise_prefix => redirect('/a/signup')

  # User
  resources :users, path: 'u', only: :show do
    resources :authentications, path: 'accounts'
  end

  get '/main/open_info_modal/:ia_list_id' => 'main#open_info_modal', as: 'open_info_modal'
  get '/main/open_info_modal_ecr/:ecr_id' => 'main#open_info_modal_ecr', as: 'open_info_modal_ecr'
  
  get '/main/open_rework_modal' => 'main#open_rework_modal', as: 'open_rework_modal'
  get '/main/open_confirm_modal' => 'main#open_confirm_modal', as: 'open_confirm_modal'
  get '/main/open_modal4' => 'main#open_modal4', as: 'open_modal4'
  get '/main/add_project_modal' => 'main#add_project_modal', as: 'add_project_modal' 
  get '/main/add_ecr_modal/:id' => 'main#add_ecr_modal', as: 'add_ecr_modal'
  get '/main/add_ia_list_modal' => 'main#add_ia_list_modal', as: 'add_ia_list_modal'
  get '/main/project_status_popup/:id' => 'main#project_status_popup', as: 'project_status_popup'
  
  
  #what we write after 'as' keyword becomes path
 
  resources :main
  get '/main' => 'main#index', as: 'main_home'

  # Dummy preview pages for testing.
  get '/p/test' => 'pages#test', as: 'test'
  get '/p/email' => 'pages#email' if ENV['ALLOW_EMAIL_PREVIEW'].present?

  get 'robots.:format' => 'robots#index'

  root 'main#index'
end
