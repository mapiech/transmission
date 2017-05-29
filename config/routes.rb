Rails.application.routes.draw do

  devise_for :congregations,  path: 'zbór', path_names: { sign_in: 'logowanie', sign_out: 'wyloguj'},
             skip: [ :registrations, :passwords, :confirmations ]


  devise_for :admins, path: 'admin',path_names: { sign_in: 'logowanie', sign_out: 'wyloguj'},
             skip: [ :registrations, :passwords, :confirmations ]

  mount ActionCable.server => '/cable'

  namespace :congregation, path: 'zbór' do
    resources :users, path: 'bracia-siostry'
    get 'transmisja', to: 'transmission#index', as: :transmission
  end

  namespace :admin, path: 'admin' do
    root to: 'users#index'
    resources :congregations, path: 'zbory'
    resources :users, path: 'bracia-siostry'
  end

  root to: 'home#index'

end
