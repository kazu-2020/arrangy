Rails.application.routes.draw do
  namespace :api, format: 'json' do
    resources :arrangements, only: %i[index create show update destroy] do
      resources :comments, only: %i[index create update destroy], shallow: true
      resource :likes, only: %i[create destroy]
      get 'mine', on: :collection
    end
    resource :profile, only: :update do
      patch 'password', on: :member
    end
    resource :session, only: %i[create destroy]
    resources :users, only: :create do
      get 'me', on: :collection
    end
    get 'validations/unique', to: 'validations#unique'
  end

  get '*path', to: 'static_pages#top'
  root 'static_pages#top'
end
