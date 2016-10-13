$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack/raml'

require_relative './support/factories'
require_relative './support/expectations'
require_relative './support/matchers'

RSpec.configure do |config|
  config.color = true
  config.include Factories
  config.extend Expectations
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
