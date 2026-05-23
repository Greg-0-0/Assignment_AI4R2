;Header and description

(define (domain Single_Robot_Pick-and-Deliver)

;remove requirements that are not needed
(:requirements :strips :typing :negative-preconditions :disjunctive-preconditions)

(:types package location destination robot)

(:predicates 
    (at ?r - robot ?l - location) ; Robot r is at location l
    (free ?r - robot) ; Robot r is free (not holding any package)
    (connected ?l1 - location ?l2 - location) ; Location l1 is connected to location l2
    (stored ?p - package ?l - location) ; Package p is at location l
    (has ?p - package ?d - destination) ; Package p is destined for destination d
    (labeled ?l - location ?d - destination) ; Location l is labeled as destination d
    (delivered ?p - package ?d - destination) ; Package p has been delivered to its destination (assuming it's only one destination per package)
    (holding ?r - robot ?p - package) ; Robot r is holding package p
)


; Example action for picking up a package
(:action pick-up
    :parameters (?r - robot ?p - package ?l - location ?d - destination)
    :precondition (and 
        (at ?r ?l) 
        (stored ?p ?l)
        (free ?r) ; Robot is free (not holding any package) -> otherwise it may be already holding another package
        (has ?p ?d) ; Package has a destination -> otherwise it may be an irrelevant package, also it ensures actions matche correct package-destination pairs
        (not (holding ?r ?p)) ; Robot can hold only one package at a time
        (not (delivered ?p ?d)) ; Package cannot be picked up if it's already delivered
    )
    :effect (and 
        (not (stored ?p ?l)) 
        (holding ?r ?p)
        (not (free ?r))
    )
)

; Example action for delivering a package
(:action drop-off
    :parameters (?r - robot ?p - package ?d - destination ?l - location)
    :precondition (and 
        (at ?r ?l)
        (labeled ?l ?d) ; Robot must be at a location labeled as the package's destination
        (holding ?r ?p)
        (has ?p ?d)
    )
    :effect (and 
        (not (holding ?r ?p)) 
        (delivered ?p ?d) ; Mark the package as delivered to its destination
        (free ?r) ; Robot is now free (not holding any package)
        (stored ?p ?l) ; After delivery, the package is considered stored at the destination location
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