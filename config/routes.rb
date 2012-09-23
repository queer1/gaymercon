Gc2::Application.routes.draw do
  
  resources :forums do
    resources :posts
  end
  match "forums/page/:page"=> 'forums#index', as: "threads_page"
  match "forums/:id/:page"=> 'forums#show', as: "thread_page"
  
  resources :messages do
    get 'outbox', :on => :collection
  end
  
  resources :groups do
    resources :posts, :controller => "group_posts" do
      resources :comments, :controller => "group_comments"
    end
  end
  
  devise_for :users, controllers: { registrations: "users", :omniauth_callbacks => "users/omniauth_callbacks" }
  
  devise_scope :user do
    get "/signup", to: "users#new", as: 'signup'
    get "/login", to: "devise/sessions#new", as: 'login'
    get '/logout', to: "devise/sessions#destroy", as: 'logout'
    get "/users/get_location", to: "users#get_location", as: 'get_location'
    post "/users/add_tags", to: "users#add_tags", as: 'add_tags'
    put "/users/update_profile", to: "users#update_profile", as: "update_profile"
    match "users/:id" => "users#show", as: "user"
    match "users" => "users#index", as: "users", constraints: HostGaymerconnectConstraint.new
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
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
