# frozen_string_literal: true

# Mock class Game to simulate user interaction
class Game
  attr_accessor :commander, :station, :mission, :yes_answer

  def options = { fast: true }

  def initialize
    @commander = Commander.new 'Henry'
    @station = Station.new @commander
    fake_complete_missions(@station, 5, with_logbook: true)
    fake_exploded_missions(@station, 2, with_logbook: true)
    fake_aborted_missions(@station, 2)
    @mission = @station.current_mission
  end

  def ask(*_args)
    'Henry'
  end

  def yes?(*_args)
    !!yes_answer
  end
end
