module FishTransactions
  ##
  # Stores callbacks to be run on certain events
  # (currently, commit-only or rollback-only)
  class CallbacksStorage

    ##
    # Creates the storage empty
    def initialize
      @on_commit = []
      @on_rollback = []
    end

    ##
    # Stores a callback block to run on a event
    #
    # An event must be one of these symbols:
    #
    # * +:commit+ - run callback on commit only
    # * +:rollback+ - run callback on rollback only
    # * otherwise will raise an exception
    def store(event,&callback_block)
    end

    ##
    # Runs all callbacks asociated with commit event
    def committed!

    end

    ##
    # Runs all callbacks asociated with rollback event
    def rolledback!

    end

  end
end