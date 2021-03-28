Rails.application.routes.draw do
  namespace :api, format: 'json' do
    resources :users, only: %i[create] do
      get 'me', on: :collection
    end
    resource :profile, only: %i[update] do
      patch 'password', on: :member
    end
    resource :session, only: %i[create destroy]
    resources :arrangements, only: %i[index create show update destroy] do
      resources :comments, only: %i[index create update destroy], shallow: true
      get 'mine', on: :collection
    end
    get 'validations/unique', to: 'validations#unique'
  end

  get '*path', to: 'static_pages#top'
  root 'static_pages#top'
end
