(define (problem problem2-deadlines) (:domain Single_Robot_Pick-and-Deliver_with-Deadlines)
(:objects 
    r - robot
    p1 - package
    p2 - package
    l1 - location
    l2 - location
    l3 - location
    l4 - location
    l5 - location
)

(:init
    ; omitting moving -> false
    (at r l1)
    (free r)
    (= (move-progress r) 0)
    (= (travel-time l1 l2) 5)
    (= (travel-time l2 l1) 5)
    (= (travel-time l2 l3) 5)
    (= (travel-time l3 l2) 5)
    (= (travel-time l3 l4) 5)
    (= (travel-time l4 l3) 5)
    (= (travel-time l4 l5) 5)
    (= (travel-time l5 l4) 5)

    (package-at p1 l2)
    (package-at p2 l4)
    (goal-location p1 l5)
    (goal-location p2 l1)
    (= (deadline p1) 25) ; Earliest package must still be delivered quickly
    ;(= (deadline p) 20) ; Unsolvable problem with 'overdue' constraint
    (= (deadline p2) 45) ; Allows one-robot sequential delivery without overdue

    (connected l1 l2)
    (connected l2 l1)
    (connected l2 l3)
    (connected l3 l2)
    (connected l3 l4)
    (connected l4 l3)
    (connected l4 l5)
    (connected l5 l4)

    (= (elapsed-time) 0)
)

(:goal (and
    (delivered p1)
    (not (overdue p1))
    (delivered p2)
    (not (overdue p2))
))

(:metric minimize (elapsed-time))
)
