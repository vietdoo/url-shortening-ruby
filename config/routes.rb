Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  root 'web/shortening#index'

  namespace :api do
    namespace :v1 do
      post "encode" => "encoding#encode", as: :encode_url
      post "decode" => "decoding#decode", as: :decode_url
    end
  end

  get "shortening-url" => "web/shortening#index", as: :shortening_url
  get "urls" => "web/urls#index"
  get "shortened-url-result" => "web/urls#result", as: :shortened_url_result
  get "/:short_code" => "web/urls#show", as: :short_url

  namespace :users do
    get 'history' => 'history#index', as: :history_urls
  end

  match '*path', to: 'application#not_found_method', via: :all
end