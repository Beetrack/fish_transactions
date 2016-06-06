require 'simplecov'
SimpleCov.start

require 'rspec'
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => :nulldb

require 'rspec/expectations'

RSpec::Matchers.define :receive_in_order do |*expected_call_order|
  match do |test_double|
    Array.wrap(expected_call_order).each do |a_call|
      expect(test_double).to receive(a_call).ordered
    end
    Array.wrap(@not_to_be_called).each do |avoid_call|
      expect(test_double).not_to receive(avoid_call)
    end
    true
  end

  chain :but_not do |*expected_not_be_called|
    @not_to_be_called = expected_not_be_called
  end
end
