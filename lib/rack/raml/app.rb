require 'rack/response'
require 'rack/raml/response'

module Rack
  module Raml
    class App
      attr_reader :raml_file

      def initialize(raml_file, responder: Rack::Raml::Response)
        @raml_file = raml_file
        @responder = responder
      end

      def call(env)
        process Rack::Request.new(env)
      end

      def process(request)
        response_for(request).to_rack
      end

      private

      def response_for(request)
        @responder.new(raml_file, request)
      end
    end
  end
end
