;Header and description

(define (domain Single_Robot_Pick-and-Deliver)

;remove requirements that are not needed
(:requirements :strips :typing :negative-preconditions :disjunctive-preconditions)

(:types package location destination robot)

(:predicates
    (at ?r - robot ?l - location) ; Robot r is at location l
    (free ?r - robot) ; Robot r is free (not holding any package)
    (connected ?l1 - location ?l2 - location) ; Location l1 is connected to location l2
    (package-at ?p - package ?l - location) ; Package p is at location l
    (goal-location ?p - package ?l - location) ; Package p has a goal location l
    (delivered ?p - package) ; Package p has been delivered to its destination (assuming it's only one destination per package)
    (holding ?r - robot ?p - package) ; Robot r is holding package p
)


; Example action for picking up a package
(:action pick-up
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (at ?r ?l) 
        (package-at ?p ?l)
        (free ?r) ; Robot is free (not holding any package) -> otherwise it may be already holding another package
        (not (holding ?r ?p)) ; Robot can hold only one package at a time, also prevents picking up the same package multiple times and provide info on package location
        (not (delivered ?p)) ; Package cannot be picked up if it's already delivered
    )
    :effect (and 
        (not (package-at ?p ?l)) 
        (holding ?r ?p)
        (not (free ?r))
    )
)

; Example action for delivering a package
(:action drop-off
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (at ?r ?l)
        (holding ?r ?p)
        (goal-location ?p ?l) ; Robot must be at the package's goal location to deliver it
        (not (delivered ?p)) ; Package cannot be delivered if it's already delivered
        (not (free ?r)) ; Robot must be holding a package to drop it off
    )
    :effect (and 
        (not (holding ?r ?p)) 
        (delivered ?p) ; Mark the package as delivered to its destination
        (free ?r) ; Robot is now free (not holding any package)
        (package-at ?p ?l) ; After delivery, the package is considered at the destination location
    )
)

; Example action for moving the robot from one location to another
(:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and
        (at ?r ?from)
        (connected ?from ?to)
    )
    :effect (and 
        (not (at ?r ?from)) 
        (at ?r ?to)
    )
)

)