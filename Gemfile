source 'https://rubygems.org'
ruby '2.3.7'

gem 'rails', '~> 5.0.0'
gem 'pg', '~> 0.18'
gem 'puma'

gem 'jwt'

gem 'kinesis-stream-reader', github: 'ello/kinesis-stream-reader', require: 'stream_reader'
gem 'interactor-rails', '~> 2.0'

gem 'sidekiq'
gem 'sinatra', :require => nil, github: 'sinatra/sinatra'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group 'production' do
  gem 'honeybadger'
  gem 'rails_12factor'
end
