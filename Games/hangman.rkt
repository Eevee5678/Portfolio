;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname hangman) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)

(define-struct hangman (word tries letter win))

(define step0
  (bitmap "stage0.png"))

(define step1
  (bitmap "stage1.png"))

(define step2
  (bitmap "stage2.png"))

(define step3
  (bitmap "stage3.png"))

(define step4
  (bitmap "stage4.png"))

(define step5
  (bitmap "stage5.png"))

(define step6
  (bitmap "stage6.png"))

(define (gallows n)
  (cond[(= n 0) step0]
       [(= n 1) step1]
       [(= n 2) step2]
       [(= n 3) step3]
       [(= n 4) step4]
       [(= n 5) step5]
       [else (win-loss-screen n)]))

(define(omit s l)
  (cond[(= (string-length s) 0) ""]
       [(string=? (substring s 0 1) l) (string-append "" (omit (substring s 1) l))]
       [else (string-append (substring s 0 1) (omit (substring s 1) l))]))

(check-expect (omit "word" "w") "ord")
(check-expect (omit "hangman" "a") "hngmn")
(check-expect (omit "nothing" "z") "nothing")

(define(wipeout s l)
  (cond[(= (string-length l) 0) s]
       [else (wipeout (omit s (substring l 0 1)) (substring l 1))]))

(check-expect (wipeout "Williams" "li") "Wams")
(check-expect (wipeout "penguin" "dinosaur") "peg")

(define (underscorizer s wp)
  (cond[(string=? s "") s]
       [(string=? wp "") s]
       [(string=? (substring s 0 1) " ") (string-append " " (underscorizer (substring s 1) (substring wp 1)))]
       [(string=? (substring s 0 1) (substring wp 0 1))
        (string-append "_" (underscorizer (substring s 1) (substring wp 1)))]
       [else (string-append (substring s 0 1) (underscorizer (substring s 1) wp))]))

(check-expect (underscorizer "my house" "my hous") "__ ____e")
(check-expect (underscorizer "feudal society" "feda ociey") "__u__l s____t_")

(define(string-contains-letter? s letter)
  (cond[(= (string-length s) 0) #false]
       [(string=? letter " ") #false]
       [(string-ci=? letter (substring s 0 1)) #true]
       [else (string-contains-letter? (substring s 1) letter)]))

(check-expect (string-contains-letter? "feudal society" "g") #false)
(check-expect (string-contains-letter? "home" "h") #true)
(check-expect (string-contains-letter? "" "p") #false)

(define(key-h hangman key)
  (cond[(string-contains-letter? (hangman-letter hangman) key) hangman]
       [(string-contains-letter? (hangman-word hangman) key) (make-hangman (hangman-word hangman) (hangman-tries hangman) (string-append (hangman-letter hangman) key) (hangman-win hangman))]
       [(and (not (string-contains-letter? (hangman-word hangman) key))
             (string-contains-letter? "abcdefghijklmnopqrstuvwxyz" key))
        (make-hangman (hangman-word hangman) (+ 1 (hangman-tries hangman)) (string-append (hangman-letter hangman) key) (hangman-win hangman))]
       [else hangman]))

(check-expect (key-h (make-hangman "feudal" 4 "shtr" #false) "e") (make-hangman "feudal" 4 "shtre" #false))
(check-expect (key-h (make-hangman "lovely" 2 "rn" #false) "q") (make-hangman "lovely" 3 "rnq" #false))

(define(draw-h hangman)
  (place-image (gallows (hangman-tries hangman)) 100 150
               (place-image (text (underscorizer (hangman-word hangman) (wipeout (hangman-word hangman) (hangman-letter hangman))) 48 "black")
                            300 300(empty-scene 500  500))))


(define(win-loss-screen hangman)
  (cond[(= (hangman-tries hangman) 6) (place-image (text "YOU LOSE" 60 "red") 250 100
                                                   (place-image (text (string-append "The word was " (hangman-word hangman)) 40 "red") 250 200
                                                                (rectangle 500 500 "solid" "black")))]
       [(win? hangman) (place-image (text "YOU WIN" 60 "green") 250 100
                     (place-image (text (string-append "The word was " (hangman-word hangman)) 40 "green") 250 200 (rectangle 500 500 "solid" "black")))]))

(define (win? hangman)
  (cond[(string=? (wipeout (hangman-word hangman) (hangman-letter hangman))"") #true]
       [(string=? (wipeout (hangman-word hangman) (hangman-letter hangman))" ") #true]
       [else #false]))

(check-expect (win? (make-hangman "feudal" 3 "setra" #false)) #false)
(check-expect (win? (make-hangman "love" 2 "lvmroe" #false)) #true)

(define(final hangman)
  (cond[(or (= (hangman-tries hangman) 6) (win? hangman)) #true]
       [else #false]))

(check-expect (final (make-hangman "beep" 6 "hnubpnmq" #false)) #true)
(check-expect (final (make-hangman "old fashion" 3 "olhnfaudrwsi" #false)) #true)

(big-bang (make-hangman "intermediate cs" 0 "" #false)
  (on-draw draw-h)
  (on-key key-h)
  (stop-when final win-loss-screen))