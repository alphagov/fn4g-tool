Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :assessments, only: %i[index new edit update]
  resources :sections, only: %i[index edit update]
  get '/' => redirect('/assessments')
  get '/openvas' => 'assessments#openvas'
end
