module FishTransactions

  # :nodoc:
  module ActiveRecordMods
    
    ##
    # Modifications for ActiveRecord::ConnectionAdapters::AbstractAdapter class
    module ConnectionAbstractAdapter

      ##
      # When included this module, will add:
      #
      # * <tt>attr_accessor fish_callbacks_storage</tt>
      def self.included(base)
        base.send(:attr_accessor,:fish_callbacks_storage)
      end

    end
  end
end