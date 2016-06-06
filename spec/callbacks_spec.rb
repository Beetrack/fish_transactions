require 'fish_transactions'

module FishTransactions

  class TestCallbacksClass
    include Callbacks

    def run_with_after_commit
      before_the_block

      after_commit do
        the_after_commit_block

      end
      after_the_block_just_before_commit
    end

    def run_with_after_rollback
      before_the_block

      after_rollback do
        the_after_rollback_block

      end
      after_the_block_just_before_commit

    end

    def run_with_after_transaction_no_args
      before_the_block

      after_transaction do
        the_after_transaction_block

      end
      after_the_block_just_before_commit

    end

    def run_with_after_transaction(opts)
      before_the_block

      after_transaction(opts) do
        the_after_transaction_block

      end
      after_the_block_just_before_commit

    end

    def before_the_block; end
    def after_the_block_just_before_commit; end

    def the_after_commit_block; end
    def the_after_rollback_block; end
    def the_after_transaction_block; end

  end

  describe Callbacks do

    let(:execution_double) do
      double = TestCallbacksClass.new
      allow(double).to receive(:run).and_call_original
      double
    end

    describe '#after_commit' do

      context 'without transaction' do

        it 'should run in place' do

          expect(execution_double).to receive_in_order(
            :before_the_block,
            :the_after_commit_block,
            :after_the_block_just_before_commit
          )

          execution_double.run_with_after_commit

        end
      end

      context 'within a transaction' do

        it 'should wait transaction to commit' do

          expect(execution_double).to receive_in_order(
            :before_the_block,
            :after_the_block_just_before_commit,
            :the_after_commit_block
          )

          ActiveRecord::Base.transaction do
            execution_double.run_with_after_commit
          end

        end

        it 'should not run on rollback' do
          expect(execution_double).to receive_in_order(
            :before_the_block,
            :after_the_block_just_before_commit
          ).but_not(
            :the_after_commit_block
          )

          ActiveRecord::Base.transaction do
            execution_double.run_with_after_commit
            raise ActiveRecord::Rollback
          end
        end

      end

    end

    describe '#after_rollback' do

      context 'without transaction' do

        it 'should not run at all' do

          expect(execution_double).to receive_in_order(
            :before_the_block,
            :after_the_block_just_before_commit
          ).but_not(
            :the_after_rollback_block
          )

          execution_double.run_with_after_rollback

        end
      end

      context 'within a transaction' do

        it 'should not run on commit' do

          expect(execution_double).to receive_in_order(
            :before_the_block,
            :after_the_block_just_before_commit
          ).but_not(
            :the_after_rollback_block
          )

          ActiveRecord::Base.transaction do
            execution_double.run_with_after_rollback
          end

        end

        it 'should run on rollback' do
          expect(execution_double).to receive_in_order(
            :before_the_block,
            :after_the_block_just_before_commit,
            :the_after_rollback_block
          )

          ActiveRecord::Base.transaction do
            execution_double.run_with_after_rollback
            raise ActiveRecord::Rollback
          end
        end

      end

    end

    describe '#after_transaction' do

      context 'without a transaction' do

        context 'by default' do

          it 'should executes immediately' do
            expect(execution_double).to receive_in_order(
              :before_the_block,
              :the_after_transaction_block,
              :after_the_block_just_before_commit
            )
            execution_double.run_with_after_transaction_no_args
          end
        end

        context 'and with a {:if_no_transaction => :run} param' do

          it 'should executes inmediately' do
            expect(execution_double).to receive_in_order(
              :before_the_block,
              :the_after_transaction_block,
              :after_the_block_just_before_commit
            )
            execution_double.run_with_after_transaction(if_no_transaction: :run)
          end
        end

        context 'and with a {:if_no_transaction => :skip} param' do
          it 'should not execute' do
            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit
            ).but_not(
              :the_after_transaction_block
            )
            execution_double.run_with_after_transaction(if_no_transaction: :skip)
          end
        end

        context 'and with a {:if_no_transaction => :skip} param given as string' do
          it 'should not execute' do
            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit
            ).but_not(
              :the_after_transaction_block
            )
            execution_double.run_with_after_transaction('if_no_transaction' => 'skip')
          end
        end

      end

      context 'within a transaction' do

        context 'by default' do
          it 'should executes after commit' do

            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit,
              :the_after_transaction_block
            )
            ActiveRecord::Base.transaction do
              execution_double.run_with_after_transaction_no_args
            end
          end

          it 'should executes after rollback' do

            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit,
              :the_after_transaction_block
            )
            ActiveRecord::Base.transaction do
              execution_double.run_with_after_transaction_no_args
              raise ActiveRecord::Rollback
            end
          end
        end

        context 'and with a {only: :commit} param' do
          it 'should executes after commit' do

            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit,
              :the_after_transaction_block
            )
            ActiveRecord::Base.transaction do
              execution_double.run_with_after_transaction(only: :commit)
            end
          end

          it 'should not executes after rollback' do

            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit
            ).but_not(
              :the_after_transaction_block
            )
            ActiveRecord::Base.transaction do
              execution_double.run_with_after_transaction(only: :commit)
              raise ActiveRecord::Rollback
            end
          end
        end


        context 'and with a {only: :rollback} param' do
          it 'should not executes after commit' do

            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit
            ).but_not(
              :the_after_transaction_block
            )
            ActiveRecord::Base.transaction do
              execution_double.run_with_after_transaction(only: :rollback)
            end
          end

          it 'should executes after rollback' do

            expect(execution_double).to receive_in_order(
              :before_the_block,
              :after_the_block_just_before_commit,
              :the_after_transaction_block
            )
            ActiveRecord::Base.transaction do
              execution_double.run_with_after_transaction(only: :rollback)
              raise ActiveRecord::Rollback
            end
          end
        end

      end

    end

  end
end