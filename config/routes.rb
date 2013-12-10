BurnLevel::Application.routes.draw do
  resources :sessions

  namespace :api do
    namespace :v1 do
      resources :routines, defaults: {format: :json} do
        resources :routine_logs, defaults: {format: :json}
      end
      resources :routine_logs, defaults: {format: :json} do
        resources :exercise_logs, defaults: {format: :json}
      end
    end
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  root 'welcome#index'
end
