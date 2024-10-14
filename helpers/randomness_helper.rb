# frozen_string_literal: true

# Class responsible for the randomness of mission aborts and explosions.
# - It predefines what missions should be aborted and how many times.
#   There is a requisite to abort "one in every 3rd" launchs.
#   eg.: [ 0, 0, 2 ] # 3rd should be aborted TWICE, the others 0 times.
# - It predefines what missions should be exploded.
#   There is a requisite to explode "one in every 5th" launchs.
#   eg.: [ nil, 180, nil, nil, nil ] # 2nd should explode at 180s, others never.
# Notes:
#   - The same mission could be aborted and exploded after a retry.
#   - Predefined result must be increased with a new randomic set of random results every time it achieve the end.
# TODO: Reflect on where is the right place for this file. Is it a helper?
class MissionRandomness
  class StationIsRequired < StandardError; end

  def initialize(station)
    raise StationIsRequired unless station.is_a? Station

    @station = station
    @randomic_aborts = []
    @randomic_explosions = []
  end

  def should_abort?(mission)
    mission.number_of_aborts < expected_aborts_for(mission)
  end

  def when_explode(mission)
    mission_i = @station.mission_index(mission)
    random_explosions if @randomic_explosions.size < mission_i + 1
    @randomic_explosions[mission_i]
  end

  private

  # Append @randomic_explosions with a new group of possibilities where 1/5 is explosion.
  def random_explosions
    # Explode anytime in the first 240 seconds (4 minutes)
    explode_at = Random.new.rand(240) + 1
    next_group = [nil, nil, nil, nil, explode_at].shuffle
    @randomic_explosions.append(*next_group)
  end

  # Append @randomic_aborts with a new group of possibilities where 1/3 is abort.
  def random_aborts
    number_of_aborts = Random.new.rand(3) + 1
    next_group = [0, 0, number_of_aborts].shuffle
    @randomic_aborts.append(*next_group)
  end

  def expected_aborts_for(mission)
    mission_i = @station.mission_index(mission)
    random_aborts if @randomic_aborts.size < mission_i + 1
    @randomic_aborts[mission_i]
  end
end
