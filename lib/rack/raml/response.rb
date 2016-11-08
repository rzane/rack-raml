require 'json'
require 'uri_template'

module Rack
  module Raml
    class Response
      attr_reader :resources, :request

      def initialize(resources, request)
        @resources = resources
        @request = request
      end

      def matches?
        !response.nil?
      end

      def to_rack
        if matches?
          [code, { 'Content-Type' => type }, [body]]
        else
          [404, { 'Content-Type' => type }, [not_found]]
        end
      end

      private

      def path
        request.env['PATH_INFO']
      end

      def verb
        request.request_method.downcase
      end

      def type
        request.params['_type'] || request.content_type || 'application/json'
      end

      def code
        if value = request.params['_code']
          value.to_i
        elsif possible_responses
          possible_responses.keys.min
        end
      end

      def body
        response.example if matches?
      end

      def not_found
        {
          error: 'RAML not found',
          code: code,
          type: type,
          path: path,
          verb: verb
        }.to_json
      end

      def response
        @response ||= (
          possible_responses &&
          possible_responses[code] &&
          possible_responses[code].bodies[type]
        )
      end

      def possible_responses
        @possible_responses ||= find_possible_responses
      end

      def find_possible_responses
        resource = resources.find do |res|
          pattern = uri_pattern(res.resource_path)
          res.methods[verb] && pattern.match(path)
        end

        resource.methods[verb].responses if resource
      end

      def uri_pattern(template)
        URITemplate::RFC6570.new("{/prefix*}#{template}")
      end
    end
  end
end
