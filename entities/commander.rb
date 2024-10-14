# frozen_string_literal: true

# Class that represents the Space Station Commander.
class Commander
  attr_reader :name

  def initialize(name)
    name = 'Player' unless name.strip.size.positive?
    @name = name.split.map(&:capitalize).join(' ')
  end
end
