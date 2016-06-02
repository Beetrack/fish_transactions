module FishTransactions

  ##
  # = Fish Transactions Callbacks
  #
  # This module allows to add transaction callbacks anywhere.
  # You just need to include this module and you will able to
  # use it.
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

    end

    ##
    # Executes some code only after current transactions does commit.
    # If no transaction is actually open, the code runs immediately.
    #
    #
    # Use #after_transaction for more options
    def after_commit(&block)

    end

    ##
    # Executes some code only after current transaction does rollback.
    # If no transaction is actually open, the code runs immediately.
    #
    #
    # Use #after_transaction for more options
    def after_rollback(&block)

    end

  end
end