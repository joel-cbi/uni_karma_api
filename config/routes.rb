Rails.application.routes.draw do
  resources :histories
  resources :users
  post '/give_karma', to: 'karma#give_karma', as: 'give_karma'
  post '/show_karma', to: 'karma#show_karma', as: 'show_karma'
  post '/show_leaderboard', to: 'karma#show_leaderboard', as: 'show_leaderboard'
  post '/show_friends', to: 'karma#show_friends', as: 'show_friends'
  post '/show_foes', to: 'karma#show_foes', as: 'show_foes'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
