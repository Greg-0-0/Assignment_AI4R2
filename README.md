# Assignment D3-V1: Warehouse Robotics – Single Robot Pick-and-Deliver - AI4R2

This repository models a warehouse environment in PDDL and PDDL+ for a single mobile robot that picks up packages and delivers them to predefined destinations.

The implementation contains two domains: a basic PDDL domain (navigation + manipulation) and an extended PDDL+ domain (adds time, processes and events for deadlines).

## PDDL model

The basic domain implements explicit movement and package manipulation.

- **Key predicates:** `at`, `package-at`, `free`, `holding`, `connected`, `goal-location`, `delivered`.
- **Core actions:** `move`, `pick-up`, `drop-off`.

Notes:
- `move` is explicit and only allowed between `connected` locations (no teleporting).
- `free` + `holding` together ensure the robot carries at most one package while also tracking which package is carried.

### Problems
- `problem1.pddl`: single-package delivery test.
- `problem2.pddl`: multiple packages requiring sequential deliveries.

The domain supports arbitrary numbers of packages, but plan length and complexity grow with problem size.

## PDDL+ model

The PDDL+ domain extends the basic model by implementing time-dependent movement via processes and events, enabling deadline checks.

- **Additional predicates:** `moving`, `transiting`, `overdue`.
- **Numeric fluents:** `elapsed-time`, `travel-time`, `move-progress`, `deadline`.
- **Processes:** `time-passage` (global time) and `moving-process` (progress while moving).
- **Actions:** split motion into `start-move` and `finish-move`; `pick-up`/`drop-off` require the robot not to be `moving`.
- **Event:** `deadline-missed` marks packages `overdue` when `elapsed-time` exceeds their `deadline`.

### PDDL+ problem
See `PDDL+_Model/problem.pddl` for an example initialisation: travel times, deadlines and initial `elapsed-time` are set in the problem file. The example goal requires delivery without being `overdue`.
The problem can be configured with different travel times and deadlines, allowing to test both feasible and unfeasible scenarios.

## Discussion

Strengths:
- Clear separation of navigation and manipulation, making the basic domain easy to reason about.
- PDDL+ model captures temporal behaviour and deadlines using processes/events.

Limitations:
- **Scalability:** Plans grow rapidly with multiple packages since a single robot has to perform all deliveries in sequence; this increases search complexity and likelihood of missed deadlines.
- **Sequential-only behaviour:** The single-robot, single-package-capacity assumption prevents concurrency (simultaneous deliveries, parallel robot actions).

Possible extensions:
- Add multiple robots (requires synchronization and collision avoidance).
- Support carrying multiple packages (introduce capacity/weight constraints and local storage state).
- Add route optimization or local planning to cluster nearby deliveries and reduce elapsed time.

## Files
- PDDL model: [PDDL_Model/domain.pddl](PDDL_Model/domain.pddl)
- PDDL problems: [PDDL_Model/problem1.pddl](PDDL_Model/problem1.pddl), [PDDL_Model/problem2.pddl](PDDL_Model/problem2.pddl)
- PDDL problem outputs: [PDDL_Model/outputs.txt](PDDL_Model/outputs.txt)
- PDDL+ model: [PDDL+_Model/domain.pddl](PDDL+_Model/domain.pddl)
- PDDL+ problems: [PDDL+_Model/problem.pddl](PDDL+_Model/problem.pddl), [PDDL+_Model/problem2.pddl](PDDL+_Model/problem2.pddl)
- PDDL+ problem outputs: [PDDL+_Model/outputs.txt](PDDL+_Model/outputs.txt)
- Assignment Report: [AI4R2AssignmentReport](AI4R2AssignmentReport.pdf)
- README file