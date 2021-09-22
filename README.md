# AppleAuth

[![CI](https://api.travis-ci.org/rootstrap/apple_auth.svg?branch=master)](https://travis-ci.org/github/rootstrap/apple_auth)
[![Maintainability](https://api.codeclimate.com/v1/badges/78453501221a76e3806e/maintainability)](https://codeclimate.com/github/rootstrap/apple_sign_in/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/78453501221a76e3806e/test_coverage)](https://codeclimate.com/github/rootstrap/apple_sign_in/test_coverage)

## Installation

Add this line to your Gemfile:

```ruby
gem 'apple_auth'
```

And then execute:

    $ bundle install

Or install it yourself:

    $ gem install apple_auth

------------------

After installing the gem, you need to run this generator.

    $ rails g apple_auth:config

This will generate a new initializer: `apple_auth.rb` with the following default configuration:
```ruby
AppleAuth.configure do |config|
  # config.apple_client_id = <Your client_id in your Apple Developer account>
  # config.apple_private_key = <Your private key provided by Apple>
  # config.apple_key_id = <Your kid provided by Apple>
  # config.apple_team_id = <Your team id provided by Apple>
  # config.redirect_uri = <Your app redirect url>
end
```
Set your different credentials in the file by uncommenting the lines and adding your keys.

------------------

## Usage

Here's an example of how to configure the gem:

```ruby
AppleAuth.configure do |config|
  config.apple_client_id = 'com.yourapp...'
  config.apple_private_key = "-----BEGIN PRIVATE KEY-----\nMIGTAgEA....\n-----END PRIVATE KEY-----"
  config.apple_key_id = 'RTZ...'
  config.apple_team_id = 'WNU...'
  config.redirect_uri = 'https://localhost:3000'
end
```

We strongly recommend to use environment variables for these values.

Apple sign-in workflow:

![alt text](https://docs-assets.developer.apple.com/published/360d59b776/rendered2x-1592224731.png)

For more information, check the [Apple oficial documentation](https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_rest_api).

Validate JWT token and get user information:

```ruby
# with a valid JWT
user_id = '000343.1d22d2937c7a4e56806dfb802b06c430...'
valid_jwt_token = 'eyJraWQiOiI4NkQ4OEtmIiwiYWxnIjoiUlMyNTYifQ.eyJpc...'
AppleAuth::UserIdentity.new(user_id, valid_jwt_token).validate!
>>  { exp: 1595279622, email: "user@example.com", email_verified: true , ...}

# with an invalid JWT
invalid_jwt_token = 'eyJraWQiOiI4NkQsd4OEtmIiwiYWxnIjoiUlMyNTYifQ.edsyJpc...'
AppleAuth::UserIdentity.new(user_id, invalid_jwt_token).validate!
>> Traceback (most recent call last):..
>> ...
>>  AppleAuth::Conditions::JWTValidationError
```

Verify user identity and get access and refresh tokens:

```ruby
code = 'cfb77c21ecd444390a2c214cd33decdfb.0.mr...'
AppleAuth::Token.new(code).authenticate!
>> { access_token: "a7058d...", expires_at: 1595894672, refresh_token: "r8f1ce..." }
```

## Using with Devise

If you are using devise_token_auth gem, run this generator.

    $ rails g apple_sign_in:apple_auth_controller [scope]

In the scope you need to write your path from controllers to your existent devise controllers.
An example `$ rails g apple_auth:apple_auth_controller api/v1/`
This will generate a new controller: `controllers/api/v1/apple_auth_controller.rb`.

You should configure the route, you can wrap it in the devise_scope block like:
```
devise_scope :user do
  resource :user, only: %i[update show] do
    controller :apple_auth do
      post :apple_auth, on: :collection, to: 'apple_auth#create'
    end
  end
end
```

## Demo

You can find a full implementation of this gem in [this demo](https://github.com/rootstrap/apple-sign-in-rails).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rootstrap/apple_auth/issues. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rootstrap/apple_auth/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AppleAuth project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rootstrap/apple_auth/blob/master/CODE_OF_CONDUCT.md).

## Credits

apple_auth gem is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our
[contributors](https://github.com/rootstrap/apple_auth/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
