module FishTransactions

  ##
  # = Fish Transactions Callbacks
  #
  # This module allows to add transaction callbacks anywhere.
  # You just need to include this module and you will able to
  # use it.
  #
  #
  # Example of usage:
  #
  #
  #   class SomeClass
  #
  #     include FishTransactions::Callbacks
  #
  #     # ...
  #
  #     def some_method
  #       # ...
  #
  #       ActiveRecord::Base.transaction do
  #         # executes some code
  #         puts "runs within transaction"
  #
  #         after_commit do
  #
  #           # things to do after commit
  #           puts "runs after commit"
  #
  #         end
  #
  #         # executes more code
  #         puts "again runs within transaction"
  #       end
  #       # ...
  #
  #     end
  #
  #     # ...
  #
  #   end
  #
  #
  # will output
  #
  #   runs within transaction
  #   again runs within transaction
  #   runs after commit
  #
  module Callbacks

    ##
    # Allows to execute any block of code after transaction completes.
    # If no transaction is actually open, the code runs immediately.
    #
    # Accepts the following options that modifies this behavior:
    #
    # * <tt>:only</tt> - Execute this code only on commit or only on
    #   rollback. Accepts one of the following symbols: <tt>:commit</tt>,
    #   <tt>:rollback</tt>.
    # * <tt>:if_no_transaction</tt> - Specifies what to do if there is no
    #   active transaction. Accepts one of the following symbols:
    #   <tt>:run</tt> (default), <tt>:skip</tt> (do not run).
    #
    # Example of use:
    #
    #   ActiveRecord::Base.transaction do
    #     # executes some code
    #     puts "runs within transaction"
    #     after_transaction do
    #       # things to do after transaction
    #       puts "runs after transaction"
    #     end
    #     # executes more code
    #     puts "again runs within transaction"
    #   end
    #
    # will output
    #
    #   runs within transaction
    #   again runs within transaction
    #   runs after transaction
    #
    #
    #
    def after_transaction(opts = {}, &block)

      # default options
      default_options = { only: nil, if_no_transaction: :run}
      opts = default_options.merge(opts)

      # normalize opts to string keys
      normalized = opts.dup
      opts.each{ |k,v| normalized[k.to_s] = v }
      opts = normalized


      if ActiveRecord::Base.connection.open_transactions > 0
        callbacks = ActiveRecord::Base.callbacks

        case opts['only']
        when :commit
          callbacks.store(:commit,&block)
        when :rollback
          callbacks.store(:rollback,&block)
        else
          # both cases
          callbacks.store(:commit,&block)
          callbacks.store(:rollback,&block)
        end
      else
        if opts['if_no_transaction'] == :run
          block.call
        end
      end
    end
    alias after_tx after_transaction

    ##
    # Executes some code only after current transactions does commit.
    # If no transaction is actually open, the code runs immediately.
    #
    # Shortcut for <tt>after_transaction(only: :commit, if_no_transaction: :run) do ... end </tt>
    #
    # Please use #after_transaction for more options
    def after_commit(&block)
      after_transaction(only: :commit, &block)
    end

    ##
    # Executes some code only after current transaction does rollback.
    # If no transaction is actually open, the code does not runs.
    #
    # Shortcut for <tt>after_transaction(only: :rollback, if_no_transaction: :skip) do ... end </tt>
    #
    # Please use #after_transaction for more options
    def after_rollback(&block)
      after_transaction(only: :rollback, if_no_transaction: :skip, &block)
    end

  end
end