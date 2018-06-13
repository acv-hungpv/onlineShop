Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "pages#home"
  
  get '/signup', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, except: [:new] 

  post 'addcart', to: 'carts#addcart'
  post 'changecart', to: 'carts#changecart'
  get 'cart', to: 'carts#cart'
  delete 'deletecart', to: 'carts#deletecart'

  resources :payments, only: [:index, :create] do 
    collection do 
      get 'success'
    end
  end

  resources :products, except: [:new]
  
  resources :categories, except: [:new]
end
