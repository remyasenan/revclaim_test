Revclaim::Application.routes.draw do
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
  # match ':controller(/:action(/:id(.:format)))'
  resources :cpt_codes
  resource :session
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/signup' => 'dashboard#signup', :as => :signup
  match '/edit' => 'remittors#update', :as => :edit
  match '/' => 'sessions#new'
  match '/sessions/eob_count' => "sessions#eob_count"
#   resources :sessions do
#    collection do
#      get :eob_count
#    end
#  end
  match '/unzipped_files/:first/:second/:filename' => 'image#show', :constraints => { :filename => /.*/ }
  namespace :admin do
    resources :remittors do
      collection do
        get :list
        get :list_processor_occupancy
        get :joblist
        get :accuracy_report
      end
    end
    resources :client do
      collection do
        get :list
      end
    end

    resources :facility do
      collection do
        get :index
        post :create
      end
    end
    
    resources :job do
      collection do
        get :user_jobs
        post :allocate_deallocate
        get :deallocate_processor
        get :deallocate_qa
        get :add_processor
        get :assign
        post :assign
        get :allocate_payer_jobs
        get :add_qa
      end
    end
    resources :download_output do
      
    end
    resources :batch do
      collection do
        get :allocate
        get :load
        post :loadFile
        get :archive_batch
        post :status_change
        get :output_batch
        get :batchlist
        post :batch_report
        get :batch_archive
        post :batchspit
        post :output_batch
      end
    end
    resources :payer do
     collection do
      get :list
     end
    end
    resources :document do
      collection do
        post :add
        get :add_view_docs
      end
    end
  end
  resources :hlsc do
    collection do
      get :batch_status
      get :unprocessed_batches
    end
  end
  resources :qa do
    collection do
      get :my_job
      get :completed_claims
    end
  end
  resources :datacaptures do
    collection do
      get :claimqa
      get :claim
      get :claim_ub04
      get :claimqa_ub04
      get :rejected_claim_ub04
      get :rejected_claim
      get :payer_informations
      get :patient_details_from_csv 
      post :auto_complete_for_payer_name
      get :billing_provider_informations_ub04
      get :provider_informations
      get :provider_organization_informations
      get :service_facility_informations
      get :payer_informations_ub04
      get :provider_informations_ub04
    end
  end
  match ':controller/service.wsdl' => '#wsdl'
  match '/:controller(/:action(/:id))'
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
