SourcemodTranslator::Application.routes.draw do
  resources :translations

  get 'languages', to: 'languages#index', as: 'languages'
  get 'languages/add/:language_id', to: 'languages#add', as: 'add_language'
  get 'languages/remove/:language_id', to: 'languages#remove', as: 'remove_language'

  resources :phrases do
    get 'translate', :action => :translate, :on => :member
    post 'translate', :action => :translate_submit, :on => :member

    resources :translations, only: [:new]
  end

  resources :sourcemod_plugins do

    get 'upload', :action => :upload, :on => :member
    post 'upload', :action => :upload_submit, :on => :member
  end

  post 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  root :to => 'pages#index'
end
