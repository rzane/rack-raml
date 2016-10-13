require 'rack/raml'
require 'action_controller/railtie'

Rails.logger = Logger.new(STDOUT)

class App < Rails::Application
  config.secret_key_base = '123456789'
  config.raml_file = File.expand_path('../../spec/fixtures/api.raml', __FILE__)
end

class PagesController < ActionController::Base
  def index
    render text: 'This is the Rails demo'
  end
end

App.routes.draw do
  Rack::Raml.routes(App.config.raml_file) do |raml_app|
    get '/api/v1/users/:id', to: raml_app
  end

  root to: 'pages#index'
end

Rack::Server.start app: App
