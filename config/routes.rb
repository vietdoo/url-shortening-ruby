Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  root 'shortening#index'

  get "shortening-url" => "shortening#index", as: :shortening_url
  post "encode" => "encoding#encode", as: :encode_url
  post "decode" => "decoding#decode", as: :decode_url

  get "urls" => "urls#index"
  get "shortened-url-result" => "urls#result", as: :shortened_url_result
  get 'history' => 'history#index', as: :history_urls

  get "/:short_code" => "urls#show", as: :short_url
end