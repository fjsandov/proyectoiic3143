CUALimpieza::Application.routes.draw do

  get "logs/show_since"

  namespace :limpieza do
    get 'general/index', :as => 'general'

    get 'agenda' => 'agenda#index', :as =>'agenda'
    get 'agenda/index' => 'agenda#index'
    get 'agenda/load_zone' => 'agenda#load_zone'
    get 'agenda/print_cleanup_requests', :as => 'print_cleanup_requests'
    get 'agenda/print_cleanup_requests_page', :as => 'print_cleanup_requests_page'

    get 'calendario/index', :as =>'calendario'
    get 'calendario/get_events'
    # terminal cleanup
    get 'calendario/new', :as => 'new_terminal_cleanup'
    post 'calendario/create', :as => 'create_terminal_cleanup'
    get 'calendario/edit', :as => 'edit_terminal_cleanup'
    put 'calendario/update', :as => 'update_terminal_cleanup'
    delete 'calendario/destroy', :as => 'delete_terminal_cleanup'
    # terminal cleanup instance
    get 'calendario/new_tc_instance', :as => 'new_tc_instance'
    post 'calendario/create_tc_instance', :as => 'create_tc_instance'
    get 'calendario/edit_tc_instance', :as => 'edit_tc_instance'
    put 'calendario/update_tc_instance', :as => 'update_tc_instance'

    get 'vista_salas' => 'roomsView#index', :as =>'vista_salas'
    get 'vista_salas/index' => 'roomsView#index'
    get 'vista_salas/load_zone' => 'roomsView#load_zone'
    get 'vista_salas/load_sector' => 'roomsView#load_sector'

    get 'vista_salas/edit_room_status' => 'roomsView#edit_room_status' , :as => 'edit_room_status'
    put 'vista_salas/change_room_status' => 'roomsView#change_room_status' , :as => 'change_room_status'
    get 'vista_salas/edit_maintenance_room' => 'roomsView#edit_maintenance_room', :as => 'edit_maintenance_room'
    put 'vista_salas/finish_maintenance' => 'roomsView#finish_maintenance', :as => 'finish_maintenance'

    get 'popup_nueva_solicitud' => 'cleanup_popup#popup_cleanup_request_new', :as => 'new_cleanup_request'
    post 'crear_solicitud' => 'cleanup_popup#create', :as =>'create_cleanup_request'

    get 'popup_solicitud/:id' => 'cleanup_popup#popup_cleanup_request_show', :as => 'show_cleanup_request'
    post 'eliminar_solicitud' => 'cleanup_popup#delete', :as => 'delete_cleanup_request'
    put 'procesar_solicitud' => 'cleanup_popup#process_cleanup_request', :as => 'process_cleanup_request'
  end

  namespace :api do
    resources :rooms
    get 'rooms/sector/:id' => 'rooms#rooms_by_sector', :as => 'rooms_by_sector'

    get 'logs/show' => 'logs#show'
  end

  namespace :personal do
    # Employees_Controller:
    get 'lista_empleados' => 'employees#list', :as => 'employees_list'
    get 'nuevo_empleado' => 'employees#new', :as => 'new'
    post 'crear_empleado' => 'employees#create', :as => 'create'
    get 'editar_empleado/:id' => 'employees#edit', :as => 'edit'
    put 'actualizar_empleado/:id' => 'employees#update', :as => 'update'

    #------

  end

  post 'home/login'  => 'home#login', :as => 'login'
  get 'home/logout'  => 'home#logout', :as => 'logout'

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

  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
