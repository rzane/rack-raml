# Rack::Raml

A mountable mock server for your [RAML](https://raml.org) specifications based on Rack.

__Note:__ This is not intended for use in production environments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-raml'
```

## Usage

Rack::Raml implements a Rack compatible application that responds to `#call`. Therefore, it can be used with any Rack-based web framework.

#### Rails

To use with Rails, simply point specific URLs at an instance of `Rack::Raml::App` like so:

```ruby
MyApplication.routes.draw do
  # ...

  Rack::Raml.routes Rails.root.join('path/to/spec.raml') do |raml_app|
    get '/api/v1/users/:id', to: raml_app
  end
end
```

#### Sinatra

To use with Sinatra, you have a few options. The easiest way is to define your route, and invoke `#process`.

```ruby
raml_file = File.expand_path('../path/to/spec.raml', __FILE__)
raml_app = Rack::Raml.create(raml_file)

get '/api/v1/users/:id' do
  raml_app.process(request)
end
```

Otherwise, you might configure `Rack::Raml` in your `config.ru`.

#### Example RAML

```yaml
#%RAML 0.8
---
title: Dummy API
baseUri: https://dummy-api.com/api/{version}
version: v1

/users:
  /{id}:
    displayName: Find a user
    get:
      responses:
        200:
          description: User was found.
          body:
            application/json:
              example: |-
                {
                  "id": 1,
                  "first_name": "John",
                  "last_name": "Doe"
                }
```

## Status Codes

In RAML, you'll often specify multiple status codes that your server might respond with. By default, Rack::Raml will respond with the lowest status code that you've specified. So, for example, if you've declared a 200 and a 401 response, it will respond with the 200 response code unless otherwise instructed.

You can force Rack::Raml to use a specific status code by requesting the url with the `_code` query parameter. For example:

```
$ curl http://localhost:3000/api/v1/users?_code=401
```

## Content Types

The server will respond with the content type that matches the request. If the request does not specify a content type, Rack::Raml will assume you want `application/json`.

You can force Rack::Raml to use a specific content type by requesting the url with the `_type` query parameter. For example:

```
$ curl http://localhost:3000/api/v1/users?_type=text/plain
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rack-raml.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
