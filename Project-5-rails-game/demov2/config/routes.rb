Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  get 'restart_session', to: 'welcome#restart_session'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
