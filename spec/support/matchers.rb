RSpec::Matchers.define :have_status do |expected|
  match { |actual| actual.first == expected }

  failure_message do |actual|
    "expected status #{expected}, but got #{actual.first}"
  end
end

RSpec::Matchers.define :have_content_type do |expected|
  match { |actual| actual[1]['Content-Type'] == expected }

  failure_message do |actual|
    "expected content type #{expected}, but got #{actual[1]['Content-Type']}"
  end
end

RSpec::Matchers.define :have_content do |expected|
  match { |actual| actual.last.join('').match(expected) }

  failure_message do |actual|
    "expected HTTP body to match #{expected}, but got #{actual.last.join('')}"
  end
end
