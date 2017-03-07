Rails.application.routes.draw do
  resources :articles do
    resources :comments, only:[:create,:destroy,:update]
  end
  devise_for :users
  root 'articles#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
