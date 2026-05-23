(define (problem problem1) (:domain Single_Robot_Pick-and-Deliver)
(:objects 
    r - robot
    p - package
    l1 - location
    l2 - location
    l3 - location
    l4 - location
    l5 - location
    d - destination
)

(:init
    (at r l1) ; Robot starts at location l1
    (free r) ; Robot starts free (not holding any package)
    (stored p l2) ; Package p is at location l2
    (has p d) ; Package p is destined for destination d
    (labeled l5 d) ; Location l5 is labeled as destination d
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
    (delivered p d) ; Package p has been delivered to destination d
))

)
