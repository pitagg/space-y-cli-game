# frozen_string_literal: true

require './entities/station'
require './entities/mission'
require './entities/commander'
require './entities/logbook_item'

describe Station do
  let(:station) { described_class.new(Commander.new('Louise')) }

  describe '.new' do
    it 'sets the commander' do
      expect(station.commander.name).to eq('Louise')
    end

    it 'initializes the attribute `missions`' do
      expect(station.missions).to eq([])
    end
  end

  describe '#start_mission' do
    it 'add a new mission into missions' do
      missions = 5.times.map { |i| station.start_mission("Y #{i}") }
      expect(station.missions).to include(*missions)
    end
  end

  describe '#current_mission' do
    it 'returns the last mission built' do
      5.times.map { |i| station.start_mission("Y #{i}") }
      expect(station.current_mission.name).to eq('Y 4')
    end
  end

  context 'when the game ends' do
    before do
      fake_aborted_missions(station, 1)
      fake_retried_missions(station, 1, :abort)
      fake_retried_missions(station, 1, :complete)
      fake_complete_missions(station, 5, with_logbook: true)
      fake_exploded_missions(station, 2, with_logbook: true)
    end

    it 'calculates the total distance traveled in all missions' do
      total = station.missions.sum(&:total_distance_traveled)
      expect(station.total_distance_traveled).to eq(total)
    end

    it 'calculates the number of aborts in all missions' do
      number = station.missions.sum(&:number_of_aborts)
      expect(station.number_of_aborts).to eq(number)
    end

    it 'calculates the number of retries in all missions' do
      number = station.missions.sum(&:number_of_retries)
      expect(station.number_of_retries).to eq(number)
    end

    it 'calculates the number of explosions in all missions' do
      number = station.missions.sum(&:number_of_explosions)
      expect(station.number_of_explosions).to eq(number)
    end

    it 'calculates the total fuel burned in all missions' do
      total = station.missions.sum(&:total_fuel_burned)
      expect(station.total_fuel_burned).to eq(total)
    end

    it 'calculates the total flight time in all missions' do
      total = station.missions.sum(&:total_flight_time)
      expect(station.total_flight_time).to eq(total)
    end
  end
end
