module FishTransactions

  ##
  # Module that modifies ActiveRecord transactions to capture events
  module ActiveRecordMods
    ##
    # Modifications for ActiveRecord::Base class
    module Base

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

      def transaction_with_callbacks(*args)

        original_ar_transaction(*args) do
          begin
            yield
          rescue ActiveRecord::Rollback
            raise
          end
        end
      rescue Exception
        raise
      ensure
      end

    end
  end
end