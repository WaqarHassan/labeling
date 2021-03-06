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

  # mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

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

  resources :reports, only: :index do
    collection do
      match 'entire-history', via: [:get, :post]

      match 'current-status', via: [:get, :post]

      match 'handoff-old', via: [:get, :post]
      match 'handoff', via: [:get, :post]

      match 'download-handoff-report-old', via: [:get, :post]
      match 'download-handoff-report', via: [:get, :post]
      
      match 'daily-activity', via: [:get, :post]
      get 'data-feed'
      get 'reject-data'
      match 'wip', via: [:get, :post]
      match 'rework-info', via: [:get, :post]
      match 'throughput-detail', via: [:get, :post]
      match 'wip-detail', via: [:get, :post]
    end
  end

  namespace :admin do
    resources :users do
      collection do
        get 'deleted-user'
      end
      member do
        get 'activate-user'
        get 'delete'
        get 'set-admin'
        get 'unset-admin'
        get 'un-lock'
      end
    end
  end  


  get '/overview/open_info_modal_l1/:l1_id(/:report_info)' => 'overview#open_info_modal_l1', as: 'open_info_modal_l1'
  
  get '/overview/open_info_modal_l2/:l2_id(/:report_info)' => 'overview#open_info_modal_l2', as: 'open_info_modal_l2'

  get '/overview/open_info_modal_l3/:l3_id(/:report_info)' => 'overview#open_info_modal_l3', as: 'open_info_modal_l3'
  
  get '/overview/open_rework_modal(/:wf_step_id)(/:l2_id)' => 'overview#open_rework_modal', as: 'open_rework_modal'
  get '/overview/open_confirm_modal(/:wf_step_id)' => 'overview#open_confirm_modal', as: 'open_confirm_modal'
  get '/overview/open_oops_modal(/:wf_step_id)' => 'overview#open_oops_modal', as: 'open_oops_modal'
  get '/overview/open_modal4' => 'overview#open_modal4', as: 'open_modal4'
  get '/overview/add_project_modal' => 'overview#add_project_modal', as: 'add_project_modal' 
  get '/overview/add_ecr_modal/:id' => 'overview#add_ecr_modal', as: 'add_ecr_modal'
  get '/overview/add_ia_list_modal' => 'overview#add_ia_list_modal', as: 'add_ia_list_modal'

  get '/overview/update_workflow_status/:workflow_id' => 'overview#update_workflow_status', as: 'update_workflow_status'
  get '/overview/project_deatils_l1/:l1_id' => 'overview#project_deatils_l1', as: 'project_deatils_l1'
  get '/overview/project_deatils_l2/:l2_id' => 'overview#project_deatils_l2', as: 'project_deatils_l2'
  get '/overview/project_deatils_l3/:l3_id' => 'overview#project_deatils_l3', as: 'project_deatils_l3'
  get '/overview/clear_search' => 'overview#clear_search', as: 'clear_search'
  post '/overview/show_all_db' => 'overview#show_all_db', as: 'show_all_db' 
  post '/overview/add_additional_info' => 'overview#add_additional_info', as: 'add_additional_info'
  get '/overview/reject_reason_modal/:id' => 'overview#reject_reason_modal', as: 'reject_reason_modal'
  post '/overview/save_reject_reason' => 'overview#save_reject_reason', as: 'save_reject_reason'
  get '/overview/get_steps' => 'overview#get_steps', as: 'get_steps'
  get '/overview/get_reasons/:l_type' => 'overview#get_reasons', as:'get_reasons'
  get '/overview/get_reasons_and_stations/:l_type' => 'overview#get_reasons_and_stations', as:'get_reasons_and_stations'
  get '/overview/update_workflow/:object_type/:object_id' => 'overview#update_workflow', as: 'update_workflow'
  post '/overview/workflow_update' => 'overview#workflow_update', as: 'workflow_update'
  get '/overview/merge_back/:wls_id' => 'overview#merge_back', as:'merge_back'
  post '/overview' => 'overview#index', as:'reports_to_overview'
  get '/overview/oops_mode' => 'overview#oops_mode', as:'oops_mode'
  get '/overview/remove_confirmation/:wf_step_id' => 'overview#remove_confirmation' , as: 'remove_confirmation'
  get '/overview/remove_manual_eta/:wf_step_id' => 'overview#remove_manual_eta' , as: 'remove_manual_eta'
 
  post '/overview/update_task_confirmation' =>  'overview#update_task_confirmation', as: 'update_task_confirmation'
  post '/overview/create_rework_info' => 'overview#create_rework_info', as: 'create_rework_info'
  
  get '/overview' => 'overview#index', as: 'overview_home'
  post '/overview/search' => 'overview#search' , as: 'overview_search' 
  get '/overview/eta_refresh/:l1_id' => 'overview#eta_refresh', as:'eta_refresh'
  get '/overview/recalculate_all_eta' => 'overview#recalculate_all_eta', as: 'recalculate_all_eta'
  get '/overview/oops_mode_reason_code' => 'overview#oops_mode_reason_code', as: 'oops_mode_reason_code'
  post '/overview/add_oops_mode_reason_code' => 'overview#add_oops_mode_reason_code', as: 'add_oops_mode_reason_code'
  get  '/overview/oops_mode_reason_code_info/:info_id/:info_type' => 'overview#oops_mode_reason_code_info', as: 'oops_mode_reason_code_info'
  #get  '/overview/oops_mode_reason_code_rework_info' => 'overview#oops_mode_reason_code_rework_info', as: 'oops_mode_reason_code_rework_info'
  post '/overview/add_oops_mode_reason_code_info' => 'overview#add_oops_mode_reason_code_info' , as: 'add_oops_mode_reason_code_info'
  get '/overview/change_rework_station' => 'overview#change_rework_station', as: 'change_rework_station'
  post '/overview/change_rework_station_form' => 'overview#change_rework_station_form', as: 'change_rework_station_form'
  get '/overview/manual_eta_modal/:wf_step_id' => 'overview#manual_eta_modal', as: 'manual_eta_modal'
  post 'overview/add_manual_eta' => 'overview#add_manual_eta', as: 'add_manual_eta'

  # Dummy preview pages for testing.
  get '/p/test' => 'pages#test', as: 'test'
  get '/p/email' => 'pages#email' if ENV['ALLOW_EMAIL_PREVIEW'].present?

  get 'robots.:format' => 'robots#index'

  root 'overview#index'
end
