Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :games, only: [:create, :show] do
    post :update_form
    scope module: :games do
      resources :hands, only: [:show] do
        scope module: :hands do
          resources :rounds, only: [:show] do
            post :move
          end
        end
      end
    end
  end
  mount ActionCable.server => '/cable'
end
