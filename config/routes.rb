Rails.application.routes.draw do
  get 'sessions/new'
  root 'staticpages#home'
  get '/help', to: 'staticpages#help'
  get '/about', to: 'staticpages#about'
  get '/contact', to: 'staticpages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do #member=/users/:id ... => ブロックには...が入る
      get :following, :followers #/users/:id/following(followers)をgetすると同じ名前のアクションが動く
    end
  end
  resources :account_activations, only: :edit
  resources :password_resets, only: [:index, :new,:create,:edit,:update]
  resources :microposts, only:[:index,:create, :destroy]
  resources :relationships, only:[:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
