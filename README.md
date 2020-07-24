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

## Usage

Validate JWT token and get user information:

```ruby
# with a valid JWT
user_id = '000343.1d22d2937c7a4e56806dfb802b06c430...'
valid_jwt_token = 'eyJraWQiOiI4NkQ4OEtmIiwiYWxnIjoiUlMyNTYifQ.eyJpc...'
AppleSignIn::UserIdentity.new(user_id, valid_jwt_token)
>>  { exp: 1595279622, email: "user@example.com", email_verified: true , ...}

# with an invalid JWT
invalid_jwt_token = 'eyJraWQiOiI4NkQsd4OEtmIiwiYWxnIjoiUlMyNTYifQ.edsyJpc...'
AppleSignIn::UserIdentity.new(user_id, invalid_jwt_token)
>> Traceback (most recent call last):..
>> ...
>>  AppleSignIn::Conditions::JWTValidationError
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
