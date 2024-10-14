#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require_relative 'initialize'

# Class responsible for the game flow and user interaction.
class Game < Thor
  include GameHelper
  include MissionHelper
  include StationHelper

  desc 'play', 'Start the game.'
  method_option :fast, aliases: '-f', desc: 'Fast mode (no delay between steps)'
  def play
    welcome
    build_commander
    build_station
    start_mission
    show_station_stats
    commander_farewell
  rescue StandardError => e
    evacuation_alert(e)
  rescue Interrupt
    msg 'Bye!', %i[bold magenta]
  end

  no_commands do
    def randomness
      @randomness ||= MissionRandomness.new(@station)
    end
  end
end

Game.start
