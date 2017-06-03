Rails.application.routes.draw do

  devise_for :congregations,  path: 'zbór', path_names: { sign_in: 'logowanie', sign_out: 'wyloguj'},
             skip: [ :registrations, :passwords, :confirmations ]


  devise_for :admins, path: 'admin',path_names: { sign_in: 'logowanie', sign_out: 'wyloguj'},
             skip: [ :registrations, :passwords, :confirmations ]

  mount ActionCable.server => '/cable'

  get '/auth/google_oauth2/callback', to: 'congregation/oauth#callback'

  namespace :congregation, path: 'zbór' do

    resources :users, path: 'bracia-siostry'
    get 'transmisja', to: 'transmission#index', as: :transmission
    post 'mute/:caller_id', to: 'mute#mute', as: :mute
    post 'unmute/:caller_id', to: 'mute#unmute', as: :unmute
    delete 'kick/:caller_id', to: 'kick#kick', as: :kick
    delete 'kick-all/:bridge_name', to: 'kick#kick_all', as: :kick_all

  end



  namespace :admin, path: 'admin' do
    root to: 'users#index'
    resources :congregations, path: 'zbory'
    resources :users, path: 'bracia-siostry'
  end

  namespace :asterisk do

    post 'sync', to: 'sync#index', as: :sync
    get  'status', to: 'sync#status', as: :status

    get 'access', to: 'access#index', as: :access

  end

  root to: 'home#index'

end