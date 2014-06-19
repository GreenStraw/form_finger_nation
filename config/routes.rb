Baseapp::Application.routes.draw do

  get "/terms" => "home#terms"
  get "/privacy" => "home#privacy"
  root :to => "home#index"

  # Authentication
  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations]
  as :user do
    # session handling
    get   '/login'  => 'milia/sessions#new',     as: 'new_user_session'
    post  '/login'  => 'milia/sessions#create',  as: 'user_session'
    get   '/logout' => 'milia/sessions#destroy', as: 'destroy_user_session'

    # joining
    get   '/join' => 'milia/registrations#new',    as: 'new_user_registration'
    post  '/join' => 'milia/registrations#create', as: 'user_registration'

    scope '/account' do
      # password reset
      get   '/password'        => 'milia/passwords#new',    as: 'new_user_password'
      put   '/password'        => 'milia/passwords#update', as: 'user_password'
      post  '/password'        => 'milia/passwords#create'
      get   '/password/change' => 'milia/passwords#edit',   as: 'edit_user_password'

      # confirmation
      get   '/confirm'        => 'milia/confirmations#show',   as: 'user_confirmation'
      get   '/confirm/resend' => 'milia/confirmations#new',    as: 'new_user_confirmation'
      post  '/confirm'        => 'milia/confirmations#create'
      put   '/confirm'        => 'confirmations#update', as: 'update_user_confirmation'
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      devise_for :users, controllers: { sessions: 'api/v1/sessions', confirmations: 'confirmations'}, :path_prefix => 'api/v1'

      devise_scope :api_v1_user do
        post   '/sign_in'  => 'sessions#create'
        delete '/sign_out' => 'sessions#destroy'
      end

      resources :users, only: [:index, :show, :update, :create] do
        collection do
          get 'search_users'
        end
      end
      resources :sports do
        put 'subscribe_user'
        put 'unsubscribe_user'
      end
      resources :teams do
        put 'subscribe_user'
        put 'unsubscribe_user'
        member do
          put 'add_host'
          put 'remove_host'
        end
      end
      resources :venues
      resources :parties do
        post 'invite', on: :collection
        member do
          put 'rsvp'
          put 'unrsvp'
        end
      end
      resources :packages
      resources :charges, only: [:new, :create]
      resources :comments, only: [:index, :show, :create, :update]
      resources :addresses, only: [:create, :show, :update]
      resources :party_invitations, only: [:index, :show] do
        put 'accept', on: :member
      end
    end
  end

  get '*ember' => 'home#index'

end
