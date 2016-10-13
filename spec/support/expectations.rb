RSpec.shared_examples 'response' do |status, content_type, body|
  specify { expect(response).to have_status(status) }
  specify { expect(response).to have_content_type(content_type) }
  specify { expect(response).to have_content(body) }
end

module Expectations
  def expect_response(status, content_type, body)
    include_examples 'response', status, content_type, body
  end

  def expect_not_found(content_type = 'application/json')
    include_examples 'response', 404, content_type, /RAML not found/
  end
end
