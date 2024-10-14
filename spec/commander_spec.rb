# frozen_string_literal: true

require './entities/commander'

describe Commander do
  describe '.new' do
    it 'can receive a name' do
      commander = described_class.new 'Henry'
      expect(commander.name).to eq('Henry')
    end

    context 'when given a blank name' do
      it 'uses "Player" as default name' do
        commander = described_class.new ' '
        expect(commander.name).to eq('Player')
      end
    end
  end
end
