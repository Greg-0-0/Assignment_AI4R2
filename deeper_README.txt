# Assignment D3-V1: Warehouse Robotics – Single Robot Pick-and-Deliver - AI4R2
The assignment required to model a warehouse environment using PDDL lagnuage. 
The scenario had to feature a single mobile robot capable of picking up packages and delivering them to predefined locations.


The implementation comprises two separate models.

## PDDL model
The domain was implemented using basic pddl tools to provide simple navigation capabilites of 
a multi-structured environment, and package manipulation for pick-up and drop-off actions.

### Predicates
- 'at' and 'package-at' provide an explicit representation of both the robot and the package position.
- 'free' and 'holding' ensure that the robot can pick up only one package at a time, and show which package is being currently carried. Even though they may seem redundant, both are necessary. Indeed, using only the first one wouldn't provide information on the package taken, while the second predicate alone wouldn't prevent a robot, already carring a package, from picking up a different one.
- 'connected' helps to define the warehouse structure, which can be designed at will.
- 'goal-location' allows to clearly state the final destination for each package, while 'delivered' avoids multiple dispatches for the same package. In a problem initialisation phase, the 'goal-location' predicate has to be set for each existing package to ensure the planner takes all of them into account. // tries to deliver all of them, obviously it's not assured it will succeed (problem may be non-solvable)

### Actions
- 'move' allows the robot to navigate between locations connected to the current one. The action doesn't permit to jump locations, and it is not symmetrical by default.
- 'pick-up' and 'drop-off' explicitly implement package manipulation, securing the robot can hold only one item at a time.

It is assumed that the robot can take or leave packages only when it is not moving, however, since actions are instantaneous, it is not necessary to model this dynamic.

## PDDL problems
The model was tested in two different scenarios:
- Single package delivery: the only constraint to the robot action is the necessity to have connections between locations to move around.
- Multiple packages with sequential delivery: in addition to the limitation of the previous problem, in this case, the planner requires an higher decisional flexibility, having to redefine its main goal, as the package that needs to be delivered changes. // robot changes location of destination after delivering a package, usually choosing the closest parcel

The PDDL domain structure allows to find a plan for problems with any amount of packages to be delivered.

## PDDL+ model
This domain, in addition to the characteristics of the previous one, models time for the robot motion to simulate 
missed deadlines in package distribution. 
This is achieved employing PDDL+ tools such as processes and events, which make the action of moving
not instantaneous anymore, and by splitting the robot movement in two steps.

### Predicates
Supplementary to those dispalyed in the previous design:
- 'moving' and 'transiting' are used to correctly carry out the movement action, ensuring it is not immediate anymore. In particular, the first predicate is used to trigger the process that simulates the passage of time, as well as preventing the robot from picking up or dropping off items during motion. Indeed, in a real scenario, it would be natural to assure that these operations are executed safely. The second one is used to link the two actions that make up the motion of the robot, more precisely they gurantee that the rooms used in the first step are also those used in the second one, otherwise the robot might be able to move to room not directly connected to the initial one, thus teleporting itself.
- 'overdue' serves the purpose to notify if a package has been delivered beyond its deadline.

### Functions
Fluents added to model the time spent during transportation and deadlines:
- 'elapsed-time' tracks the global time which is necessary to identify delays.
- 'travel-time' represents the amount of time necessary to move from one location to another.
- 'move-progress' keeps track of the robot's movement between two locations.
- 'deadline' defines for each package the time limit, with respect to 'elapsed-time' = 0, within which the delivery must be conlcuded.

### Processes
They allow to change the fluents value linearly with time:
- 'time-passage' models the passage of global time itself, which is used to trigger delays when deadlines are not met.
- 'move-process' simulates the progression of the robot's movement between two sections by increasing the 'move-progress' value.

### Actions
Conceptually, they are the same as those of the previous domain, but there are some changes due to the introduction of time:
- 'pick-up' and 'drop-off' now can be executed only when the robot is not moving.
- 'start-move' and 'finish-move' define the two steps of robot motion. The sequence of action is controlled by 'move-progress', which, after 'start-move' executes, is linearly increased with time by the process 'moving-process'. Once the threshold 'travel-time' is reached, 'finish-move' executes, allowing the robot to pick-up/drop-off objects or move again.

### Effect
'deadline-missed' sets a package as 'overdue' if it has not been delivered within its deadline. Depending on the problem definition this may cause it to be unsolvable (in some cases it may be acceptable to have parcels arrive late at destination).

## PDDL+ problem
A problem file has been defined to test the domain, to do so it is necessary to initialise all the fluent values at the beginning:
- the time required to travel between each couple of communicating locations (it can be different for each pair to generate various types of maps).
- the initial global time value (usually zero).
- the deadline for each package defined in the problem (the value is to be considered relative to the global time).

Obviously, the robot is initially halted, so the 'moving' predicate must be omitted.
Concerning the objectives, the robot has to deliver all packages within the corresponding time limit. However, it is also possbile to simplify the goal, and leave out the deadlines.

## Discussion
The current model presents various limitations:
- scalability in multiple packages problems, which, when implemented, require the robot to repeat the navigation process several times, hence possibly generating conflicts between shipments, missed deadlines, and inefficient delivery order. In this case planning complexity grows rapidly, action sequences become much longer, and deadlines are harder to satisfy.
- inability to perform non-sequential actions preventing the system from implementing a variety of additional features such as simulatneous deliveries, parallel robot movement and coordinated behavior. Indeed, in a real scenario a warehouse usually allows a rather high degree of concurrency with actions like charging while waiting, or multiple couriers working simultaneously.

To overcome these constraints, the domain can be upgraded:
- several robots with parallel functioning
- loading multiple packages

However, these changes, to be in line with reality, must be followed by additional modifications that further increase the complexity of the model. Some of them may be:
- modelling the maximum payload and space capacity of a robot, and what to do in case these thresholds are reached, for example other robots may take care of the packages left unattended.
- defining a virtual map for every robot to keep track of the destination of each package that has been picked up. This could also be paired with a route optimization algorithm, for instance to cluster the delivery of nearby packages.
- synchronizing robot movements to avoid collisions. As in the previous point, also in this case each robot would need a virtual representation of the positions of all the other workers.


// -- -- -- -- //

• scalability from single to multiple packages: multiple capacity (weight limitation and local database) or multiple robots (sinchronyzation problem)
• limitations of purely sequential planning: deadlines -> multiple robots for parallel delivery (sinchronyzation problem)

// how is the readme: is it too explanatory? need to put less info in the readme and more in the comments?
// how are the domains: is the movement explicit(move)? and the problems