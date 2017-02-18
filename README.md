# Watson::Conversation

Ruby client library to use the [IBM Watson Conversation][wc] service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watson-conversation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watson-conversation

## Usage

```ruby
require 'watson/conversation'

manage = Watson::Conversation::ManageDialog.new(
  username: [username],
  password: [password],
  workspace_id: [workspace_id],
  # Where to link the freely-selected user name with the conversation_id
  storage: 'hash'  #means that you use Ruby hash. If you restart the app, the info will be disappeared.
  # OR
  storage: 'redis://127.0.0.1:6379'  #means that you use exteranl database like redis(This gem currently supports redis only).
)

# Get a greet message from a conversation service.
puts response1 = manage.talk("user1", "")
#=> {user: user1, status_code: 200, output: [\"What would you like me to do?\"]}

# Get a response to a user's input.
puts response2 = manage.talk("user1", "I would like you to ...")
#=> {user: user1, status_code: 200, output: [\"I help you ...\"]}

# Check if the user exists
puts manage.has_key?("user1")

# Delete the user
puts manage.delete("user1")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpha-netzilla/watson-conversation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Authors
* http://alpha-netzilla.blogspot.com/

[wc]: http://www.ibm.com/watson/developercloud/doc/conversation/index.html
