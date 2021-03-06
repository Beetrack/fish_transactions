# FishTransactions NO LONGER MAINTAINED

Fish Transactions allows to add transaction callbacks anywhere.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fish_transactions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fish_transactions

## Usage

First you need to include `FishTransactions#Callbacks` module into the class
you want to use it.
Once included, you can directly call `after_commit` or `after_rollback` with
the code you wanna run on such events.


#### Example

```ruby
class SomeClass

  include FishTransactions::Callbacks

  # ...

  def some_method
    # ...

    ActiveRecord::Base.transaction do
      # executes some code
      puts "runs within transaction"

      after_commit do

        # things to do after commit
        puts "runs after commit"

      end

      # executes more code
      puts "again runs within transaction"
    end
    # ...

  end

  # ...

end

```
will output
```
runs within transaction
again runs within transaction
runs after commit
```

Please see `FishTransactions::Callbacks` for more details.

## Alternative class methods usage
Since 1.1 version you can also directly use `after_* methods` as FishTransactions class methods.


#### Example


```ruby
class SomeClass

  # ...

  def some_method
    # ...

    ActiveRecord::Base.transaction do
      # executes some code
      puts "runs within transaction"

      FishTransactions.after_commit do

        # things to do after commit
        puts "runs after commit"

      end

      # executes more code
      puts "again runs within transaction"
    end
    # ...

  end

  # ...

end

```
will output
```
runs within transaction
again runs within transaction
runs after commit
```


## Contributing

Bug reports and pull requests are welcome on GitHub at
[beetrack/fish_transactions](https://github.com/beetrack/fish_transactions). This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code
of conduct.


## Development

This gem is inspired on [AR After Transaction gem](https://github.com/grosser/ar_after_transaction).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

