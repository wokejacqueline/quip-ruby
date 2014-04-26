# Quip API Ruby Client

This is the unofficial Quip API Ruby client library.

## Installation

Add this line to your application's Gemfile:

    gem 'quip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quip

## Usage

```ruby
client = Quip::QuipClient.new(access_token: '...')
user = client.get_authenticated_user()
desktop = client.get_folder(user['desktop_folder_id'])
puts "There are #{desktop['children'].length} items on the desktop"
```

## Contributing

1. Fork it ( http://github.com/jacamat/quip-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
