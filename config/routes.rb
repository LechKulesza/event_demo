Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  root "participants#index"

  resources :participants do
    member do
      get :scan
      get :confirm
      patch :reset_confirmed  # Reset confirmed status for individual participant
      patch :reset_scan       # Reset scan status for individual participant
    end
    collection do
      get :admin
      get :scanner  # Admin page for scanning QR codes
      post :process_scan  # Process scanned QR codes
      delete :clear_all  # Clear all participants
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
