;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |triangle fractal|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)

(define image (rectangle 30 20 "outline" "red"))
(define tri(above image (beside image image)))

;(define (mouse-h image x y event)
;(overlay (isotri image) image))

(define (isotri image)
  (isosceles-triangle (image-height image) (image-width image) "solid" "red"))
;check-expect
;(check-expect(key-h pic:stick-figure "x") 

(define (key-h image key)
  (scale 0.5(above (above image (beside image image))
                   (beside (above image (beside image image))(above image (beside image image))))))

(define (bg image)
  (overlay image (square 500 "solid" "white")))

(big-bang image
  (on-draw bg)
  ; (on-mouse mouse-h)
  (on-key key-h))
