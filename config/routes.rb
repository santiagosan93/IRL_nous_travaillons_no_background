Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  resources :requests, only: :create do
    member do
      get 'ask_for_confirmation'
      get 'email_confirmation'
    end

    resources :contracts, only: :create
  end

  resources :contracts, only: [] do
    member do
      get 'renewal_confirmation'
    end
  end

  get 'seed', to: 'tasks#seed'
  get 'contracts_mark_expired', to: 'tasks#contracts_mark_expired'
  get 'contracts_send_renewal_email', to: 'tasks#contracts_send_renewal_email'
  get 'requests_send_renewal_email', to: 'tasks#requests_send_renewal_email'
end
