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

  get 'venues/:id/new/:id', :to => "venues#new", :as => "video_image"

  #resources :vouchers
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
    resource :vouchers, only: [:create]

    resources :vouchers, only: [:new] do
        get 'vouchers/:id' => 'venues#set_package', :as => 'vouchers'
    end
  end
  resource :account, :controller => :account

  get "/about" => "home#about"
  get "/become" => "home#become"
  get "/become2" => "home#become2"
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
    get   '/login'  => 'milia/sessions#new',     as: 'new_user_session'
    post  '/login'  => 'milia/sessions#create',  as: 'user_session'
    get   '/logout' => 'milia/sessions#destroy', as: 'destroy_user_session'
    get 'user_root' => 'teams#index', as: :user_root

    scope '/account' do
      # password reset
      get   '/password'        => 'milia/passwords#new',    as: 'new_user_password'
      put   '/password'        => 'milia/passwords#update', as: 'user_password'
      post  '/password'        => 'passwords#create'
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
          get 'by_user_favorites'
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
