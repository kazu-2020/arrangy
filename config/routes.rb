Rails.application.routes.draw do
  namespace :api, format: 'json' do
    resource :sessions, only: %i[create destory]
    get 'validations/unique', to: 'validations#unique'
  end

  get '*path', to: 'static_pages#top'
  root 'static_pages#top'
end
