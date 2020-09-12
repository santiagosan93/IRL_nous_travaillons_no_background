Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  resources :requests, only: :create do
    member do
      get 'confirmation'
      get 'email_confirmation'
    end
  end
end
