require 'fish_transactions'

module FishTransactions

  describe Callbacks do

    let(:clazz) { Class.new { include Callbacks } }
    let(:object) { clazz.new }

    describe '#after_commit' do

      context 'without transaction' do

        it 'should run in place' do
          execution_order = []

          execution_order << 'before block'
          object.after_commit do
            execution_order << 'block'
          end
          execution_order << 'after block'

          expect(execution_order).to eq(['before block','block','after block'])

        end
      end

      context 'within a transaction' do

        it 'should wait transaction to commit' do
          execution_order = []

          ActiveRecord::Base.transaction do

            execution_order << 'before block'
            object.after_commit do
              execution_order << 'block'
            end
            execution_order << 'after block'

          end

          expect(execution_order).to eq(['before block','after block','block'])

        end

      end

    end

  end
end