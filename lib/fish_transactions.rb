require 'fish_transactions/version'
require 'fish_transactions/active_record_mods'
require 'fish_transactions/callbacks'

##
# FishTransactions is the main Module which includes
# all fish transaction features.
#
# Please visit FishTransactions::Callbacks for more information of how to use these callbacks
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
# Optionally, you can use callbacks as
# FishTransactions class methods, like this:
#
#   FishTransactions.after_commit do
#     # thinks to do after commit
#   end
#
# <b>Please prefer including FishTransactions::Callbacks on your classes before using class methods style.</b>
#
module FishTransactions
  extend FishTransactions::Callbacks
end