;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |Lights Out|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require picturing-programs)

(define lighton
  (circle 25 "solid" "yellow"))
(define tile
  (overlay (circle 25 "outline" "black") (square 50 "solid" "gray")))
(define row
  (beside tile tile tile tile tile))
(define bg
  (above row row row row row ))

;add multiply posn functions
(define (p-add p1 p2)
  (make-posn (+ (posn-x p1) (posn-x p2))
             (+ (posn-y p1) (posn-y p2))))

(check-expect (p-add (make-posn 1 5) (make-posn 2 4)) (make-posn 3 9))

(define (p-mult p1 p2)
  (make-posn (* (posn-x p1) (posn-x p2))
             (* (posn-y p1) (posn-y p2))))

(check-expect (p-mult (make-posn 1 5) (make-posn 2 4)) (make-posn 2 20))

;divide mouse-h value by __ to get rounded whole number of location (range 1-5)
(define (within? posn)
  (and (> (posn-y posn) 0) (< (posn-y posn) 6)
       (> (posn-x posn) 0) (< (posn-x posn) 6)))

(check-expect (within? (make-posn 5 1)) #true)
(check-expect (within? (make-posn 9 8)) #false)

;all possible flip values based off of 1 mouse click
(define (add-flip posn)
  (list posn (p-add posn (make-posn 1 0))
             (p-add posn (make-posn 0 1))
             (p-add posn (make-posn -1 0))
             (p-add posn (make-posn 0 -1))))

(check-expect (add-flip (make-posn 1 2)) (list (make-posn 1 2) (make-posn 2 2) (make-posn 1 3) (make-posn 0 2) (make-posn 1 1)))

;loop through and remove/keep flips until there are no more possible ones (if part of pre-existing list, gets rid of it)
(define (flip? li flips)
  (cond [(empty? flips) li]
        [else (cond [(member (first flips) li)
                     (flip? (remove (first flips) li)(rest flips))]
                    [else (flip? (append (list (first flips))li)(rest flips))])]))

(check-expect (flip? (make-posn 2 3) (list)) (make-posn 2 3))
(check-expect (flip? (list (make-posn 3 4) (make-posn 2 1)) (list (make-posn 1 2) (make-posn 2 2) (make-posn 1 3) (make-posn 0 2) (make-posn 1 1)))
              (list (make-posn 1 1)(make-posn 0 2)(make-posn 1 3)(make-posn 2 2)(make-posn 1 2)(make-posn 3 4)(make-posn 2 1)))

;loop based on list add yellow circles to new list to be updated with posns 
(define (circles li n)
  (cond [(empty? li) n]
        [else (circles (rest li) (append (list lighton) n))]))

;loop through list and multiply point by 50 to convert coordinates and subtract 25 (radius)to put img in center
(define (points li n)
  (cond [(empty? li) n]
        [else (points (rest li) (append n (list (p-add (make-posn -25 -25)(p-mult (first li) (make-posn 50 50))))))]))

;when mouse clicked takes in current list x y and event -> runs through flip function and converts coordinates
(define (mouse-h li x y event)
  (cond [(mouse=? "button-down" event) 
           (flip? li (add-flip (make-posn (ceiling(/ x 50)) (ceiling(/ y 50)))))]
        [else li]))

(define (place imgs posns)
  (place-images imgs posns bg))

;win if empty list, else keep looping
(define (draw-h li)
  (cond [(empty? li)
         (overlay (text 100 "YOU WIN!" "black") bg)]
        [else (place (circles li (list)) (points li (list)))]))

;random board posns
(define board
  (list (make-posn (+ 1(random 5))(+ 1(random 5)))(make-posn (+ 1(random 5)) (+ 1(random 5)))
        (make-posn (+ 1(random 5))(+ 1(random 5)))(make-posn (+ 1(random 5)) (+ 1(random 5)))))

(big-bang board
  (on-mouse mouse-h)
  (on-draw draw-h))