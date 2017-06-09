Rails.application.routes.draw do

  devise_for :congregations,  path: 'zbór', path_names: { sign_in: 'logowanie', sign_out: 'wyloguj'},
             skip: [ :registrations, :passwords, :confirmations ]

  devise_for :admins, path: 'admin',path_names: { sign_in: 'logowanie', sign_out: 'wyloguj'},
             skip: [ :registrations, :passwords, :confirmations ]

  devise_for :users, skip: [ :registrations, :passwords, :confirmations ]


  get 'auth/:provider/callback', to: 'oauth#callback'
  get 'auth/failure', to: 'oauth#failure'

  mount ActionCable.server => '/cable'

  namespace :congregation, path: 'zbór' do
    root to: 'transmission#index'

    resources :users, path: 'bracia-siostry'
    get 'transmisja', to: 'transmission#index', as: :transmission
    get 'komentarze/:congregation_id', to: 'transmission#comments', as: :comments
    post 'mute/:caller_id', to: 'mute#mute', as: :mute
    post 'unmute/:caller_id', to: 'mute#unmute', as: :unmute
    delete 'kick/:caller_id', to: 'kick#kick', as: :kick
    delete 'kick-all/:bridge_name', to: 'kick#kick_all', as: :kick_all

    resources :broadcasts, only: [ :create, :edit, :update ]

  end

  namespace :admin, path: 'admin' do
    root to: 'congregations#index'
    resources :congregations, path: 'zbory' do
      member do
        delete :reset_stream
        delete :reset_broadcasts
        get :edit_password
        patch :update_password
      end
    end
    resources :users, path: 'bracia-siostry'
  end

  namespace :asterisk do

    post 'sync', to: 'sync#index', as: :sync
    get  'status', to: 'sync#status', as: :status

    get 'access', to: 'access#index', as: :access

  end

  namespace :public do

    root to: 'home#index'
    post 'users/counter', to: 'users#counter', as: :user_counter
    get 'transmisja', to: 'transmission#index', as: :transmission

  end

  root to: 'home#index'

end