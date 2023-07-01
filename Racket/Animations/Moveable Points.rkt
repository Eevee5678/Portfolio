;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |Moveable Points|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)

(define(dist x1 x2 y1 y2)
  (sqrt (+ (sqr (- x1 x2)) (sqr (- y1 y2)))))

(define RED-RADIUS 50)
(define BLUE-RADIUS 40)

(define-struct G (red-pt blue-pt active))

(define (maybe-halo drawing active)
  (cond[(and (string=? active "red") (string=? drawing active)) (overlay (circle RED-RADIUS "solid" "red") (circle (+ 10 RED-RADIUS) "solid" "yellow"))]
       [(and (string=? active "blue") (string=? drawing active)) (overlay (circle BLUE-RADIUS "solid" "blue")(circle (+ 10 BLUE-RADIUS) "solid" "yellow"))]
       [(and (string=? active "red") (not (string=? drawing active))) (circle BLUE-RADIUS "solid" "blue")]
       [(and (string=? active "blue") (not (string=? drawing active))) (circle RED-RADIUS "solid" "red")]
       [(and (string=? drawing "blue") (string=? active "none")) (circle BLUE-RADIUS "solid" "blue")]
       [(and (string=? drawing "red") (string=? active "none")) (circle RED-RADIUS "solid" "red")]))

(define (draw-game G)
  (place-image (maybe-halo "blue" (G-active G))
               (posn-x (G-blue-pt G))
               (posn-y (G-blue-pt G))
               (place-image (maybe-halo "red" (G-active G))
                            (posn-x (G-red-pt G)) (posn-y (G-red-pt G)) (empty-scene 500 300))))

(define(key-h G key)
  (cond[(key=? "q" key) (exit)]
       [(key=? "r" key) (make-G (G-red-pt G) (G-blue-pt G) "red")]
       [(key=? "b" key) (make-G (G-red-pt G) (G-blue-pt G) "blue")]
       [(key=? " " key) (make-G (G-red-pt G) (G-blue-pt G) "none")]
       [else G]))

(define(mouse-h G x y event)
  (cond[(and (string=? event "button-down") (<= (dist x (posn-x (G-red-pt G)) y (posn-y (G-red-pt G))) RED-RADIUS))
        (make-G (G-red-pt G) (G-blue-pt G) "red")]
       [(and (string=? event "drag") (<= (dist x (posn-x (G-red-pt G)) y (posn-y (G-red-pt G))) RED-RADIUS))
        (make-G (make-posn x y) (G-blue-pt G) "red")]
       [(and (string=? event "button-down") (<= (dist x (posn-x (G-blue-pt G)) y (posn-y(G-blue-pt G))) BLUE-RADIUS))
        (make-G (G-red-pt G) (G-blue-pt G) "blue")]
       [(and (string=? event "drag") (<= (dist x (posn-x (G-blue-pt G)) y (posn-y(G-blue-pt G))) BLUE-RADIUS))
        (make-G (G-red-pt G) (make-posn x y) "blue")]
       [(and (string=? event "button-down") (and (>= (dist x (posn-x (G-red-pt G)) y (posn-y(G-red-pt G))) RED-RADIUS)
                                                 (>= (dist x (posn-x (G-blue-pt G)) y (posn-y(G-blue-pt G))) BLUE-RADIUS)))
        (make-G (G-red-pt G) (G-blue-pt G) "none")]
       [else G])) 

(big-bang (make-G (make-posn 100 100) (make-posn 200 250) "none")
  (on-draw draw-game)
  (on-key key-h)
  (on-mouse mouse-h))