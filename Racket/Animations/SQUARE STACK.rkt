;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |SQUARE STACK|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)

;key-h: model event => model

;check-expects
;(check-expect (key-h model r)

;variable
(define model (square 20 "outline" "black"))

;Key-handler
(define (key-h model key)
  (cond((key=? key "x")
        (above model (square 20 "outline" "black")))
        (else
         model)))

;Tick-handler
(define (tick-h model)
  (crop-top model 20))

;Animation
(big-bang model
  (on-draw show-it 500 500)
  (on-key key-h)
  (on-tick tick-h 1))