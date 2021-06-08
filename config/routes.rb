Rails.application.routes.draw do
  root 'static_pages#top'

  namespace :api, format: 'json' do
    namespace :arrangements do
      resources :favorites, only: :index
      resources :postings, only: :index
      resources :new_postings, only: :index
    end
    resources :arrangements, only: %i[index create show update destroy] do
      resources :comments, only: %i[index create update destroy], shallow: true
      resource :likes, only: %i[create destroy]
    end
    resource :auth_user, only: %i[create show update destroy] do
      resource :password, only: :update, module: 'auth_user'
    end
    resource :contacts, only: :create
    resources :password_resets, only: %i[create update], param: :token
    resources :users, only: %i[create destroy]
    namespace  :validation do
      resource :uniqueness, only: :show, controller: 'uniqueness'
    end
    resources :oauths, only: :show, param: :provider
    namespace :oauth do
      resource :callback, only: :show
      resource :reregister, only: :create
    end
    resource :presigned_post, only: :new

    namespace :admin do
      resource :auth_user, only: %i[create show destroy]
      resources :arrangements, only: %i[index]
      resources :users, only: :index
    end
  end

  get '/arrangements/:id', to: 'crawlers#show', constraints: { user_agent: /Twitterbot\/1.0/ }

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get '*path', to: 'static_pages#top'
end
