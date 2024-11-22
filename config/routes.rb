Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root 'urls#new'

  post "encode" => "urls#encode"
  post "encode" => "urls#encode", as: :encode_url

  get "shortening-url" => "urls#new"
  get "urls" => "urls#index"
  get "shortened-url-result" => "urls#result", as: :shortened_url_result

  get 'history' => 'urls#history', as: :history_urls

  get "/:short_code" => "urls#show", as: :short_url
end
