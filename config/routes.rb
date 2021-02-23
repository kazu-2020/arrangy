Rails.application.routes.draw do
  namespace :api, format: 'json' do
    resources :users, only: %i[create] do
      get 'me', on: :collection
    end
    resource :sessions, only: %i[create destroy]
    get 'validations/unique', to: 'validations#unique'
  end

  get '*path', to: 'static_pages#top'
  root 'static_pages#top'
end
