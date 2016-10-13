require 'spec_helper'

describe Rack::Raml do
  let(:raml) { file_fixture('api.raml') }
  let(:be_an_app) { be_a(Rack::Raml::App) }

  it 'has a version number' do
    expect(Rack::Raml::VERSION).not_to be nil
  end

  describe '.create' do
    it 'returns a new app' do
      expect(described_class.create(raml)).to be_an_app
    end
  end

  describe '.routes' do
    it 'yields an app' do
      described_class.routes(raml) do |app|
        expect(app).to be_an_app
      end
    end

    it 'returns an app' do
      expect(described_class.routes(raml) {}).to be_an_app
    end
  end
end
