# frozen_string_literal: true

require './entities/mission'
require 'aasm/rspec'
require './entities/logbook_item'

describe Mission do
  let(:mission) { described_class.new('Apollo') }

  describe '.new' do
    it 'sets a default plan' do
      expect(mission.plan).to eq({ travel_distance: 160, payload_capacity: 50_000,
                                   fuel_capacity: 1_514_100, burn_rate: 168_233,
                                   average_speed: 1500, max_travel_time: 600 })
    end

    it 'sets the mission name' do
      expect(mission.name).to eq('Apollo')
    end

    it 'initializes attributes' do
      values = %i[logbook number_of_aborts number_of_retries].map do |attr|
        mission.send(attr)
      end
      expect(values).to eq([[], 0, 0])
    end
  end

  describe '.aasm' do
    it 'changes the current state after transition' do
      mission.engage
      expect(mission.state).to eq(:engaged)
    end
  end

  context 'when the mission begins' do
    it 'starts in the state :off' do
      expect(mission.state).to eq(:off)
    end

    it 'transites to engaged' do
      expect(mission).to transition_from(:off).to(:engaged).on_event(:engage)
    end

    it 'cannot abort' do
      expect(mission).not_to transition_from(:off).to(:aborted).on_event(:abort)
    end
  end

  context 'when the mission is engaged' do
    it 'transites to released' do
      expect(mission).to transition_from(:engaged).to(:released).on_event(:release)
    end

    it 'can abort' do
      expect(mission).to transition_from(:engaged).to(:aborted).on_event(:abort)
    end
  end

  context 'when the mission is released' do
    it 'transites to cross_checked' do
      expect(mission).to transition_from(:released)
        .to(:cross_checked).on_event(:cross_check)
    end

    it 'can abort' do
      expect(mission).to transition_from(:released)
        .to(:aborted).on_event(:abort)
    end
  end

  context 'when the mission is cross_checked' do
    it 'transites to launched' do
      expect(mission).to transition_from(:cross_checked)
        .to(:launched).on_event(:launch)
    end

    it 'can abort' do
      expect(mission).to transition_from(:cross_checked)
        .to(:aborted).on_event(:abort)
    end
  end

  context 'when the mission is launched' do
    before { push_mission_state(mission, :launch) }

    describe '#do_travel_check' do
      it 'records a LogbookItem into the logbook' do
        mission.do_travel_check(30)
        expect(mission.logbook).to include(have_attributes(elapsed_time: 30,
                                                           distance_traveled: be_a(Float),
                                                           speed: 1500,
                                                           burn_rate: 168_233,
                                                           distance_left: be_a(Float),
                                                           time_left: be_a(Float),
                                                           state: :launched))
      end
    end

    it 'cannot abort' do
      expect(mission).not_to transition_from(:launched).to(:aborted).on_event(:abort)
    end
  end

  context 'when the mission is aborted' do
    describe '#do_travel_check' do
      it 'records a LogbookItem with values equal zero' do
        push_mission_state(mission, :abort)
        expect(mission.logbook).to include(have_attributes(
                                             elapsed_time: 0,
                                             distance_traveled: 0,
                                             speed: 0,
                                             burn_rate: 0,
                                             distance_left: 0,
                                             time_left: 0,
                                             state: :aborted
                                           ))
      end
    end

    it 'increments the number of aborts' do
      push_mission_state(mission, :abort)
      mission.retry
      push_mission_state(mission, :abort)
      expect(mission.number_of_aborts).to eq(2)
    end
  end

  context 'when the mission is retried' do
    it 'chages the state back to off' do
      push_mission_state(mission, :abort)
      mission.retry
      expect(mission.off?).to be(true)
    end

    it 'increments the number of retries' do
      push_mission_state(mission, :abort)
      mission.retry
      push_mission_state(mission, :abort)
      mission.retry
      expect(mission.number_of_retries).to eq(2)
    end
  end

  context 'when it explodes' do
    describe '#number_of_explosions' do
      it 'returns 1' do
        push_mission_state(mission, :explode)
        expect(mission.number_of_explosions).to eq(1)
      end
    end
  end
end
