;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname bullseye) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)

(define model (circle 50 "outline" "black"))

(define (bullseye model x y event)
  (overlay model (scale 1.15 model)))

(define (key-h model key)
(scale 0.9 model))

(define (bg model)
  (overlay model(square 500 "solid" "white")))

(big-bang model
  (on-draw bg)
  (on-mouse bullseye)
  (on-key key-h))