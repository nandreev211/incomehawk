Bacon::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :registrations => "registrations" }
  devise_scope :user do
    get "login", to: "devise/sessions#new", as: :login
    get "logout", to: "devise/sessions#destroy", as: :logout
  end

  match '/organizations/check_url' => 'organizations#check_url'
  match '/organizations/switch_month' => 'organizations#switch_month'
  match '/account' => 'users#edit'
  match '/upload' => 'organizations#upload'
  match '/welcome' => 'organizations#welcome'
  match '/organizations/:id/delete_demo_projects' => 'organizations#delete_demo_projects', as: :delete_demo_projects
  match '/users/:id/delete_account' => 'users#delete_account', as: :delete_account

  resource :user, only: [:edit] do
    collection do
      put 'update'
    end
  end

  resources :plans

  resources :organizations, :except => [:index] do
    get "search" => 'organizations#search', :on => :member
    # post :upload, :on => :member
    get ":year/:month" => "organizations#show", constraints: {
        year:       /\d{4}/,
        month:      /\d{1,2}/
    }
  end
  # resources :organizations, :except => [:index] do
  resources :projects do
    post :update_status
    resources :payments, :only => :create
    resources :notes, :only => [:create, :destroy, :update]
    resources :project_contacts
  end
  resources :contacts do
    post :filter, :on => :collection
    get :hover, :on => :member
  end
  resources :categories do
    post :update_color, :on => :member
  end
  # end
  resources :payments
  resources :notes

  match '/api/create_user' => 'api#create_user'
  match '/api/update_user' => 'api#update_user'
  match '/api/delete_user' => 'api#delete_user'
  match '/api/users/validate' => 'api#validate_user'
  match '/api/check_url' => 'api#check_url'

  match '/feedbacks' => 'feedbacks#index'
  root :to => 'organizations#show'

  default_url_options :host => "incomehawkapp-com.herokuapp.com"
end
