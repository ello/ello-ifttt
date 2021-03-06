Rails.application.routes.draw do
  namespace :ifttt do
    namespace :v1 do
      get 'user/info', to: 'users#show'
      get 'status', to: 'status#show'
      post 'test/setup', do: 'test#setup'
      namespace :triggers do
        post 'submitted_new_post', to: 'submitted_new_post#index'
        post 'loved_a_post', to: 'loved_a_post#index'
      end
    end
  end

  require 'sidekiq/web'
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
    end
  end
  mount Sidekiq::Web, at: 'staff/queue'
end
