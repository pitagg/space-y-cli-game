# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

# Methods to support user interactions with the Station.
module StationHelper
  def build_commander
    @commander = Commander.new ask('What is your name?')
    msg "Hello Commander #{@commander.name}.", :green
    quick_msg 'Welcome to Space Y Station', :green
  end

  def build_station
    @station = Station.new @commander
  end

  # TODO: Format numbers and time
  def show_station_stats
    br 2
    hr
    msg 'Space Y Station Statistics', :bold
    quick_msg "Number of missions: #{@station.missions.size}"
    quick_msg "  Complete: #{@station.complete_missions.size}"
    quick_msg "  Aborted: #{@station.aborted_missions.size}"
    quick_msg "  Exploded: #{@station.number_of_explosions}"
    quick_msg "  Skipped: #{@station.skipped_missions.size}"
    quick_msg "Total distance traveled: #{@station.total_distance_traveled} km"
    aborts = @station.number_of_aborts
    retries = @station.number_of_retries
    quick_msg "Number of abort and retries: #{aborts}/#{retries}"
    quick_msg "Total fuel burned: #{@station.total_fuel_burned} liters"
    quick_msg "Total flight time: #{@station.total_flight_time}"
    hr
    br
  end

  def commander_farewell
    msg = [
      'Thank you for leading the missions Commander ',
      @commander.name,
      ' and have a safe journey home.'
    ]
    msg msg.join, %i[bold magenta]
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
