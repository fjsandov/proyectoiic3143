CUALimpieza::Application.routes.draw do

  namespace :limpieza do
    get "general/index", :as => 'general'

    get "agenda" => "agenda#index"
    get "agenda/index"

    get "calendario/index"
    get "calendario/create_aseo_terminal"
    get "calendario/get_events"

    get "vista_salas" => "roomsView#index"
    get "vista_salas/index" => "roomsView#index"
    get "vista_salas/load_zone" => "roomsView#load_zone"
    get "vista_salas/load_sector" => "roomsView#load_sector"

    get "popup_nueva_solicitud" => 'cleanup_popup#popup_cleanup_request_new', :as => 'new_cleanup_request'
    post "crear_solicitud" => 'cleanup_popup#create', :as =>'create_cleanup_request'

    get "popup_solicitud/:id" => 'cleanup_popup#popup_cleanup_request_show', :as => 'show_cleanup_request'
    post "eliminar_solicitud" => 'cleanup_popup#delete', :as => 'delete_cleanup_request'
    put "procesar_solicitud" => 'cleanup_popup#process_cleanup_request', :as => 'process_cleanup_request'
  end

  post "home/login"  => 'home#login', :as => 'login'
  get "home/logout"  => 'home#logout', :as => 'logout'

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
