Rails.application.routes.draw do

  root 'static_pages#home'

  get '/latest',  to: 'static_pages#latest'
  get '/follow',  to: 'static_pages#follow'
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/terms',   to: 'static_pages#terms'
  get '/privacy', to: 'static_pages#privacy'

  get  '/signup',   to: 'users#new'
  post '/signup',   to: 'users#create'
  get '/admusrind', to: 'users#admusrind'
  get '/index',     to: 'users#index'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/auth/:provider/callback', to: 'sessions#omniauth_create'

  get   '/welcome',    to: 'settings#welcome'
  patch '/welcome',    to: 'settings#welcome_update'
  put   '/welcome',    to: 'settings#welcome_update'

  get  '/upload', to: 'kicksposts#new'
  post '/upload', to: 'kicksposts#create'

  get '/search', to: 'search#search'

  post   '/postcomments',    to: 'comments#create'
  delete '/postcomment/:id', to: 'comments#destroy',
                             as: 'postcomment'

=begin
  get  '/question', to: 'comments#new'
  post '/question', to: 'comments#create'
=end
  resource :password_reset, except: [:show, :destroy],
                            path_names: { new: '' } do
    collection do
      get :confirm
    end
  end

  resource :contact, only: [:new],
                     path_names: { new: '' } do
    collection do
      post '/confirm', to: 'contacts#sub_create'
      post '/',        to: 'contacts#create'
      get  :confirm,
           :thanks
    end
  end

  resource   :notice,     only: [:show, :create, :destroy]
  resources  :goods,      only: [:create, :destroy]
  
=begin
  resources  :comments,   only: [:index, :show],
                          path: '/talk'
=end
  
  resources :users, param: :mysize_id,
                    only: [:show, :destroy],
                    path: '/' do
    member do
      resources :kicksposts, except: [:new, :create, :index] do
        #get :gooders, on: :member
      end
      get :following,
          :followers,
          :good
    end
  end

  resources :kicksposts, :comments, only: :none do
    get :gooders, on: :member
  end

  resources :relationships, only: [:create, :destroy]

  resource :settings, only: :none do
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
