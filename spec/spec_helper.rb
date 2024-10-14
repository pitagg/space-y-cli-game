# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = './tmp/rspec-examples.txt'
  config.warnings = true
  config.order = :random
  config.color = true
  config.formatter = ENV.fetch('CI', false) == 'true' ? :progress : :documentation

  def push_mission_state(mission, event)
    events = %i[engage abort release cross_check launch explode complete]
    events.delete(:abort) unless event == :abort
    events.delete(:explode) unless event == :explode
    events.first(events.index(event) + 1).each { |e| mission.send(e) }
  end

  # TODO: These fake... helpers shoulbe be replaced with fixtures
  def fake_mission(station, state_event = nil)
    name = "Y #{station.missions.size + 1}"
    mission = station.start_mission(name)
    push_mission_state(mission, state_event) if state_event
    mission
  end

  def fake_missions(station, number)
    number.times.map { fake_mission(station) }
  end

  def fake_aborted_missions(station, number)
    number.times do
      mission = fake_mission(station)
      push_mission_state(mission, :abort)
    end
  end

  def fake_retried_missions(station, number, end_event)
    number.times do
      mission = fake_mission(station)
      push_mission_state(mission, :abort)
      mission.retry
      push_mission_state(mission, end_event)
    end
  end

  def fake_complete_missions(station, number, with_logbook: false)
    number.times do
      mission = fake_mission(station)
      push_mission_state(mission, :launch)
      fake_logbook(mission) if with_logbook
      mission.complete if mission.launched?
    end
  end

  def fake_exploded_missions(station, number, with_logbook: false)
    number.times do
      mission = fake_mission(station)
      push_mission_state(mission, :launch)
      fake_logbook(mission, (1..5).to_a.sample) if with_logbook
      mission.explode if mission.launched?
    end
  end

  def fake_logbook(mission, limit = 10, interval = 60)
    limit.times do |i|
      mission.do_travel_check(i * interval)
      break if mission.complete? || mission.exploded?
    end
  end
end
