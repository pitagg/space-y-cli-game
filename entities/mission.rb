# frozen_string_literal: true

require 'aasm'

# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/BlockLength

# Class that represents the Mission
class Mission
  include AASM
  attr_reader :name, :plan, :logbook
  attr_reader :number_of_aborts, :number_of_retries

  DEFAULT_PLAN = {
    travel_distance: 160, # Km
    payload_capacity: 50_000, # Kg
    fuel_capacity: 1_514_100, # Liters
    burn_rate: 168_233, # Liters/min
    average_speed: 1500, # Km/h
    max_travel_time: 600 # Max seconds to wait completion
  }.freeze

  # TODO: Extract it to a MissionAASM module?
  aasm do
    state :off, initial: true
    state :engaged
    state :released
    state :cross_checked
    state :launched
    state :aborted
    state :exploded
    state :complete

    event :engage do
      transitions from: :off, to: :engaged
    end

    event :release do
      transitions from: :engaged, to: :released
    end

    event :cross_check do
      transitions from: :released, to: :cross_checked
    end

    event :launch do
      transitions from: :cross_checked, to: :launched
    end

    event :abort do
      abortable_states = %i[engaged released cross_checked]
      transitions from: abortable_states, to: :aborted

      after do
        do_travel_check(0)
        @number_of_aborts += 1
      end
    end

    event :retry do
      transitions from: :aborted, to: :off

      after do
        @number_of_retries += 1
      end
    end

    event :explode do
      transitions from: :launched, to: :exploded
    end

    event :complete do
      transitions from: :launched, to: :complete
    end
  end

  def state
    aasm.current_state
  end

  def initialize(name)
    @name = name.split.map(&:capitalize).join(' ')
    @plan = DEFAULT_PLAN
    @logbook = []
    @number_of_aborts = 0
    @number_of_retries = 0
  end

  def build_log(elapsed_time)
    log = LogbookItem.new
    log.elapsed_time = elapsed_time
    log.distance_traveled = distance_traveled_at(elapsed_time)
    log.speed = speed_at(elapsed_time)
    log.burn_rate = burn_rate_at(elapsed_time)
    log.fuel_burned = fuel_burned_at(elapsed_time)
    log.distance_left = distance_left_at(elapsed_time)
    log.time_left = time_left_at(elapsed_time)
    log
  end

  # Calc trip indicators at a time, record Logbook and clomplete the mission.
  def do_travel_check(elapsed_time)
    log = build_log(elapsed_time)
    complete if log.distance_traveled >= plan[:travel_distance]
    log.state = state
    @logbook << log
    log
  end

  # Calc the distance traveled at a spefic time.
  def distance_traveled_at(elapsed_time)
    return 0 unless elapsed_time.positive?

    plan[:average_speed] / 3600.0 * elapsed_time
  end

  # Calc the speed at a spefic time.
  def speed_at(elapsed_time)
    return 0 unless elapsed_time.positive?

    # TODO: Implement acceleration.
    plan[:average_speed]
  end

  # Calc the burn rate at a spefic time.
  def burn_rate_at(elapsed_time)
    return 0 unless elapsed_time.positive?

    # TODO: Make it variable based on the acceleration
    plan[:burn_rate]
  end

  # Calc the total fuel burned at a spefic time.
  def fuel_burned_at(elapsed_time)
    return 0 unless elapsed_time.positive?

    burn_rate_at(elapsed_time) / 60 * elapsed_time
  end

  # Calc the distance left at a spefic time.
  def distance_left_at(elapsed_time)
    return 0 unless elapsed_time.positive?

    distance = plan[:travel_distance] - distance_traveled_at(elapsed_time)
    distance.positive? ? distance : 0
  end

  # Calc the time left at a spefic time.
  def time_left_at(elapsed_time)
    return 0 unless elapsed_time.positive?

    time = (distance_left_at(elapsed_time) / speed_at(elapsed_time) * 3600)
    time.positive? ? time : 0
  end

  # TODO: turn it less verbose
  def total_distance_traveled
    logbook.last&.distance_traveled.to_f
  end

  # Does it make sense since it can only explode once?
  def number_of_explosions
    exploded? ? 1 : 0
  end

  def total_fuel_burned
    logbook.last&.fuel_burned.to_f
  end

  def total_flight_time
    logbook.last&.elapsed_time.to_i
  end
end
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/BlockLength
