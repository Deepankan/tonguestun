Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'
  match '/sign_up' => 'pages#sign_up', as: :sign_up, via: [:get, :post]
  match '/sign_in' => 'pages#sign_in', as: :sign_in, via: [:get, :post]
  get '/sign_out' => 'pages#sign_out', as: :sign_out
  get '/dashboard' => 'pages#dashboard'
  post '/submit_patient', to: 'pages#submit_patient', as: :submit_patient
  post '/submit_doctor', to: 'pages#submit_doctor', as: :submit_doctor
  post '/submit_appointment', to: 'pages#submit_appointment', as: :submit_appointment
end
