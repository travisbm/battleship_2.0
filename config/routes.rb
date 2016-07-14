Rails.application.routes.draw do

  resources :games, except: [:delete] do
    member do
      put :fire
    end
  end

  root 'games#new'
end
