# frozen_string_literal: true

# Class that represents the Station, which controls all missions.
class Station
  attr_reader :commander, :missions

  def initialize(commander)
    @commander = commander
    @missions = []
  end

  def start_mission(name)
    @missions << Mission.new(name)
    current_mission
  end

  def current_mission
    missions.last
  end

  def mission_index(mission = nil)
    mission ||= current_mission
    missions.index(mission)
  end

  def total_distance_traveled
    missions.sum(&:total_distance_traveled)
  end

  def number_of_aborts
    missions.sum(&:number_of_aborts)
  end

  def number_of_retries
    missions.sum(&:number_of_retries)
  end

  def number_of_explosions
    missions.sum(&:number_of_explosions)
  end

  def total_fuel_burned
    missions.sum(&:total_fuel_burned)
  end

  def total_flight_time
    missions.sum(&:total_flight_time)
  end

  def complete_missions
    missions.filter(&:complete?)
  end

  def aborted_missions
    missions.filter(&:aborted?)
  end

  def skipped_missions
    missions.filter do |mission|
      !mission.complete? && !mission.aborted? && !mission.exploded?
    end
  end
end
