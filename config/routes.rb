Gc2::Application.routes.draw do
  
  resources :messages do
    get 'outbox', :on => :collection
  end
  
  resources :groups do
    resources :posts, :controller => "group_posts" do
      resources :comments, :controller => "group_comments"
    end
    get :forums, :on => :collection
    get :events, :on => :collection
    get :users, :on => :member
    post :join, :on => :member
    post :leave, :on => :member
  end
  
  match "/groups/:id/:post_kind" => "groups#show", as: 'group_discussions'
  
  devise_for :users, controllers: { registrations: "users", :omniauth_callbacks => "users/omniauth_callbacks" }
  
  devise_scope :user do
    get "/signup", to: "users#new", as: 'signup'
    get "/login", to: "devise/sessions#new", as: 'login'
    get '/logout', to: "devise/sessions#destroy", as: 'logout'
    get '/connect', to: "users#connect", as: 'connect'
    get "/users/get_location", to: "users#get_location", as: 'get_location'
    get "users/notifications", to: "users#notifications", as: 'notifications'
    post "/users/add_tags", to: "users#add_tags", as: 'add_tags'
    put "/users/update_profile", to: "users#update_profile", as: "update_profile"
    match "users/:id" => "users#show", as: "user"
    match "users" => "users#index", as: "users"
  end
  
  constraints HostGaymerconConstraint.new do
    resources :panels do
      post "/upvote", to: "panels#upvote", as: "upvote"
      post "/downvote", to: "panels#downvote", as: "downvote"
    end
    
    resources :badges do
      get "register", on: :collection
      post "register", on: :collection
    end
  end
  
  namespace :admin do
    resources :jobs
    resources :panels
    resources :badges do
      get "mass_new", to: "badges#mass_new", on: :collection
      post "mass_create", to: "badges#mass_create", on: :collection
    end
    match "/" => "admin/halo#index"
  end
  
  constraints HostGaymerconnectConstraint.new do
    root :to => 'pages#show', :id => "index"
    devise_scope :user do
      post "/users/add_tags", to: "profiles#add_tags", as: 'add_tags'
    end
  end

  match "/admin/:action(/:id)" => "admin/halo", as: "halo"
  match "/pages/*id" => 'pages#show', :as => :page, :format => false
  match "info/:action" => 'welcome', as: "welcome"
  root :to => 'welcome#index'
end
