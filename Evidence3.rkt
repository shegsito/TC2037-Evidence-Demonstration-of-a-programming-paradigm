#lang racket

;; ===================================================
;; 580 A. Kefka and First Steps
;; from codeforces.com
;;
;; Evidence 3. Demonstration of a programming paradigm
;; Germán Uriel Xochihua Moncada - A016147412  
;; Implementation of Computational Methods
;; ===================================================

(define (abbreviate word)

  ;; string-length: function to get the length og the word
  (if (> (string-length word) 10)
      ;; string-append: function to concatenate the characters of several strings
      (string-append

       ;; string-ref: function that extracts the i character from the arg
       (string (string-ref word 0)) ;;first letter
       (number->string (- (string-length word) 2)) ;; middle count
       (string (string-ref word (- (string-length word) 1))) ;; last letter
       )
      word))

;; solve : (Listof String) -> (Listof String)
;; applies abbreviate to every word in the list using map.
(define (solve words)
  (map abbreviate words))

;; try testing this
;; (solve '("word" "internationalization" "localization" "pneumonoultramicroscopicsilicovolcanoconiosis"))
