;Header and description

(define (domain Single_Robot_Pick-and-Deliver_with-Deadlines)

;remove requirements that are not needed
(:requirements :strips :typing :negative-preconditions :disjunctive-preconditions :time :numeric-fluents :durative-actions)

(:types package location destination robot)

(:predicates 
    (at ?r - robot ?l - location) ; Robot r is at location l
    (free ?r - robot) ; Robot r is free (not holding any package)
    (connected ?l1 - location ?l2 - location) ; Location l1 is connected to location l2
    (package-at ?p - package ?l - location) ; Package p is at location l
    (goal-location ?p - package ?l - location) ; Package p has a goal location l
    (delivered ?p - package) ; Package p has been delivered to its destination (assuming it's only one destination per package)
    (overdue ?p - package) ; Package p has missed its deadline
    (holding ?r - robot ?p - package) ; Robot r is holding package p
)

(:functions         
    (elapsed-time) ; Numeric fluent to track total elapsed time
    (deadline ?p - package) ; Numeric deadline assigned per package in the problem file
)



; Example action for picking up a package
(:action pick-up
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (at ?r ?l) 
        (package-at ?p ?l)
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

; Example action for delivering a package. Packages can be delivered even if they are overdue, but the goal is to minimize elapsed time to avoid that.
(:action drop-off
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (at ?r ?l)
        (goal-location ?p ?l) ; Robot must be at a location that is the package's goal location to deliver it
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

; Example action for moving the robot from one location to another
(:durative-action move
    :parameters (?r - robot ?from - location ?to - location)
    :duration (= ?duration 5)
    :condition (and 
        (at start (at ?r ?from))
        (over all (connected ?from ?to))
    )
    :effect (and 
        (at start (not (at ?r ?from)))
        (at end (at ?r ?to))
        (at end (increase (elapsed-time) 5))
    )
)

; Event to mark a package as overdue once time has passed its deadline
(:event deadline-missed
    :parameters (?p - package)
    :precondition (and
        (> (elapsed-time) (deadline ?p))
        (not (overdue ?p))
    )
    :effect (overdue ?p)
)
)