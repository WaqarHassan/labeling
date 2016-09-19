# Route prefixes use a single letter to allow for vanity urls of two or more characters
Rails.application.routes.draw do
  
  resources :l2s

  resources :rework_infos
  resources :archives
  resources :notes
  resources :l3s 
  resources :holidays
  resources :l1s
  if defined? Sidekiq
    require 'sidekiq/web'
    authenticate :user, lambda {|u| u.is_admin? } do
      mount Sidekiq::Web, at: '/admin/sidekiq/jobs', as: :sidekiq
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

  get '/l2s/new(/:l1_id)(.:format)' => 'l2s#new', as: 'add_new_l2'
  get '/l3s/new(/:l2_id)' => 'l3s#new', as: 'add_new_l3'

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

  get '/overview/open_info_modal_l1/:l1_id' => 'overview#open_info_modal_l1', as: 'open_info_modal_l1'
  
  get '/overview/open_info_modal_l2/:l2_id' => 'overview#open_info_modal_l2', as: 'open_info_modal_l2'

  get '/overview/open_info_modal_l3/:l3_id' => 'overview#open_info_modal_l3', as: 'open_info_modal_l3'
  
  get '/overview/open_rework_modal(/:wf_step_id)(/:l2_id)' => 'overview#open_rework_modal', as: 'open_rework_modal'
  get '/overview/open_confirm_modal(/:wf_step_id)' => 'overview#open_confirm_modal', as: 'open_confirm_modal'
  get '/overview/open_modal4' => 'overview#open_modal4', as: 'open_modal4'
  get '/overview/add_project_modal' => 'overview#add_project_modal', as: 'add_project_modal' 
  get '/overview/add_ecr_modal/:id' => 'overview#add_ecr_modal', as: 'add_ecr_modal'
  get '/overview/add_ia_list_modal' => 'overview#add_ia_list_modal', as: 'add_ia_list_modal'

  #get '/overview/l1_status_popup/:id' => 'overview#l1_status_popup', as: 'l1_status_popup'

  get '/overview/update_workflow_status/:workflow_id' => 'overview#update_workflow_status', as: 'update_workflow_status'
  get '/overview/project_deatils_l1/:l1_id' => 'overview#project_deatils_l1', as: 'project_deatils_l1'
  get '/overview/project_deatils_l2/:l2_id' => 'overview#project_deatils_l2', as: 'project_deatils_l2'
  get '/overview/project_deatils_l3/:l3_id' => 'overview#project_deatils_l3', as: 'project_deatils_l3'
  get '/overview/clear_search' => 'overview#clear_search', as: 'clear_search'
  get '/overview/show_all_db' => 'overview#show_all_db', as: 'show_all_db' 
  post '/overview/add_additional_info' => 'overview#add_additional_info', as: 'add_additional_info'
  get '/overview/reject_reason_modal/:id' => 'overview#reject_reason_modal', as: 'reject_reason_modal'
  post '/overview/save_reject_reason' => 'overview#save_reject_reason', as: 'save_reject_reason'
  get '/overview/get_steps' => 'overview#get_steps', as: 'get_steps'
  get '/overview/get_reasons/:l_type' => 'overview#get_reasons', as:'get_reasons'
  get '/overview/update_workflow/:object_type/:object_id' => 'overview#update_workflow', as: 'update_workflow'
  post '/overview/workflow_update' => 'overview#workflow_update', as: 'workflow_update'
  get '/overview/merge_back/:wls_id' => 'overview#merge_back', as:'merge_back'

 
  post '/overview/update_task_confirmation' =>  'overview#update_task_confirmation', as: 'update_task_confirmation'
  post '/overview/create_rework_info' => 'overview#create_rework_info', as: 'create_rework_info'
  
  get '/overview' => 'overview#index', as: 'overview_home'
  post '/overview/search' => 'overview#search' , as: 'overview_search' 
  get '/overview/eta_refresh/:l1_id' => 'overview#eta_refresh', as:'eta_refresh'


  # Dummy preview pages for testing.
  get '/p/test' => 'pages#test', as: 'test'
  get '/p/email' => 'pages#email' if ENV['ALLOW_EMAIL_PREVIEW'].present?

  get 'robots.:format' => 'robots#index'

  root 'overview#index'
end
