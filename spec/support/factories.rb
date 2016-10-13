module Factories
  def file_fixture(filename)
    Pathname.new(File.expand_path('../../fixtures', __FILE__)).join(filename)
  end

  def build_request(verb, path, params: {}, content_type: nil)
    instance_double Rack::Request, {
      env: { 'PATH_INFO' => path },
      params: params.stringify_keys,
      request_method: verb.to_s.upcase,
      content_type: content_type
    }
  end
end
