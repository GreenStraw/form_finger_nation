class OnlyAjaxRequest
  def matches?(request)
    request.xhr?
  end
end
App::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: { sessions: 'api/v1/sessions', registrations: 'registrations', omniauth_callbacks: 'api/v1/omniauth_callbacks', confirmations: 'confirmations'}, :skip => [:registrations], :path_prefix => 'api/v1'

      devise_scope :api_v1_user do
        post   '/sign_in'  => 'sessions#create'
        delete '/sign_out' => 'sessions#destroy'
        # put '/users/:id', :to => "registrations#update"
        post '/users', :to => "registrations#create"
      end

      resources :users, only: [:index, :show, :update]
      resources :sports
      resources :teams
      resources :establishments
      resources :watch_parties
    end
  end

  root to: 'home#index'
  get '*ember' => 'home#index'
end
