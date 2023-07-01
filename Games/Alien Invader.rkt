;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |Alien Invader|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)

(define bg
  (rectangle 400 300 "solid" "black"))

(define-struct alien (p d))

(define alien-image
  (scale 0.05 (bitmap "Space-Invaders-Alien-Transparent-Background-PNG.png")))

(define(draw-h alien)
  (place-image alien-image
               (posn-x (alien-p alien))
               (posn-y (alien-p alien))
               bg))

(define(tick-h alien)
  (cond [(and (string=? (alien-d alien) "left") (= (posn-x (alien-p alien)) 400)
          [(string=? (alien-d alien) "left")
           (make-alien (make-posn (- (posn-x (alien-p alien)) 5) (posn-y (alien-p alien))) (should-change-direction? alien))]
          [(string=? (alien-d alien) "right")
           (make-alien (make-posn (+ (posn-x (alien-p alien)) 5) (posn-y (alien-p alien))) (should-change-direction? alien))]
          [else alien]))

(define(key-h alien key)
  (cond[(key=? "right" key)
        (make-alien (make-posn (+ 5 (posn-x (alien-p alien)))(posn-y (alien-p alien))) (alien-d alien))]
       [(key=? "left" key)
        (make-alien (make-posn (- (posn-x (alien-p alien)) 5) (posn-y (alien-p alien))) (alien-d alien))]
       [else alien]))

(define(should-change-direction? alien)
  (cond[(= (posn-x (alien-p alien)) 400) "left"]
       [(= (posn-x (alien-p alien)) 0) "right"]
       [else (alien-d alien)]))

(big-bang (make-alien (make-posn 0 10) "right")
  (on-tick tick-h)
  (on-draw draw-h))