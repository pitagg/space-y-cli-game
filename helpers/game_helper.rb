# frozen_string_literal: true

# Methods to support user interactions.
module GameHelper
  def delay(seconds = 1)
    sleep seconds unless options[:fast]
  end

  def msg(message = '', color = nil, delay = 0.5)
    delay delay
    say message, color
  end

  def quick_msg(message = '', color = nil)
    msg message, color, 0.1
  end

  def center_msg(message = '', color = nil, cols = 80)
    left_space = ' ' * ((cols - message.size) / 2).round
    msg(left_space + message, color)
  end

  def demand(question, *args)
    answer = nil
    loop do
      answer = ask(question, args).strip
      break if answer.size.positive?
    end
    answer
  end

  def hr(color = nil)
    # TODO: Make width configurable with a command option.
    msg('-' * 80, color)
  end

  def br(lines = 1)
    lines.to_i.times { msg '' }
  end

  def welcome
    color = %i[bold magenta]
    hr(color)
    center_msg('SPACE Y STATION', color)
    hr(color)
    br
  end
end
