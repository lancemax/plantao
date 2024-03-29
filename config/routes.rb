Plantao::Application.routes.draw do
  

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do 
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  match 'cities/load_cities/:state' => 'cities#load_cities'
  match 'showHospitals' => 'hospitals#index', :as => :showHospitals
  
  match 'plantoesPleiteados' => 'customer/requests#index', :as => :my_requests
  match 'meusPlantoes' => 'customer/home#userJobs', :as => :my_jobs
  match 'setJobRequest' => 'customer/home#setJobRequest', :as => :setJobRequest
  match 'ComoFunciona' => 'home#howWorks#index', :as => :howWorks
  
  match 'comprar' => 'customer/packages#index', :as => :buy

  

  root :to => 'home#index'
  
  namespace :customer do
    resources :requests
    resources :packages
    resources :orders
    root :to => 'home#index'

  end


  namespace :admin do
    root :to => 'home#index'
    resources :users
    resources :orders
    resources :packages
    resources :status_requests
    resources :shifts
    resources :jobs
    resources :states
    resources :cities
    resources :requests
    resources :status_orders

  end


  localized do
    resources :jobs
    resources :hospitals
    resources :cities
    resources :states
    resources :requests
    resources :packages
    resources :orders
    resources :users
    resources :shifts
  end

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

Plantao::Application.routes.translate_from_file
# You may pass the file path as a param here,
# default is config/i18n-routes.yml