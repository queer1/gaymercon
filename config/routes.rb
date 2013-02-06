Gc2::Application.routes.draw do
  
  resources :messages
  
  resources :groups do
    resources :posts, :controller => "group_posts" do
      resources :comments, :controller => "group_comments" do
        post :like, :on => :member
        post :unlike, :on => :member
      end
      post :like, :on => :member
      post :unlike, :on => :member
    end
    resources :comments, :controller => "gorup_comments"
    get :forums, :on => :collection
    get :games, :on => :collection
    get :events, :on => :collection
    get :users, :on => :member
    post :join, :on => :member
    post :leave, :on => :member
  end
  
  match "/groups/:id/:post_kind" => "groups#show", as: 'group_discussions'
  match "/groups/:id/:post_kind/:post_id" => "groups#show", as: 'group_discussions'
  match "/groups/:id/:post_kind/:post_id/:responses" => "groups#show", as: 'group_discussions'
  
  devise_for :users, controllers: { registrations: "users", :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "users/sessions", :passwords => "users/passwords" }
  
  devise_scope :user do
    get "/signup", to: "users#new", as: 'signup'
    get "/login", to: "devise/sessions#new", as: 'login'
    get '/logout', to: "devise/sessions#destroy", as: 'logout'
    get '/map', to: "users#map", as: 'users_map'
    get "/users/get_location", to: "users#get_location", as: 'get_location'
    match "users/notifications", to: "users#notifications", as: 'notifications'
    get '/home', to: "welcome#home", as: "home"
    get "find_by_name", to: "users#find_by_name", as: "find_by_name"
    post "/users/add_tags", to: "users#add_tags", as: 'add_tags'
    put "/users/update_profile", to: "users#update_profile", as: "update_profile"
    put "/users/update_games", to: "users#update_games", as: "update_games"
    put "/users/update_nicknames", to: "users#update_nicknames", as: "update_nicknames"
    delete "/users/auth/:id/delete", to: "users/omniauth_callbacks#disconnect", as: "disconnect_profile"
    post "/users/:id/follow", to: "users#follow", as: "follow"
    post "/users/:id/unfollow", to: "users#unfollow", as: "unfollow"
    match "/join" => "users#join", as: "join"
    match "/joined" => "users#joined", as: "joined"
    match "users/:id" => "users#show", as: "user"
    match "users" => "users#index", as: "users"
  end
  
  resources :panels do
    post "/upvote", to: "panels#upvote", as: "upvote"
    post "/downvote", to: "panels#downvote", as: "downvote"
  end
  
  resources :badges do
    get "new_code", on: :collection
    get "register", on: :collection
    post "register", on: :collection
    get "purchase", on: :collection
    post "buy", on: :collection
  end
  
  namespace :admin do
    resources :jobs
    resources :panels
    resources :mail_batches do
      post "transmit"
      post "clear_unsent"
    end
    resources :donators, only: [:index, :show]
    resources :badges do
      get "mass_new", to: "badges#mass_new", on: :collection
      post "mass_create", to: "badges#mass_create", on: :collection
      get "export", to: "badges#export", on: :collection
    end
    match "/" => "admin/halo#index"
  end

  match '/badge/new', :to => "badges#new"
  match "/admin/:action(/:id)" => "admin/halo", as: "halo"
  match "/pages/*id" => 'pages#show', :as => :page, :format => false
  match "info/:action" => 'welcome', as: "welcome"
  match "/search" => "welcome#search", as: "search"
  match "/typeahead" => "welcome#typeahead", as: "typeahead"
  root :to => 'welcome#index'
end
