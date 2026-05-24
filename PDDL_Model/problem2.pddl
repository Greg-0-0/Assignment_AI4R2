(define (problem problem2) (:domain Single_Robot_Pick-and-Deliver)
(:objects 
    r - robot
    p1 - package
    p2 - package
    p3 - package
    l1 - location
    l2 - location
    l3 - location
    l4 - location
    l5 - location
)

(:init
    (at r l1) ; Robot starts at location l1
    (free r) ; Robot starts free (not holding any package)

    (package-at p1 l1) ; Package p1 is at location l1
    (package-at p2 l3) ; Package p2 is at location l3
    (package-at p3 l2) ; Package p3 is at location l2
    (goal-location p1 l2)
    (goal-location p2 l4)
    (goal-location p3 l5)

    (connected l1 l2) ; Location l1 is connected to location l2
    (connected l2 l1) ; Location l2 is connected to location l1
    (connected l2 l3) ; Location l2 is connected to location l3
    (connected l3 l2) ; Location l3 is connected to location l2
    (connected l3 l4) ; Location l3 is connected to location l4
    (connected l4 l3) ; Location l4 is connected to location l3
    (connected l4 l5) ; Location l4 is connected to location l5
    (connected l5 l4) ; Location l5 is connected to location l4
)

(:goal (and
    (delivered p1) ; Package p1 has been delivered
    (delivered p2) ; Package p2 has been delivered
    (delivered p3) ; Package p3 has been delivered
))

)
