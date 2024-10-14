# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

# Methods to support user interactions with the Mission.
module MissionHelper
  def start_mission?
    yes? 'Would you like to start a new mission? (Y/n)'
  end

  def build_mission
    mission_name = demand('Please, enter the mission name:')
    @mission = @station.start_mission mission_name
    msg "#{@mission.name} is underway.", :green
  end

  def confirm_and_abort
    return unless yes? 'Abort the mission? (Y/n)'

    abort!
  end

  def abort!
    @mission.abort
    hr
    msg "Mission #{@mission.name} aborted!", :red
    msg 'Better to abort now than explode later', :red
    show_mission_stats
    retry_launch
  end

  def engage_afterburner
    raise Interrupt unless yes? 'Engage afterburner? (Y/n)'

    @mission.engage
    msg 'Afterburner engaged!', :green
    true
  end

  def release_support
    raise Interrupt unless yes? 'Release support structures? (Y/n)'

    @mission.release
    msg 'Support structures released!', :green
  rescue Interrupt
    retry unless confirm_and_abort
  end

  def perform_cross_checks
    raise Interrupt unless yes? 'Perform cross-checks? (Y/n)'

    @mission.cross_check
    msg 'Cross-checks performed!', :green
  rescue Interrupt
    retry unless confirm_and_abort
  end

  def launch
    raise Interrupt unless yes? 'Launch? (Y/n)'

    @mission.launch
    msg 'Launched!', :green
  rescue Interrupt
    retry unless confirm_and_abort
  end

  def show_mission_status(log = nil)
    log ||= @mission.logbook.last
    return unless log

    msg 'Mission status:', :bold
    quick_msg "  Current fuel burn rate: #{log.burn_rate} liters/min"
    quick_msg "  Current speed: #{log.speed} km/h"
    quick_msg "  Current distance traveled: #{log.distance_traveled} km"
    quick_msg "  Elapsed time: #{log.formatted_elapsed_time}"
    quick_msg "  Time to destination: #{log.formatted_time_left}"
  end

  # rubocop:disable Metrics/MethodLength
  def show_travel_dashboard
    explode_at = randomness.when_explode(@mission)
    explode_at ||= @mission.plan[:max_travel_time]
    # Each loop runs 30 seconds in the game
    (@mission.plan[:max_travel_time] / 30).times do |i|
      elapsed_time = i * 30
      if elapsed_time > explode_at
        elapsed_time = explode_at
        @mission.explode
      end
      log = @mission.do_travel_check(elapsed_time)
      show_mission_status(log)
      delay
      break unless @mission.launched?
    end
  end
  # rubocop:enable Metrics/MethodLength

  # TODO: Format numbers and time
  def show_mission_stats
    hr
    msg 'Mission summary:', :bold
    quick_msg "  Total distance traveled: #{@mission.total_distance_traveled} km"
    aborts = @mission.number_of_aborts
    retries = @mission.number_of_retries
    quick_msg "  Number of aborts/retries: #{aborts}/#{retries}"
    quick_msg "  Number of explosions: #{@mission.number_of_explosions}"
    quick_msg "  Total fuel burned: #{@mission.total_fuel_burned} liters"
    quick_msg "  Flight time: #{@mission.total_flight_time}"
    hr
  end

  def start_mission
    return unless start_mission?

    build_mission
    try_to_launch
    start_mission
  rescue Interrupt
    start_mission
  end

  def try_to_launch
    engage_afterburner
    return abort! if randomness.should_abort?(@mission)

    release_support
    perform_cross_checks
    launch
    show_travel_dashboard
    show_complete_message
    show_mission_stats
  end

  def show_complete_message
    br
    hr
    return center_msg 'The rocket exploded!', %i[bold red] if @mission.exploded?

    center_msg 'Mission Complete!', %i[bold green]
  end

  def retry_launch
    raise Interrupt unless yes? 'Would you like to retry?'

    @mission.retry
    try_to_launch
  end

  def evacuation_alert(error)
    msg 'EVACUATION ALERT!', %i[bold red]
    msg 'The station is on fire. Better luck next time.', :red
    hr
    quick_msg 'Technical Report:', :bold
    quick_msg "#{error.class.name}: #{error.message}"
    quick_msg error.backtrace.join("\r\n")
  end
end

# rubocop:enable Metrics/ModuleLength
