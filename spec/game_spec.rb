# frozen_string_literal: true

require './game.rb'

# Mock user interaction
class Game
  def ask(*args)
    'Henry'
  end

  def yes?(*args)
    false
  end
end

describe Game do
  it 'asks the user name' do
    expect do
      Game.new.invoke(:play)
    end.to output(
          a_string_including('Hello Henry')
        ).to_stdout
  end

  it 'asks for human interaction before moving to the next stage' do
  end

  it 'aborts after stage 1 in 33% of the missions' do
  end

  it 'explodes in 20% of the launchs' do
  end

  context "when the mission ends" do
    it 'shows the total distance traveled' do
    end

    it 'shows the total travel time' do
    end
  end

  context 'when the mission is aborted' do
    it 'shows the total distance as 0' do
    end

    it 'shows the total travel time as 0' do
    end

    it 'permits to retry after an abort' do
    end
  end

  context 'when it explodes' do
    it 'shows the total distance and time from a random spot in the timeline' do
    end
  end

  context "when all missions end" do
    it "show stats of all missions" do
    end

  end

end
