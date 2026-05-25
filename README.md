# Assignment D3-V1: Warehouse Robotics – Single Robot Pick-and-Deliver - AI4R2
The assignment required to model a warehouse environment using PDDL lagnuage. The scenario had to feature a single mobile robot capable of picking up packages and delivering them to predefined locations.


The implementation comprises two separate models.

## PDDL model
The domain was implemented using basic pddl tools to provide simple navigation capabilites of a multi-structured environment, and package manipulation for pick-up and drop-off actions.

### Predicates
- 'at' and 'package-at' provide an explicit representation of both the robot and the package position.
- 'free' and 'holding' ensure that the robot can pick up only one package at a time, and show which package is being currently carried. Even though they can seem redundant, using only the first one wouldn't provide information on the package taken, while the other alone wouldn't prevent a robot already carring a package, from picking up a different one.
- 'connected' helps to define the warehouse structure, and it can be built differently for any type of problem.
- 'goal-location' allows to clearly state the final destination for each package, while 'delivered' avoids multiple dispatches for the same package. In a problem initialisation phase, the 'goal-location' predicate has to be set for each existing package to ensure the planner takes all of them into account. // tries to deliver all of them, obviously it's not assured it will succeed (problem may be non-solvable)

### Actions
- 'move' allows the robot to navigate between locations connected to the current one. The action doesn't permit to jump locations, and it is not symmetrical by default.
- 'pick-up' and 'drop-off' explicitly implement package manipulation.

It is assumed that the robot can take or leave packages only when it is not moving, however, since actions are instantaneous, it is not necessary to model this dynamic.

## PDDL problems
The model was tested in two different scenarios:
- Single package delivery: the only constraint to the robot action is the necessity to have connections between locations to move around.
- Multiple packages with sequential delivery: in addition to the limitation of the previous problem, in this case, the planner requires an higher decisional flexibility, having to redefine its main goal, as the package that needs to be delivered changes.

- A PDDL+ model that, in addition to the previous features, introduces time for robot movements to simulate missed deadlines in package distribution.

// -- -- -- -- //

• scalability from single to multiple packages: multiple capacity (weight limitation and local database) or multiple robots (sinchronyzation problem)
• limitations of purely sequential planning: deadlines -> multiple robots for parallel delivery (sinchronyzation problem)

// how is the readme: is it too explanatory? need to put less info in the readme and more in the comments?
// how are the domains: is the movement explicit(move)? and the problems