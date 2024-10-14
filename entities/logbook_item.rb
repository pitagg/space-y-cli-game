# frozen_string_literal: true

# Class that represents a record in the logbook.
class LogbookItem
  attr_accessor :elapsed_time, :distance_traveled, :speed, :burn_rate, :fuel_burned, :distance_left, :time_left, :state

  def formatted_elapsed_time
    Time.at(elapsed_time || 0).utc.strftime('%H:%M:%S')
  end

  def formatted_time_left
    Time.at(time_left || 0).utc.strftime('%H:%M:%S')
  end
end
