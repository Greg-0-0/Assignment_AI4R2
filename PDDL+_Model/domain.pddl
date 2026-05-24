;Header and description

(define (domain Single_Robot_Pick-and-Deliver_with-Deadlines)

;remove requirements that are not needed
(:requirements :strips :typing :negative-preconditions :disjunctive-preconditions :time :numeric-fluents)

(:types package location destination robot)

(:predicates 
    (at ?r - robot ?l - location) ; Robot r is at location l
    (free ?r - robot) ; Robot r is free (not holding any package)
    (moving ?r - robot) ; Robot r is currently moving between locations
    (transiting ?r - robot ?from - location ?to - location) ; Robot r is currently moving from location ?from to location ?to
    (connected ?l1 - location ?l2 - location) ; Location l1 is connected to location l2
    (package-at ?p - package ?l - location) ; Package p is at location l
    (goal-location ?p - package ?l - location) ; Package p has a goal location l
    (delivered ?p - package) ; Package p has been delivered to its destination (assuming it's only one destination per package)
    (overdue ?p - package) ; Package p has missed its deadline
    (holding ?r - robot ?p - package) ; Robot r is holding package p
)

(:functions         
    (elapsed-time) ; Numeric fluent to track total elapsed time
    (travel-time ?from - location ?to - location) ; Numeric fluent to represent the time it takes to travel from one location to another
    (move-progress ?r - robot) ; Numeric fluent to represent the progress of the robot's movement between locations (0 to travel-time)
    (deadline ?p - package) ; Numeric deadline assigned per package in the problem file
)

; Process to model the passage of time, which is necessary for the action-delay event to function properly
(:process time-passage
    :parameters (?r - robot)
    :precondition 
        (>= (elapsed-time) 0) ; Always true, but ensures the process is active
    :effect
        (increase (elapsed-time) (* #t 1)) ; Increase elapsed time by 1 unit per time unit
)

; The idea is that the robot goes from one specific point of a location l1 to another specific point of a location l2, 
; this movement is what takes time. The position reached by the robot in any location could be considered the station
; where the actual pick-up or drop-off actions take place, and the robot can only pick up or drop off packages when 
; it is at that station. These specific locations don't need to be modeled explicitly, after all picking up or
; dropping off a package can only be done when the robot is at the location, so we can assume that 
; the robot is at the station when it is at the location. Furthermore, the robot cannot executing pick-up or 
; drop-off actions while it is moving.
; This way, the action-delay process is activated when the robot starts moving from one location to another, 
; and deactivated when it arrives at the destination, allowing the elapsed time to increase during the movement and trigger the deadline-missed event if the deadline is exceeded.


; Process to model the robot's movement between locations, which takes time and can lead to missing deadlines
(:process moving-process
    :parameters (?r - robot)

    :precondition (moving ?r)

    :effect
        (increase (move-progress ?r) (* #t 1))
)

; Action for picking up a package
(:action pick-up
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (at ?r ?l) 
        (package-at ?p ?l)
        (not (moving ?r)) ; Robot cannot pick up a package while it is moving
        (free ?r) ; Robot is free (not holding any package) -> otherwise it may be already holding another package
        (not (holding ?r ?p)) ; Robot can hold only one package at a time
        (not (delivered ?p)) ; Package cannot be picked up if it's already delivered
    )
    :effect (and 
        (not (package-at ?p ?l)) 
        (holding ?r ?p)
        (not (free ?r))
    )
)

; Action for delivering a package. Packages can be delivered even if they are overdue, but the goal is to minimize elapsed time to avoid that.
(:action drop-off
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (at ?r ?l)
        (goal-location ?p ?l) ; Robot must be at a location that is the package's goal location to deliver it
        (not (moving ?r)) ; Robot cannot drop off a package while it is moving
        (holding ?r ?p)
        (not (delivered ?p)) ; Package cannot be delivered if it's already delivered
    )
    :effect (and 
        (not (holding ?r ?p)) 
        (delivered ?p) ; Mark the package as delivered
        (free ?r) ; Robot is now free (not holding any package)
        (package-at ?p ?l) ; After delivery, the package is considered at the destination location
    )
)

; Action to start moving the robot from one location to another, which activates the moving-process and allows time to pass during the movement
(:action start-move
    :parameters (?r - robot ?from - location ?to - location)

    :precondition (and
        (at ?r ?from)
        (connected ?from ?to)
        (not (moving ?r))
    )

    :effect (and
        (moving ?r)
        (transiting ?r ?from ?to)
        (not (at ?r ?from))
        (assign (move-progress ?r) 0)
    )
)

; Action to finish moving the robot from one location to another, which deactivates the moving-process and updates the robot's location
(:action finish-move
    :parameters (?r - robot ?from - location ?to - location)

    :precondition (and
        (moving ?r)
        (transiting ?r ?from ?to)
        (>= (move-progress ?r) (travel-time ?from ?to))
    )

    :effect (and
        (at ?r ?to)
        (not (transiting ?r ?from ?to))
        (not (moving ?r))
    )
)

; Event to mark a package as overdue once time has passed its deadline
(:event deadline-missed
    :parameters (?p - package)
    :precondition (and
        (>= (elapsed-time) (deadline ?p))
        (not (delivered ?p))
        (not (overdue ?p))
    )
    :effect (overdue ?p)
)
)