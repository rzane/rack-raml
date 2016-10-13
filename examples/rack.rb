require 'rack'
require 'rack/raml'

raml_file = File.expand_path('../../spec/fixtures/api.raml', __FILE__)
raml_app = Rack::Raml.create(raml_file)

app = Rack::Builder.new do
  map '/' do
    run proc { |env|
      [200, {'Content-Type' => 'text/plain'}, ['This is a Rack demo']]
    }
  end

  map '/api/v1' do
    run raml_app
  end
end

Rack::Server.start app: app
