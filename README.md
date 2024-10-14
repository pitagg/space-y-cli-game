# Space Y CLI Game

Can you command the launch of a rocket into Earth's orbit without blowing it up? That's your mission in this Command Line Interface (CLI) game.

## Game Specifications

### The user will be responsible for conducting the flight into low earth orbit:

  1. Travel Distance: 160 kilometers
  2. Payload capacity: 50,000 kilograms including rocket itself
  3. Fuel capacity: 1,514,100 liters of fuel, already included in the payload total
  4. Burn rate: 168,233 liters per minute
  5. Average speed: 1500 kilometers/hr

### The rocket launch system is comprised of 4 stages, which must happen in this precise order:

  1. Enable stage 1 afterburner
  2. Disengaging release structure
  3. Cross-checks
  4. Launch

### Active mission controls:

  1. Manually transition between launch stages in the expected order
  2. The commander should be able to safely abort launch after stage 1 and retry
  3. One in every 3rd launch will require an abort and retry after stage 1 (random)
  4. One in every 5th launch will explode (random)

### Necessary instrumentation information to be provided at the end of each mission:

  1. Total distance traveled (if aborted this would be 0, if exploded, pick a random spot in the timeline).
  2. Total travel time (same as above)

### Final Summary to be provided at end of all attempted missions (for all missions combined):

  1. Total distance traveled
  2. Number of abort and retries
  3. Number of explosions
  4. Total fuel burned
  5. Total flight time

## Install dependencies

The first time, you must install `ruby 3.3.4` and the `gem bundler`, so you can run `bundle install` to install all dependencies.

## Start the game

The game can be started as an executable with `./game.rb play`.

> *Note: GitHub is expected to preserve the file permission, but if it doesn't, simply run `chmod +x game.rb` to make it executable.*

### Fast mode

You may notice that the game has a delay between steps to provide a better experience for the player, as they were really following the launch. You can remove this behavior with the param `--fast` or `-f` such as `./game.rb play -f`.

> *Note: You can run `./game.rb help play` to see the options for the command play or run just `./game.rb` to list the available commands.*

## How to play

The game is self-paced, just answer the questions and follow the flow.

In the beginning, the game will ask you the Commander's name (player name) and then will ask you to start a new mission.

### Start a new mission

Every time the player is asked to start a new mission, they can confirm it with "y" or reject it with "n".

On confirming to start a new mission, the game will require the mission name so it can start the 4 stages rocket launch system:

1. Engage afterburner
1. Release support structures
1. Perform cross-checks
1. Launch

The game will require your confirmation before performing each step.

If the player rejects the new mission, the Space Y Station Stats (all missions) are printed and the game ends.

#### Mission status

After launch, the Commander receives an update of the mission status every 1 second (30 seconds in the game) with the following information:
* Current fuel burn rate (liters/min)
* Current speed (km/h)
* Current distance traveled (km)
* Elapsed time
* Time to destination

#### Mission summary

At the end of the mission, even when it aborts and explodes, a mission summary is shown with the following information:

* Total distance traveled (km)
* Number of aborts/retries
* Number of explosions
* Total fuel burned (liters)
* Flight time

#### Space Y Station Statistics (all missions)

When the player ends the game the Space Y Station Statistics are printed with the following information:

* Number of missions (Total)
* Number of Complete missions
* Number of Aborted missions
* Number of Exploded missions
* Number of Skipped missions (player didn't retry after abort)
* Total distance traveled (km)
* Number of abort and retries
* Total fuel burned (liters)
* Total flight time

### Interrupt game flow

You can type `Ctrl+C` any time to interrupt the game flow, which depending on the current stage will:

* **Simply end the game**: When interrupted before confirm player name.
* **Ask to abort the mission**: When interrupted after Engage afterburner and before Launch.
* **Ask to start a new mission**: When interrupted at any other moment.

### Abort mission

The mission can be aborted in two ways:

1. **Manually**: Interrupting the game after engaging afterburner and before launch. In this case, a confirmation will be required before aborting, and if the commander decides to not abort, the flow continues from where it was interrupted.
1. **Automatically**: The game is required to randomly abort one in every 3 missions. It doesn't require confirmation.

In both cases, after aborting, the user will have the option to retry the same mission. If so, the mission restarts from the first step, otherwise, the player will be asked to start a new mission.

> *Note: When the mission is automatically aborted, it can abort again after the retry. The same mission can be aborted up to 3 times.*

### Rocket Explosion

After launch the rocket can explode any time before achieving its destination. The game is required to explode "one in every 5th" mission and this is an end state, which means that the mission ends and a new mission can be started.

### Extra notes

The game is still far from simulating a real launch and its physical aspects. So the flight progress is linear and constant, meaning that it doesn't have acceleration or variations in terms of burn rate and velocity.

## Project Design

A quick design document describing the concept and the main classes can be found in [docs/solution_design.md](docs/solution_design.md).

###  Code Quality

#### Tests

The project uses RSpec and all the main behaviors are covered by tests. The tests can be run with `bundle exec rspec`.

All fakers and mocks were implemented without any extra gem. They seemed to be unnecessary for the purpose of this project at the beginning.

#### Coverage

The gem `simplecov` was added to the project to evaluate the code coverage, which is currently at 94%. To generate the code coverage report just run the rspec with the env var `COVERAGE=true`, as follows: `COVERAGE=true bundle exec rspec`

#### Rubocop

Rubocop was used to ensure the code was consistent with the style guide. It can be run with `rubocop` from the project root folder.

*Note: There are a few places in the code disabling some specific rules, as the refactoring would not be worth it at the moment. However, they are something I definitely would work on with more time.*

## Pending tasks and future implementations

There are a lot of aspects both in the code and in the user experience that I would like to improve with more time.

A TODO list can be extracted with the following command:

```
grep -rni '#\s*todo*' entities/* helpers/* spec/* game.rb  Gemfile initialize.rb .rubocop.yml
```

Moreover, If I could work on this project for more time, I would like to:

* Refactor the class Game to abstract the user interface/interactions from the game flow control, as described in [Game flow](docs/solution_design.md#Game-flow) topic. This refactoring itself would make the tests much better.
* Improve the specs, better organize examples, review fakers and mocks, to maybe replace them with fixtures and some faker/mocker gem.
* Review methods and variables to fix ambiguous names.
* Connect entities with some database to persist data.
