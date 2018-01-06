Baseapp::Application.routes.draw do

  get 'accounts' => "account#index", :as => 'accounts'
  get 'account' => "account#show", :as => 'account'
  get 'account/edit' => 'account#edit', :as => 'edit_account'
  post 'account/update' => 'account#update', :as => 'update_account'
  post 'account/create' => 'account#create', :as => 'create_account'
  get 'new_account' => "account#new", :as => 'new_account'
  get 'purchase_package/:party_package_id(/:cmd)' => "parties#purchase_package", :as => 'purchase_package'
  get 'zooz_transaction/:party_package_id(/:cmd)' => "parties#zooz_transaction", :as => 'zooz_transaction'
  get 'party_rsvp/:id' => 'parties#party_rsvp', :as => 'party_rsvp'
  get 'invite_friends/:id' => 'parties#invite_friends', :as => 'invite_friends'
  post 'send_invites/:id' => 'parties#send_invites', :as => 'send_invites'
  get 'redeem_voucher/:id' => 'vouchers#redeem_voucher', :as => 'redeem_voucher'
  get 'user/:id' => 'account#user', :as => 'user'
  patch 'user/:id' => 'account#update_profile_picture', :as => 'update_profile_picture'
  put 'user/user_loc' => 'account#user_loc'
  post 'teams/:id/parties_in_area' => "teams#parties_in_area", :as => 'parties_in_area'
  post 'parties/:id/cancel_party' => 'parties#cancel_party', :as => 'cancel_party'

  resources :vouchers
  resources :packages, except: [:new, :create] do
    member do
      put 'assign'
      put 'unassign'
    end
  end
  resources :parties do
    collection do
      get 'search'
      get 'cant_find'
      get 'ajaxsearch'
      get 'get_team_parties'
      get 'get_team_rsvp_parties'
      get 'get_parties'
      get 'check_friendly_url_availablitiy'
    end
    member do
      get 'cancel_reservation'
      get 'sponsor_request'
      put 'verify'
      put 'unverify'
    end
  end
  resources :sports do
    member do
      delete 'delete_team'
    end
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
    collection do
      get 'search'
      get 'favorite_teams'
      get 'cant_find'
      get 'homesearch'
    end
  end
  resources :venues do
    member do
      put 'add_manager'
      put 'remove_manager'
      put 'verify_party'
      put 'unverify_party'
    end
    resource :packages, only: [:new, :create]

    resources :packages, except: [:new, :create] do
      member do
        put 'assign'
        put 'unassign'
      end

      resource :vouchers, only: [:new, :create]
    end
  end
  resource :account, :controller => :account

  get "/about" => "home#about"
  #get "/become" => "home#become"
  #get "/become2" => "home#become2"
  get "/myparties" => "parties#myparties"
  get "/n_sign_up" => "account#n_sign_up"
  get "/about2" => "home#about2"
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
    #admins
    get   '/index' => 'users#index',                    as: 'users'
    put   '/add_admin' => 'users#add_admin',           as: 'add_admin_user'
    put   '/remove_admin' => 'users#remove_admin',     as: 'remove_admin_user'
    # session handling
    get   '/login'  => 'devise/sessions#new',     as: 'new_user_session'
    post  '/login'  => 'devise/sessions#create',  as: 'user_session'
    get   '/logout' => 'devise/sessions#destroy', as: 'destroy_user_session'
    get 'teams' => 'teams#index', as: :user_root

    scope '/account' do
      # password reset
      get   '/password'        => 'devise/passwords#new',    as: 'new_user_password'
      put   '/password'        => 'devise/passwords#update', as: 'user_password'
      post  '/password'        => 'passwords#create'
      get   '/password/change' => 'devise/passwords#edit',   as: 'edit_user_password'

      # confirmation
      get   '/confirm'        => 'devise/confirmations#show',   as: 'user_confirmation'
      get   '/confirm/resend' => 'devise/confirmations#new',    as: 'new_user_confirmation'
      post  '/confirm'        => 'devise/confirmations#create'
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
      
      resources :teams do
        collection do
          get 'favorite_teams'
          post 'getTeamsBySport'
        end
      end
      
      resources :venues
      resources :parties
      resources :sports

    end
  end

  get '*ember' => 'home#index'

end
