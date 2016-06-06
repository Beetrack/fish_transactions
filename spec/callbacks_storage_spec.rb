require 'fish_transactions/callbacks_storage'

module FishTransactions

  describe CallbacksStorage do


    let(:null_proc){ Proc.new{} }
    subject(:storage){ CallbacksStorage.new }

    # just a warm test: to raise or not to raise error
    describe '#store' do
      it 'accepts commit event' do
        # just run and hope no exception raised
        storage.store(:commit,&null_proc)
      end
      it 'accepts commit event' do
        storage.store(:rollback,&null_proc)
      end
      it 'does not accepts other events' do
        # I prefer to repeat this code lot of times to be more clear than DRYer

        # test tx AR events
        expect { storage.store(:after_commit,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
        expect { storage.store(:after_rollback,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)

        # and some common AR events
        expect { storage.store(:after_validation,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
        expect { storage.store(:after_create,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
        expect { storage.store(:after_update,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
        expect { storage.store(:after_save,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)

        expect { storage.store(:before_validation,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
        expect { storage.store(:before_save,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
        expect { storage.store(:before_create,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
        expect { storage.store(:before_update,&null_proc) }.to raise_error(RuntimeError, /^unknown event.+$/)
      end
    end

    describe '#committed!' do

      it 'runs a stored block' do
        expect do |test_block|
          storage.store :commit, &test_block
          storage.committed!
        end.to yield_control
      end

      it 'runs any stored block' do
        expect do |test_block|
          # i will store test block in the middle, to be sure
          # that first or last are not the only called
          storage.store :commit, &null_proc
          storage.store :commit, &test_block
          storage.store :commit, &null_proc
          storage.committed!
        end.to yield_control
      end

      it 'does not a rollback block' do
        expect do |test_block|
          storage.store :rollback, &test_block
          storage.committed!
        end.not_to yield_control
      end

    end

    describe '#rollbacked!' do

      it 'runs a stored block' do
        expect do |test_block|
          storage.store :rollback, &test_block
          storage.rolledback!
        end.to yield_control
      end

      it 'runs any stored block' do
        expect do |test_block|
          # i will store test block in the middle, to be sure
          # that first or last are not the only called
          storage.store :rollback, &null_proc
          storage.store :rollback, &test_block
          storage.store :rollback, &null_proc
          storage.rolledback!
        end.to yield_control
      end

      it 'does not a rollback block' do
        expect do |test_block|
          storage.store :commit, &test_block
          storage.rolledback!
        end.not_to yield_control
      end

    end

  end

end