Baseapp::Application.routes.draw do

  get 'account' => "account#show", :as => 'account'
  get 'account/edit' => 'account#edit', :as => 'edit_account'
  post 'account/update' => 'account#update', :as => 'update_account'
  post 'account/create' => 'account#create', :as => 'create_account'
  get 'new_account' => "account#new", :as => 'new_account'


  resources :vouchers
  resources :packages
  resources :parties
  resources :sports do
    resource :teams, only: [:new, :create]
  end
  resources :teams, except: [:new, :create] do
    member do
      put 'subscribe'
      put 'unsubscribe'
      put 'add_host'
      put 'remove_host'
      put 'add_admin'
      put 'remove_admin'
    end
  end
  resources :venues do
    member do
      put 'add_manager'
      put 'remove_manager'
    end
  end
  resource :account, :controller => :account

  get "/about" => "home#about"
  get "/contact" => "home#contact"
  get "/faq" => "home#faq"
  get "/home" => "home#home"
  get "/how" => "home#how"
  get "/jobs" => "home#jobs"
  get "/privacy" => "home#privacy"
  get "/terms" => "home#terms"
  root :to => "home#home"



  # Authentication
  devise_for :users,  controllers: { omniauth_callbacks: 'omniauth_callbacks'}, skip: [:sessions, :passwords, :confirmations, :recoverable, :registerable]
  as :user do
    # session handling
    get   '/login'  => 'milia/sessions#new',     as: 'new_user_session'
    post  '/login'  => 'milia/sessions#create',  as: 'user_session'
    get   '/logout' => 'milia/sessions#destroy', as: 'destroy_user_session'

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
      devise_for :users, controllers: { sessions: 'api/v1/sessions', registrations: 'api/v1/registrations', confirmations: 'confirmations'}, :path_prefix => 'api/v1'

      devise_scope :api_v1_user do
        post   '/sign_in'  => 'sessions#create'
        delete '/sign_out' => 'sessions#destroy'
        post '/users' => 'registrations#create'
      end

      resources :users, only: [:index, :show, :update] do
        collection do
          get 'search_users'
        end
        member do
          put 'follow_user'
          put 'unfollow_user'
        end
      end
      resources :endorsement_requests, only: [:index, :show, :update, :create]
      resources :sports do
        member do
          put 'subscribe_user'
          put 'unsubscribe_user'
        end
      end
      resources :teams do
        member do
          put 'subscribe_user'
          put 'unsubscribe_user'
          put 'add_host'
          put 'remove_host'
          put 'add_admin'
          put 'remove_admin'
        end
      end
      resources :venues do
        member do
          get 'packages'
          put 'add_manager'
          put 'remove_manager'
        end
      end
      resources :parties do
        collection do
          get 'search'
          get 'by_attendee'
          get 'by_organizer'
        end
        member do
          put 'add_package'
          put 'remove_package'
          put 'rsvp'
          put 'unrsvp'
          post 'invite'
        end
      end
      resources :vouchers, only: [:index, :show, :create, :update] do
        collection do
          get 'by_user'
        end
        member do
          put 'redeem'
        end
      end
      resources :uploads, only: [:index] do
      end
      resources :packages
      resources :comments, only: [:index, :show, :create, :update]
      resources :addresses, only: [:index, :create, :show, :update]
      resources :party_invitations, only: [:index, :show] do
        put 'accept', on: :member
      end
    end
  end

  get '*ember' => 'home#index'

end
