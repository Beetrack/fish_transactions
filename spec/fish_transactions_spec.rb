require 'fish_transactions'

describe FishTransactions do

  describe '.after_transaction' do
    it 'should exists' do
      expect(FishTransactions).to respond_to(:after_transaction)
    end
  end

  describe '.after_commit' do
    it 'should exists' do
      expect(FishTransactions).to respond_to(:after_commit)
    end
  end

  describe '.after_rollback' do
    it 'should exists' do
      expect(FishTransactions).to respond_to(:after_rollback)
    end
  end

end