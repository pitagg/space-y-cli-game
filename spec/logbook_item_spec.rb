# frozen_string_literal: true

require './entities/logbook_item'

describe LogbookItem do
  subject(:logbook_item) { described_class.new }

  it 'formats the elapsed time as HH:MM:SS' do
    logbook_item.elapsed_time = 195
    expect(logbook_item.formatted_elapsed_time).to eq('00:03:15')
  end

  it 'formats the time left as HH:MM:SS' do
    logbook_item.time_left = 8410
    expect(logbook_item.formatted_time_left).to eq('02:20:10')
  end
end
