require 'sinatra'
require 'rack/raml'

raml_file = File.expand_path('../../spec/fixtures/api.raml', __FILE__)
raml_app = Rack::Raml.create(raml_file)

get '/' do
  'This is a Sinatra demo'
end

get '/api/v1/users/:id' do
  raml_app.process(request)
end
