# frozen_string_literal: true

require './game'
require_relative 'mocks/game_mock'

describe Game do
  let(:game) { described_class.new }

  it 'asks the user name' do
    expect do
      game.build_commander
    end.to output(
      a_string_including('Hello Commander Henry')
    ).to_stdout
  end

  describe '#try_to_launch' do
    before do
      game.yes_answer = true
      game.mission = fake_mission(game.station)
    end

    it 'aborts if randomness#should_abort?' do
      game.randomness.define_singleton_method(:should_abort?) { |_m| true }
      allow(game).to receive(:abort!)
      game.try_to_launch
      expect(game).to have_received(:abort!)
    end

    it 'do not abort if randomness#should_abort? returns false' do
      game.randomness.define_singleton_method(:should_abort?) { |_m| false }
      allow(game).to receive(:abort!)
      game.try_to_launch
      expect(game).not_to have_received(:abort!)
    end
  end

  context 'when the mission ends' do
    it 'shows the mission summary' do
      expect do
        game.show_mission_stats
      end.to output(
        include('Mission summary')
      ).to_stdout
    end
  end

  context 'when the mission is aborted' do
    before do
      # Prepare mission to be aborted
      game.yes_answer = true
      game.define_singleton_method(:retry_launch) do
        puts '#retry_launch suppressed by test.'
      end
      game.mission = fake_mission(game.station, :engage)
    end

    it 'shows an abort message' do
      expect { game.confirm_and_abort }.to output(
        a_string_including("Mission #{game.mission.name} aborted!")
      ).to_stdout
    end

    it 'shows the total distance traveled as 0' do
      expect { game.confirm_and_abort }.to output(
        a_string_including('Total distance traveled: 0.0 km')
      ).to_stdout
    end

    it 'shows the flight time as 0' do
      expect { game.confirm_and_abort }.to output(
        a_string_including('Flight time: 0')
      ).to_stdout
    end

    it 'permits to retry' do
      allow(game).to receive(:retry_launch)
      game.confirm_and_abort
      expect(game).to have_received(:retry_launch)
    end
  end

  context 'when it explodes' do
    before do
      # Answer yes to pass all stages
      game.yes_answer = true
      game.mission = fake_mission(game.station)
      # Prevents mission to randomly abort
      game.randomness.define_singleton_method(:should_abort?) { |_m| false }
      # Prepares mission to explode at 15 seconds
      game.randomness.define_singleton_method(:when_explode) { |_m| 15 }
    end

    it 'shows the total distance based on when it exploded' do
      expect { game.try_to_launch }.to output(
        include('rocket exploded', 'Total distance traveled: 6.25 km')
      ).to_stdout
    end

    it 'shows the flight time based on when it exploded' do
      expect { game.try_to_launch }.to output(
        include('rocket exploded', 'Flight time: 15')
      ).to_stdout
    end
  end

  context 'when all missions end' do
    before do
      # Prevent game from running missions and previous steps.
      game.define_singleton_method(:welcome) { '' }
      game.define_singleton_method(:build_commander) { '' }
      game.define_singleton_method(:build_station) { '' }
      game.define_singleton_method(:start_mission) { '' }
      game.mission = fake_mission(game.station, :engage)
    end

    it 'show stats of all missions' do
      expect { game.play }.to output(
        include(
          'Statistics',
          'Number of missions: 10'
        )
      ).to_stdout
    end
  end

  describe '#randomness' do
    describe '#should_abort?' do
      it 'returns true one in every 3rd mission' do
        game.station = Station.new game.commander
        fake_missions(game.station, 9)
        result_for_missions = game.station.missions.map do |mission|
          game.randomness.should_abort? mission
        end
        chunks = result_for_missions.each_slice(3)
        expect(chunks.map { |c| c.count(true) }).to eq([1, 1, 1])
      end
    end

    describe '#when_explode' do
      it 'returns a positive value one in every 5th mission' do
        fake_complete_missions(game.station, 15)
        result_for_missions = game.station.missions.first(15).map do |mission|
          game.randomness.when_explode mission
        end
        chunks = result_for_missions.each_slice(5)
        expect(chunks.map { |c| c.compact.size }).to eq([1, 1, 1])
      end
    end
  end
end
