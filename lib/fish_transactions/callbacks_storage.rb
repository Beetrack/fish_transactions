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
      case event
      when :commit then @on_commit << callback_block
      when :rollback then @on_rollback << callback_block
      else raise "unknown event #{event.inspect}"
      end
    end

    ##
    # Runs all callbacks asociated with commit event
    def committed!
      @on_commit.each do |callback|
        callback.call
      end
      clear
    end

    ##
    # Runs all callbacks asociated with rollback event
    def rolledback!
      @on_rollback.each do |callback|
        callback.call
      end
      clear
    end

    private

    def clear
      @on_commit.clear
      @on_rollback.clear
    end

  end
end