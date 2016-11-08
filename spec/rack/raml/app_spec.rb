require 'spec_helper'

RSpec.describe Rack::Raml::App do
  let(:raml) { file_fixture('api.raml') }
  subject(:app) { described_class.new(raml) }

  describe '#call' do
    it 'processes a Rack::Request' do
      env = double('env')
      request = build_request(:get, '/')

      expect(Rack::Request).to receive(:new).with(env).and_return(request)
      expect(app).to receive(:process).with(request)

      app.call(env)
    end
  end

  describe '#process' do
    subject(:response) { app.process(request) }

    let(:path)           { '/users/1' }
    let(:params)         { {} }
    let(:request_method) { :get }
    let(:content_type)   { nil }

    let(:request) {
      build_request(request_method, path, params: params, content_type: content_type)
    }

    context 'with a path that matches exactly' do
      let(:path) { '/users/1' }
      expect_response 200, 'application/json', /success/
    end

    context 'with a path that is prefixed' do
      let(:path) { '/api/v1/users/1' }
      expect_response 200, 'application/json', /success/
    end

    context 'with a path with a format' do
      let(:path) { '/api/v1/users/1.json' }
      expect_response 200, 'application/json', /success/
    end

    context 'when specification is not found' do
      let(:path) { '/invalid' }
      expect_not_found
    end

    context 'with a declared resource that has no responses' do
      let(:path) { '/api/v1/users' }
      expect_not_found
    end

    describe 'content type' do
      context 'with a Content-Type header' do
        let(:content_type) { 'text/plain' }
        expect_response 200, 'text/plain', /success/
      end

      context 'with a valid _type parameter' do
        let(:params) { { _type: 'text/plain' } }
        expect_response 200, 'text/plain', /success/
      end

      context 'with an invalid _type parameter' do
        let(:params) { { _type: 'meatloaf' } }
        expect_not_found 'meatloaf'
      end
    end

    describe 'status code' do
      context 'with a valid _code parameter' do
        let(:params) { { _code: 401 } }
        expect_response 401, 'application/json', /not authorized/
      end

      context 'with an invalid _code parameter' do
        let(:params) { { _code: 400 } }
        expect_not_found
      end
    end
  end
end
