Rails.application.routes.draw do
  namespace :api, format: 'json' do
    namespace :arrangements do
      resources :favorites, only: :index
      resources :postings, only: :index
    end
    resources :arrangements, only: %i[index create show update destroy] do
      resources :comments, only: %i[index create update destroy], shallow: true
      resource :likes, only: %i[create destroy]
    end
    resource :auth_user, only: %i[create show update destroy] do
      resource :password, only: :update, module: 'auth_user'
    end
    resource :contacts, only: :create
    resources :users, only: :create
    namespace 'validation' do
      resource :uniqueness, only: :show, controller: 'uniqueness'
    end

    post "oauth/callback", to: "oauths#callback"
    get "oauth/callback",  to: "oauths#callback"
    get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  end


  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get '*path', to: 'static_pages#top'
  root 'static_pages#top'
end
