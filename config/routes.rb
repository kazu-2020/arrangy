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
    resources :users, only: :create
    # 保留
    get 'validations/unique', to: 'validations#unique'
  end

  get '*path', to: 'static_pages#top'
  root 'static_pages#top'
end
