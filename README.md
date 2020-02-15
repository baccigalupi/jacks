# Jacks

```txt
    ___          ___           ___           ___           ___
   /  /\        /  /\         /  /\         /__/|         /  /\
  /  /:/       /  /::\       /  /:/        |  |:|        /  /:/_
 /__/::\      /  /:/\:\     /  /:/         |  |:|       /  /:/ /\  
 \__\/\:\    /  /:/~/::\   /  /:/  ___   __|  |:|      /  /:/ /::\
    \  \:\  /__/:/ /:/\:\ /__/:/  /  /\ /__/\_|:|____ /__/:/ /:/\:\
     \__\:\ \  \:\/:/__\/ \  \:\ /  /:/ \  \:\/:::::/ \  \:\/:/~/:/
     /  /:/  \  \::/       \  \:\  /:/   \  \::/~~~~   \  \::/ /:/
    /__/:/    \  \:\        \  \:\/:/     \  \:\        \__\/ /:/  
    \__\/      \  \:\        \  \::/       \  \:\         /__/:/
                \__\/         \__\/         \__\/         \__\/
```

Working in an app that has both a client side application and a server side
application is not fun. We keep having to reinvent this world where one app
passes through to the other, and static assets are truly static. Jacks is a Rack
server that passes through to a React client side app. It is backed by webpack.
Assets deploy to S3. Just add application and love.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jacks'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jacks


Getting the gem is really just the begging though. Next you need to create a
Jacks app via the command line:

    $ # Use an existing directory
    $ cd my_jacks_app
    $ jacks new .

    $ # --or-- have Jacks create one
    $ jacks new the_next_great_american_app

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jacks. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/jacks/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jacks project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jacks/blob/master/CODE_OF_CONDUCT.md).
