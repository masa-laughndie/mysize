Rails.application.routes.draw do

  root 'static_pages#home'

  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/terms',   to: 'static_pages#terms'
  get '/privacy', to: 'static_pages#privacy'

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/admusrind', to: 'users#admusrind'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, param: :mysize_id,
                    only: [:show, :destroy],
                    path: '/' do
    member do
      get :following,
          :followers
    end
  end

  resource :settings, only: [] do
    get   '/option',   to: 'settings#option'
    get   '/account',  to: 'settings#account'
    get   '/profile',  to: 'settings#profile'
    patch '/profile',  to: 'settings#profile_update'
    put   '/profile',  to: 'settings#profile_update'
    get   '/email',    to: 'settings#email'
    patch '/email',    to: 'settings#email_update'
    put   '/email',    to: 'settings#email_update'
    get   '/mysizeid', to: 'settings#mysizeid'
    patch '/mysizeid', to: 'settings#mysizeid_update'
    put   '/mysizeid', to: 'settings#mysizeid_update'
    get   '/password', to: 'settings#password'
    patch '/password', to: 'settings#password_update'
    put   '/password', to: 'settings#password_update'
    get   '/leave',    to: 'settings#leave'
    delete '/leave',   to: 'settings#destroy'
  end



end
