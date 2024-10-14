# Solution Design

This document briefly explains how this project technically addresses the requirements described in the [README](../README.md#game-specifications).

## Definition of Done

- Run as a CLI and flow like a text based game.
- Each mission follows the 4 stages order of the launch system.
- The player can transite manually between launch stages in the expected order.
- The game can safely abort launch after stage 1 and retry.
- Randomly one in every 3rd launch will require an abort and retry after stage 1
- Randomly one in every 5th launch will explode after launch.
- The player can play as many missions as they would like.
- At the end of each mission it output a summary of the mission.
- At the end of all missions it output the final summary.

*Don't mind about physics aspects. It doesn't intend to be a simulation.*

## Proposal

The project is organized into:
- `entities`: Folder with classes that handle data and represent entities with specific purposes.
- `helpers`: Folder with modules to support the player interactions.
- `spec`: Folder with the tests.
- `game.rb`: Main class responsible for the startup and game flow.

### Entities

The entities are classes responsible for data and that represent real entities with specific purposes. They are:

- `Station`: Represents the space station that takes care of all missions. It has a commander and many missions, but it doesn't take care of the mission's specific details.
- `Commander`: Represents the stations commander (the player).
- `Mission`: Represents the mission itself. It belongs to a Station and takes care of the travel, its params and indicators. It's also responsible for recording the travel indicators into the logbook, so it can be read later.
- `LogbookItem`: Represents a record in the logbook, which has the indicators in a specfic moment of the travel. The logbook belongs to a Mission and it's basically a list of LogbookItems.

Other classes such as `Rocket` and `Plan` could be included, but they would only store predefined attritutes (planned travel distance, payload and fuel capacity, burn rate and average speed), so it seems too much for now. The Mission is going to be responsible for these attributes.

Given its simplicity, the project doesn't require any database and all data are only in the instances. However, the classes are concebed to be connected to a database real quick when it's required.

The entities don't care about the game flow or know the interfaces (they even believe they are living a real life).

### Game flow

The `Game` class is resposible for orchestrating the game flow and user interactions. It uses Thor to deal with the user interactions, as it's easy to colorize the output and request user information. The helper modules provide methods to keep the code clean and organized.

> Note: The initial idea was to completely abstract the interface interactions into another module with its specifc classes, so entities and interfaces would not know about each other and the `Game` would use both. However, the game flow is too much coupled on the interfaces, what would make that abstraction unnecessarily complex. The approach with helpers is enough to make the code clean, readable and testable for this project purpose.
