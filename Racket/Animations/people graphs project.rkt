;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |people graphs project|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)

(define dot
  (circle 10 "solid" "red"))

(define(f x)
  (* 10(cos (* 2 x))))

;(0,-pi) and (400,2pi) -> 3pi/400 (y-intercept is -pi (0,-pi))
(define (xctxp x)
  (- (*(/ (* 3 pi)400)x)pi))

(check-within (xctxp 0)-3.14159 0.01)
(check-within(xctxp 400)(* 2 3.14159) 0.01) 

;(15,0) and (0,100) -> -20/3 (x-intercept is 100 (0, 100))
(define (yptyc y)
  (+ (*(/ -20 3)y) 100))

(check-expect(yptyc 15)0)
(check-expect(yptyc 0)100)

(define quadrant1
  (rectangle 400/3 100 "outline" "black"))

(define quadrant2
  (rectangle 800/3 100 "outline" "black"))

(define axis
  (beside (above quadrant1 quadrant1)
          (above quadrant2 quadrant2)))

(define(draw-h xcomputer)
  (place-image dot xcomputer (yptyc (f (xctxp xcomputer))) axis))

(define(tick-h xcomputer)
  (remainder (+ 1 xcomputer) 400))

(big-bang 0
  (on-draw draw-h)
  (on-tick tick-h))


