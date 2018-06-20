Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "pages#home"
  
  get '/signup', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, except: [:new] do 
    collection do 
      post :forgot_password
      get :forgot_password
      get :edit_password_reset
      post :edit_password_reset
    end
  end

  post 'addcart', to: 'carts#addcart'
  post 'changecart', to: 'carts#changecart'
  get 'cart', to: 'carts#cart'
  delete 'deletecart', to: 'carts#deletecart'

  resources :payments, only: [:new, :index, :create, :show] do 
    collection do 
      get :success
      post :is_items
      get :details
    end
  end

  resources :products, except: [:new]
  
  resources :categories, except: [:new]
end
