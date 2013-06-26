# -*- encoding : utf-8 -*-
CUALimpieza::Application.routes.draw do

  get 'errors/not_found'
  get 'errors/server_error'
  get 'logs/show_since'

  namespace :limpieza do
    get 'general/index', :as => 'general'

    get 'agenda' => 'agenda#index', :as =>'agenda'
    get 'agenda/index' => 'agenda#index'
    get 'agenda/load_zone' => 'agenda#load_zone'
    #get_cleanup_request está hardcodeada en agenda.js.erb
    get 'agenda/get_cleanup_requests' => 'agenda#get_cleanup_request', :as => 'agenda_cleanup_request'
    get 'agenda/print_cleanup_requests', :as => 'print_cleanup_requests'
    get 'agenda/print_cleanup_requests_post', :as => 'print_cleanup_requests_post'
    get 'agenda/print_cleanup_requests_page', :as => 'print_cleanup_requests_page'

    post 'agenda/importar_excel' => 'agenda#import_excel', :as =>'import_excel'

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

    # Rooms view
    get 'vista_salas' => 'roomsView#index', :as =>'vista_salas'
    get 'vista_salas/index' => 'roomsView#index'

    get 'vista_salas/edit_room_status' => 'roomsView#edit_room_status' , :as => 'edit_room_status'
    put 'vista_salas/change_room_status' => 'roomsView#change_room_status' , :as => 'change_room_status'
    get 'vista_salas/edit_maintenance_room' => 'roomsView#edit_maintenance_room', :as => 'edit_maintenance_room'
    put 'vista_salas/finish_maintenance' => 'roomsView#finish_maintenance', :as => 'finish_maintenance'

    # Read-Only Rooms view
    get 'vista_salas/ver' => 'roomsView#show', :as => 'show_rooms_readonly'

    #Popups Cleanup Requests
    get 'popup_nueva_solicitud' => 'cleanup_popup#popup_cleanup_request_new', :as => 'new_cleanup_request'
    post 'crear_solicitud' => 'cleanup_popup#create', :as =>'create_cleanup_request'

    get 'popup_solicitud/:id' => 'cleanup_popup#popup_cleanup_request_show', :as => 'show_cleanup_request'
    post 'eliminar_solicitud' => 'cleanup_popup#delete', :as => 'delete_cleanup_request'
    put 'procesar_solicitud' => 'cleanup_popup#process_cleanup_request', :as => 'process_cleanup_request'
  end

  namespace :api do
    get 'rooms/sector/:id' => 'rooms#rooms_by_sector', :as => 'rooms_by_sector'
    get 'rooms/load_zone' => 'rooms#load_zone'
    get 'rooms/load_sector' => 'rooms#load_sector'
    resources :rooms
    get 'logs/show' => 'logs#show'
    get 'employees/:id' => 'employees#show'
    get 'employees/:id/vacations' => 'employees#employee_vacations'
  end

  namespace :personal do
    # Employees_Controller:
    get 'index' => 'employees#list', :as => 'employees_list'
    get 'nuevo_empleado' => 'employees#new', :as => 'new_employee'
    post 'crear_empleado' => 'employees#create', :as => 'create_employee'
    get 'editar_empleado/:id' => 'employees#edit', :as => 'edit_employee'
    put 'actualizar_empleado/:id' => 'employees#update', :as => 'update_employee'

    get 'historial_trabajo/:id' => 'employees#work_history', :as => 'work_history'
    get 'historial_limpieza/:id' => 'employees#cleaning_history', :as => 'cleaning_history'

    #Shifts_Controller:
    get 'turnos' => 'shifts#index', :as => 'shifts'
    get 'turnos/nuevo_turno' => 'shifts#get_new_shift', :as => 'get_new_shift'
    get 'turnos/ver_turno' => 'shifts#get_shift', :as => 'get_shift'
    post 'turnos/crear_turno' => 'shifts#create', :as => 'create_shift'
    get 'shifts/shift_form', :as => 'shift_form'
    put 'turnos/actualizar/:id' => 'shifts#update', :as => 'update_shift'

    #Assistances_Controller:
    get 'asistencias' => 'assistances#index', :as => 'assistances'
    post 'asistencia_update' => 'assistances#update', :as => 'update'

    #Vacations controller:
    get 'vacaciones' => 'vacations#index', :as => 'vacations'
    get 'vacaciones/get_events' => 'vacations#get_events'
    get 'vacaciones/new' => 'vacations#new', :as => 'new_vacation'
    post 'vacaciones/create' => 'vacations#create', :as => 'create_vacation'
    get 'vacaciones/edit/:id' => 'vacations#edit', :as => 'edit_vacation'
    put 'vacaciones/edit/:id' => 'vacations#update', :as => 'update_vacation'
  end

  namespace :administracion do
    #--------------------------usuarios------------------------------
    get 'index' => 'users#list', :as => 'users_list'
    get 'usuarios/nuevo' => 'users#new', :as => 'new_user'
    post 'usuarios/crear' => 'users#create', :as => 'create_user'
    get 'usuarios/editar/:id' => 'users#edit', :as => 'edit_user'
    put 'usuarios/actualizar/:id' => 'users#update', :as => 'update_user'
    get 'usuarios/cambio_contrasena/:id' => 'users#password_change', :as =>'password_change'
    put 'usuarios/actualizar_contrasena/:id' => 'users#password_update', :as =>'password_update'

    #--------------------------salas------------------------------
    get 'salas/lista' => 'rooms#list', :as => 'rooms_list'
    get 'salas/nuevo' => 'rooms#new', :as => 'new_room'
    post 'salas/crear' => 'rooms#create', :as => 'create_room'
    get 'salas/editar/:id' => 'rooms#edit', :as => 'edit_room'
    put 'salas/actualizar/:id' => 'rooms#update', :as => 'update_room'

    #--------------------------sectores------------------------------
    get 'sectores/lista' => 'sectors#list', :as => 'sectors_list'
    get 'sectores/nuevo' => 'sectors#new', :as => 'new_sector'
    post 'sectores/crear' => 'sectors#create', :as => 'create_sector'
    get 'sectores/editar/:id' => 'sectors#edit', :as => 'edit_sector'
    put 'sectores/actualizar/:id' => 'sectors#update', :as => 'update_sector'


  end

  get 'cambiar_contrasena' => 'home#my_password_change', :as =>'my_password_change'
  put 'actualizar_mi_contrasena' => 'home#my_password_update', :as =>'my_password_update'

  post 'home/login'  => 'home#login', :as => 'login'
  get 'home/logout'  => 'home#logout', :as => 'logout'

  #Paginas de error:
  match '/404', :to => 'errors#not_found'
  match '/422', :to => 'errors#server_error'
  match '/500', :to => 'errors#server_error'

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

  root :to => 'home#index'
end
