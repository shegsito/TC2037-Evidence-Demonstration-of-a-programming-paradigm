#lang racket

;; ===================================================
;; 580A. Kefa and First Steps
;; from codeforces.com/problemset/problem/580/A
;;
;; Evidence 3. Demonstration of a Programming Paradigm
;; By Germán Uriel Xochihua Moncada
;; Implementation of Computational Methods
;; ===================================================

;; The accumulator is a list: (list prev curr best)
;; prev - previous element
;; curr - length of current non-decreasing segment
;; best - longest segment found so far


;; step: Number (List Number Number Number) -> (List Number Number Number)
;; Pure function: fold passes (element accumulator), returns updated accum


(define (step x acc)
  (let ([prev (first acc)]
        [curr (second acc)]
        [best (third acc)])
    (if (<= prev x)
        (list x (+ curr 1) (max best (+ curr 1))) ; segment continues
        (list x 1 best))))

;; solve : (Listof Number) -> Number
;; Returns the length of the longest non-decreasing subsegment

(define (solve lst)
  (if (null? lst)
      0
      (third
       (foldl step
              (list (first lst) 1 1) ;; initial accum
              (rest lst))))) ; fold over remaining elements

;; ============
;; TESTS
;; ============

(solve '(2 2 1 3 4 1))       ; expected: 3
(solve '(2 2 9))             ; expected: 3
(solve '(1))                 ; expected: 1
(solve '(1 2 3 4 5))         ; expected: 5
(solve '(5 4 3 2 1))         ; expected: 1
(solve '(1 1 1 1))           ; expected: 4
(solve '(3 1 2 1 2 3))       ; expected: 3
(solve '(1 3 2 4 3 5))       ; expected: 2
(solve '())                  ; expected: 0
