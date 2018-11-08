Rails.application.routes.draw do
  resources :histories
  resources :users
  post '/give_karma', to: 'karma#give_karma', as: 'give_karma'
  get '/show_karma', to: 'karma#show_karma', as: 'show_karma'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
