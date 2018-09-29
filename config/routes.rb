Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :games, only: [:create, :show] do
    post :update_form
    post :next_hand
    scope module: :games do
      resources :hands, only: [:show] do
        scope module: :hands do
          resources :rounds, only: [:show] do
            post :move
            post :bet
            post :call
            post :fold
          end
        end
      end
    end
  end
  mount ActionCable.server => '/cable'
end
