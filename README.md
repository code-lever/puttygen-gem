# puttygen [![Build Status](https://travis-ci.org/code-lever/puttygen-gem.png)](https://travis-ci.org/code-lever/puttygen-gem) [![Code Climate](https://codeclimate.com/github/code-lever/puttygen-gem.png)](https://codeclimate.com/github/code-lever/puttygen-gem) [![Gem Version](https://badge.fury.io/rb/puttygen.svg)](http://badge.fury.io/rb/puttygen)

An unofficial puttygen Ruby gem.  Generate or convert SSH key files.

## Installation

This gem requires [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/) to be installed on your system.  It currently only works with the *nix distributions.

> brew install putty

or

> apt-get install putty-tools

or something else, depending on your platform.

Add this line to your application's Gemfile:

```ruby
gem 'puttygen'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puttygen

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/code-lever/puttygen-gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
