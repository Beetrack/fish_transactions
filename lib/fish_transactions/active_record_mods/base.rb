require 'fish_transactions/callbacks_storage'

module FishTransactions

  ##
  # Module that modifies ActiveRecord transactions to capture events
  module ActiveRecordMods
    ##
    # Modifications for ActiveRecord::Base class
    # All methods here will be class level methods
    module Base

      ##
      # When extended, this module will:
      #
      # * alias the +:transaction+ method and them override it
      def self.extended( base )

        base.class_eval do
          class << self
            # create an alias for the original +transaction+ method
            alias_method :original_ar_transaction, :transaction
            # and we 'rename' the new method as transaction
            alias_method :transaction, :transaction_with_callbacks
          end
        end

      end



      ##
      # Wrapper of original transaction.
      # Captures and then raises Rollback exception
      # to know there were a rollback
      def transaction_with_callbacks(*args)

        committed = true

        original_ar_transaction(*args) do
          begin
            yield
          rescue ActiveRecord::Rollback
            committed = false
            raise
          end
        end
      rescue Exception
        committed = false
        raise
      ensure
        if committed
          callbacks.committed!
        else
          callbacks.rolledback!
        end
      end

      ##
      # read-access to callbacks storage
      def callbacks
        connection.fish_callbacks_storage ||= FishTransactions::CallbacksStorage.new
      end

    end
  end
end