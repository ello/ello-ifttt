Rails.application.routes.draw do
  namespace :ifttt do
    namespace :v1 do
      get 'user/info', to: 'users#show'
    end
  end
end
