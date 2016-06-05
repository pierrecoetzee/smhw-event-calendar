Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'events#index'
  resources :events
  match "weekly_events", to: 'events#weekly_events', via: :get, format: :json

end
