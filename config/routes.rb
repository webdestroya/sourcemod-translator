SourcemodTranslator::Application.routes.draw do
  
  resources :tags, only: [:index]
  
  resources :translations do
    get 'random', :action => :random, :on => :collection
  end

  resources :users, only: [:show, :index] do
    resources :sourcemod_plugins, only: [:index]
    resources :translations, only: [:index]
    get 'leaders', action: :leaders, on: :collection, as: :leader
  end

  get 'languages', to: 'languages#index', as: 'languages'
  get 'languages/add/:language_id', to: 'languages#add', as: 'add_language'
  get 'languages/remove/:language_id', to: 'languages#remove', as: 'remove_language'

  resources :phrases, only: [:show, :destroy] do
    get 'translate', :action => :translate, :on => :member
    post 'translate', :action => :translate_submit, :on => :member

    resources :translations, only: [:new]
  end

  resources :sourcemod_plugins do
    get 'tagged/:tags', action: :index, on: :collection, :constraints => { :tags => /[-_a-zA-Z0-9\+]+/ }, as: :tagged
    get 'download/:filename', :action => :download, :on => :member, :constraints => { :filename => /.+/ }, :as => :download
    get 'export', :action => :export, :on => :member
    get 'clean', :action => :clean, :on => :member
    get 'upload', :action => :upload, :on => :member
    post 'upload', :action => :upload_submit, :on => :member

    get 'search', action: :index, on: :collection, as: :search
  end

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  get 'auth/failure', to: redirect('/')

  get 'providers', to: 'sessions#index', as: 'providers'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get 'home', to: 'pages#home', as: 'home'
  get 'stats', to: 'pages#stats', as: 'stats'
  get 'contact', to: 'pages#contact', as: 'contact'
  get 'changelog', to: 'pages#changelog', as: 'changelog'

  scope 'metrics' do
    get '', to: 'metrics#index', as: :metrics, format: :html
    get 'update', to: 'metrics#update', as: :metrics_update, format: :json
    get 'translations', to: 'metrics#translations', as: :metrics_translations, format: :json
    get 'plugins', to: 'metrics#plugins', as: :metrics_plugins, format: :json
    get 'users', to: 'metrics#users', as: :metrics_users, format: :json
  end

  # namespace :action_cost do
  #   get '/' => 'dashboards#index'
  #   match '/ca/:ca' => 'dashboards#ca', :as => 'ca', :constraints => { :ca => /.*/ }
  # end

  root :to => 'pages#index'
end
