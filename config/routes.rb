Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
        resources :short_urls, only: [:index, :create]
        post '/get_original_url', to: 'short_urls#show', as: 'get_original_url' 
        delete '/delete_shortend_url', to: 'short_urls#destroy', as: 'delete_shortend_url' 
    end 
  end 

  root 'welcome#index'

  

  get "/url_shortner/new" => "short_urls#index", :as => :url_shortner
  get "/url_shortner" => "short_urls#show", :as => :show_short_urls
  post "/url_shortner" => "short_urls#create", :as => :shorten_url
  get "/:random" => "short_urls#original_redirect"
end
