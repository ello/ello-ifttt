Rails.application.routes.draw do
  namespace :ifttt do
    namespace :v1 do
      get 'user/info', to: 'users#show'
      namespace :triggers do
        post 'submitted_new_post', to: 'submitted_new_post#index'
        post 'loved_a_post', to: 'loved_a_post#index'
      end
    end
  end
end
