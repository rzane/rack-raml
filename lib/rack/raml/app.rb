require 'rack/response'
require 'rack/raml/response'

module Rack
  module Raml
    class App
      attr_reader :raml_file

      def initialize(raml_file)
        @raml_file = raml_file
      end

      def raml
        @raml ||= ::Raml.parse_file(raml_file)
      end

      def call(env)
        process Rack::Request.new(env)
      end

      def process(request)
        response_for(request).to_rack
      end

      def resources
        @resources ||= flatten_resources(raml)
      end

      private

      def response_for(request)
        Rack::Raml::Response.new(resources, request)
      end

      def flatten_resources(node)
        node.children.inject([]) do |acc, child|
          acc << child if child.kind_of?(::Raml::Resource)
          acc + flatten_resources(child)
        end
      end
    end
  end
end
