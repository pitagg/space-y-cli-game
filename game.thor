# frozen_string_literal: true

# Class responsible for the game flow and user interaction.
class Game < Thor
  desc 'play', 'starts the game Space Y.'
  def play
    say '--- SPACE Y ---', color: %i[green bold]
    player = ask('What is your name?')
    say "Hello #{player}. Welcome to the Space Y Station", color: :green

    loop do
      break unless yes? 'Would you like to start a new mission? (Y/n)'

      mission = demand('What is the name of this mission?')
      say "#{mission} is underway.", color: :green

      next unless yes? 'Engage afterburner? (Y/n)'
      say 'Afterburner engaged!', color: :green

      next unless yes? 'Release support structures? (Y/n)'
      say 'Support structures released!', color: :green

      next unless yes? 'Perform cross-checks? (Y/n)'
      say 'Cross-checks performed!', color: :green

      #TODO: abort/retry

      next unless yes? 'Launch? (Y/n)'
      say 'Launched!', color: :green

      initial_time = Time.now
      loop do
        # 1 real second means 30 seconds in the game.
        elapsed_time = (Time.now - initial_time) * 30

        say 'Mission status:', color: :bold, delay: 0.2
        say '  Current fuel burn rate: 151,416 liters/min', delay: 0.2
        say '  Current speed: 1,350 km/h', delay: 0.2
        say '  Current distance traveled: 12.5 km', delay: 0.2
        say '  Elapsed time: 0:00:30', delay: 0.2
        say '  Time to destination: 0:05:54'

        break if elapsed_time > 90
        sleep 1
      end

      say 'Mission summary:', color: :bold
      say '  Total distance traveled: 160.36 km'
      say '  Number of abort and retries: 0/0'
      say '  Number of explosions: 0'
      say '  Total fuel burned: 1,079,091 liters'
      say '  Flight time: 0:06:25'
    end

    say 'Space Y Station Dashboard (all missions)', color: :bold
    say '  Total distance traveled: 999999'
    say '  Number of abort and retries: 99'
    say '  Number of explosions: 99'
    say '  Total fuel burned: 99999'
    say '  Total flight time: 99999'

    say 'Thank you for leading the missions and have a safe journey home.'
  end

  no_commands do
    def say(message = '', color: nil, delay: 0.5)
      super message, color
      sleep delay
    end

    def demand(question, *args)
      answer = nil
      loop do
        answer = ask(question, args).strip
        break if answer.size > 0
      end
      answer
    end
  end
end
