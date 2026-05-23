(define (problem problem1-deadlines) (:domain Single_Robot_Pick-and-Deliver_with-Deadlines)
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
    (at r l1)
    (free r)
    (stored p l2)
    (has p d)
    (labeled l5 d)
    (connected l1 l2)
    (connected l2 l1)
    (connected l2 l3)
    (connected l3 l2)
    (connected l3 l4)
    (connected l4 l3)
    (connected l4 l5)
    (connected l5 l4)

    (= (elapsed-time) 0)
    (= (deadline p) 6)
)

(:goal (and
    (delivered p d)
))

(:metric minimize (elapsed-time))
)
