# AppleSignIn

[![CI](https://travis-ci.org/rootstrap/apple_sign_in.svg?branch=master)](https://travis-ci.org/rootstrap/apple_sign_in)
[![Maintainability](https://api.codeclimate.com/v1/badges/78453501221a76e3806e/maintainability)](https://codeclimate.com/github/rootstrap/apple_sign_in/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/78453501221a76e3806e/test_coverage)](https://codeclimate.com/github/rootstrap/apple_sign_in/test_coverage)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/apple_sign_in`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apple_sign_in'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install apple_sign_in

------------------

After installing the gem, you need to run the generator.

    $ rails g apple_sign_in:config

This will generate a new initializer: `apple_sign_in.rb` containing the following default configuration:
```
AppleSignIn.configure do |config|
  # config.apple_client_id = <Your client_id in your Apple Developer account>
  # config.apple_private_key = <Your private key provided by Apple>
  # config.apple_key_id = <Your kid provided by Apple>
  # config.apple_team_id = <Your team id provided by Apple>
  # config.redirect_uri = <Your app redicrect url>
end
```
Set your different credentials in the file by uncommenting the lines and adding your keys.

## Usage

This show you an example of a settings

```ruby
AppleSignIn.configure do |config|
  config.apple_client_id = 'com.yourapp...'
  config.apple_private_key = "-----BEGIN PRIVATE KEY-----\nMIGTAgEA....\n-----END PRIVATE KEY-----"
  config.apple_key_id = 'RTZ...'
  config.apple_team_id = 'WNU...'
  config.redirect_uri = 'https://localhost:3000'
end
```

We strongly recommend to use environment variable when you add this values.

Apple sign in workflow:

![alt text](https://docs-assets.developer.apple.com/published/360d59b776/rendered2x-1592224731.png)

For more information, check the [Apple oficial documentation](https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_rest_api)

Validate JWT token and get user information:

```ruby
# with a valid JWT
user_id = '000343.1d22d2937c7a4e56806dfb802b06c430...'
valid_jwt_token = 'eyJraWQiOiI4NkQ4OEtmIiwiYWxnIjoiUlMyNTYifQ.eyJpc...'
AppleSignIn::UserIdentity.new(user_id, valid_jwt_token).validate!
>>  { exp: 1595279622, email: "user@example.com", email_verified: true , ...}

# with an invalid JWT
invalid_jwt_token = 'eyJraWQiOiI4NkQsd4OEtmIiwiYWxnIjoiUlMyNTYifQ.edsyJpc...'
AppleSignIn::UserIdentity.new(user_id, invalid_jwt_token).validate!
>> Traceback (most recent call last):..
>> ...
>>  AppleSignIn::Conditions::JWTValidationError
```

Verify user identity and get token:

```ruby
code = 'cfb77c21ecd444390a2c214cd33decdfb.0.mr...'
AppleSignIn::Token.new(code).authenticate
>> { access_token: "a7058d...", expires_at: 1595894672, refresh_token: "r8f1ce..." }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/apple_sign_in. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/apple_sign_in/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AppleSignIn project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/apple_sign_in/blob/master/CODE_OF_CONDUCT.md).

## Credits

apple_sign_in is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our
[contributors](https://github.com/rootstrap/apple_sign_in/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
