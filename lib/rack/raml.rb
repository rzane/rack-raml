require 'raml'
require 'rack/raml/version'
require 'rack/raml/app'
require 'rack/raml/response'

module Rack
  module Raml
    def self.create(file)
      Rack::Raml::App.new(file)
    end

    def self.routes(file, &block)
      create(file).tap(&block)
    end
  end
end
