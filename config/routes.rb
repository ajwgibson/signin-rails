Rails.application.routes.draw do

  root 'home#index'

  get '/not_authorized', to: 'home#not_authorized'

  devise_for :users
  as :user do
    get 'users/edit' => 'devise/registrations#edit',  :as => 'edit_user_registration'
    put 'users'      => 'registrations#update',       :as => 'user_registration'
  end
  resources  :users

  get 'sign_in_records/clear_filter'
  resources  :sign_in_records

  resources  :sign_in_record_imports

end
