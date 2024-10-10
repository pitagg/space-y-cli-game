# Space Y CLI Game

Can you command the launch of a rocket into Earth's orbit without blowing it up? That's your mission in this Command Line Interface (CLI) game.

## Specifications

### You will be responsible for conducting the flight into low earth orbit:

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
