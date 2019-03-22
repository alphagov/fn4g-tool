Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #resources :assessments, only: %i[index new edit update]
  #resources :sections, only: %i[index new edit update]
  resources :assessments, only: %i[index new edit update] do
    resources :sections, only: %i[index new edit update]
  end

  get '/' => redirect('/assessments')
  get '/openvas' => 'assessments#openvas'
  get '/assessments/:id/summary', to: 'assessments#summary', as: :assessment_summary
end
