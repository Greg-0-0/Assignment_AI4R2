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
    d1 - destination
    d2 - destination
)

(:init
    (at r l1) ; Robot starts at location l1
    (free r) ; Robot starts free (not holding any package)
    (stored p1 l2) ; Package p1 is at location l2
    (has p1 d1) ; Package p1 is destined for destination d1
    (stored p2 l3) ; Package p2 is at location l3
    (has p2 d2) ; Package p2 is destined for destination d2
    (stored p3 l2) ; Package p3 is at location l2
    (has p3 d1) ; Package p3 is destined for destination d1
    (labeled l5 d1) ; Location l5 is labeled as destination d1
    (labeled l4 d2) ; Location l4 is labeled as destination d2
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
    (delivered p1 d1) ; Package p1 has been delivered to destination d1
    (delivered p2 d2) ; Package p2 has been delivered to destination d2
    (delivered p3 d1) ; Package p3 has been delivered to destination d1
))

)
