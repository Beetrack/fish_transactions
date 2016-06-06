require 'fish_transactions/active_record_mods/connection_abstract_adapter'
require 'fish_transactions/active_record_mods/base'

# :nodoc: all
ActiveRecord::Base.extend FishTransactions::ActiveRecordMods::Base
ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, FishTransactions::ActiveRecordMods::ConnectionAbstractAdapter)