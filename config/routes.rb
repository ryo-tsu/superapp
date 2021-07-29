Rails.application.routes.draw do
  root 'static_pages#home'
  get :about,         to: 'static_pages#about'
  get :use_of_terms,  to: 'static_pages#terms'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :signup,        to: 'users#new'
  resources :users
end
