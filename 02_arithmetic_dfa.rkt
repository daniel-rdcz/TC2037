#|
Implementation of a Deterministic Finite Automaton (DFA)

A function will receive the definition of a DFA and a string,
and return whether the string belongs in the language

A DFA is defined as a state machine, with 3 elements:
- Transition function
- Initial state
- List of acceptable states

The DFA in this file is used to identify valid arithmetic expressions

Examples:
> (evaluate-dfa (dfa delta-arithmetic 'start '(int float exp)) "-234.56")
'(float exp)

> (arithmetic-lexer "45.3 - +34 / none")
'(var spa)

David Vieyra
Daniel Rodriguez
2023-03-30
|#

#lang racket

(require racket/trace)

(provide (all-defined-out))

; Declare the structure that describes a DFA
(struct dfa (func initial accept))

(define (arithmetic-lexer strng)
  " Call the function to validate using a specific DFA "
  (evaluate-dfa (dfa delta-arithmetic 'start '(int float exp var spa sign dot e e_sign exp var op op_spa opening_parenthesis closing_parenthesis)) strng))

(define (evaluate-dfa dfa-to-evaluate strng)
  " This function will verify if a string is acceptable by a DFA "
  (let loop
    ; Convert the string into a list of characters
    ([chars (string->list strng)]
     ; Get the initial state of the DFA
     [state (dfa-initial dfa-to-evaluate)]
     {current-token '()}
     ; Then return list with all the tokens found
     [tokens '()])
    (cond
      ; When the list of chars if over, check if the final state is acceptable
      [(empty? chars)
       (if (member state (dfa-accept dfa-to-evaluate))
           (reverse (filter (lambda (x) (not (eq? x 'spa))) (cons (list (list->string (reverse current-token)) state) tokens)))
           'invalid)]
      [else
       (let-values
       ; Call the transition function and get the new state and wheter or not a token was form
       ([(new-state found) ((dfa-func dfa-to-evaluate) state (car chars))])
       (loop (cdr chars)
             new-state
             (if found (cons(car chars) current-token)
                 (list(if (and found (not (eq? found 'spa))) '() (car chars))))
             ; The new list of tokens
             (if (and found (not (eq? found 'spa))) (cons (list (list->string (reverse current-token)) found) tokens) tokens)))])))


; 567.2 - 341
;Se va guardando en una lista: (2.765) float.
;Lo reverseas: (reverse (2.765)).

;Finalmente los pasas a una lista. El valor como string y la variable como estado: (list "567.2" 'float)

(define (char-operator? char)
  " Identify caracters that represent arithmetic operators "
  (member char '(#\+ #\- #\* #\/ #\= #\^)))

(define (delta-arithmetic state char)
  " Transition function to validate numbers
  Initial state: start
  Accept states: int float exp "
  (case state
    ['start (cond
       [(char-numeric? char) (values 'int (string char))]
       [(eq? char #\space) (values 'spa #f)]
       [(or (eq? char #\+) (eq? char #\-)) (values 'sign #f)]
       [(char-alphabetic? char) (values 'var #f)]
       [(eq? char #\_) (values 'var #f)]
       [(eq? char #\() (values 'opening_parenthesis #f)]
       [else (values 'inv #f)])]
    ['sign (cond
       [(char-numeric? char) (values 'int #f)]
       [else (values 'inv #f)])]
    ['int (cond
       [(char-numeric? char) (values 'int (string char))]
       [(eq? char #\.) (values 'dot  #f)]
       [(or (eq? char #\e) (eq? char #\E)) (values 'e #f)]
       [(char-operator? char) (values 'op 'int)]
       [(eq? char #\space) (values 'spa 'int)]
       [(eq? char #\() (values 'opening_parenthesis 'int)]
       [(eq? char #\)) (values 'closing_parenthesis 'int)]
       [else (values 'inv #f)])]
    ['dot (cond
       [(char-numeric? char) (values 'float #f)]
       [else (values 'inv #f)])]
    ['float (cond
       [(char-numeric? char) (values 'float #f)]
       [(or (eq? char #\e) (eq? char #\E)) (values 'e #f)]
       [(char-operator? char) (values 'op 'float)]
       [(eq? char #\space) (values 'spa 'float)]
       [(eq? char #\() (values 'opening_parenthesis 'float)]
       [(eq? char #\)) (values 'closing_parenthesis 'float)]
       [else (values 'inv #f)])]
    ['e (cond
       [(char-numeric? char) (values 'exp #f)]
       [(or (eq? char #\+) (eq? char #\-)) (values 'e_sign #f)]
       [else (values 'inv #f)])]
    ['e_sign (cond
       [(char-numeric? char) (values 'exp #f)]
       [else (values 'inv #f)])]
    ['exp (cond
       [(char-numeric? char) (values 'exp #f)]
       [(char-operator? char) (values 'op 'exp)]
       [(eq? char #\space) (values 'spa 'exp)]
       [(eq? char #\() (values 'opening_parenthesis 'exp)]
       [(eq? char #\)) (values 'closing_parenthesis 'exp)]
       [else (values 'inv #f)])]
    ['var (cond
       [(char-alphabetic? char) (values 'var #f)]
       [(char-numeric? char) (values 'var #f)]
       [(eq? char #\_) (values 'var #f)]
       [(char-operator? char) (values 'op 'var)]
       [(eq? char #\space) (values 'spa 'var)]
       [(eq? char #\() (values 'opening_parenthesis 'var)]
       [(eq? char #\)) (values 'closing_parenthesis 'var)]
       [else (values 'inv #f)])]
    ['op (cond
       [(char-numeric? char) (values 'int 'op)]
       [(or (eq? char #\+) (eq? char #\-)) (values 'sign 'op)]
       [(char-alphabetic? char) (values 'var 'op)]
       [(eq? char #\_) (values 'var 'op)]
       [(eq? char #\space) (values 'op_spa 'op)]
       [(eq? char #\() (values 'opening_parenthesis 'op)]
       [(eq? char #\)) (values 'closing_parenthesis 'op)]
       [else (values 'inv #f)])]
     ['spa (cond
       [(char-operator? char) (values 'op #f)]
       [(eq? char #\space) (values 'spa #f)]
       [(char-numeric? char) (values 'int #f)]
       [else (values 'inv #f)])]
    ['op_spa (cond
       [(char-numeric? char) (values 'int #f)]
       [(or (eq? char #\+) (eq? char #\-)) (values 'sign #f)]
       [(char-alphabetic? char) (values 'var #f)]
       [(eq? char #\_) (values 'var #f)]
       [(eq? char #\space) (values 'op_spa #f)]
       [else (values 'inv #f)])]
    ['opening_parenthesis (cond
       [(char-numeric? char) (values 'int 'opening_parenthesis)]
       [(or (eq? char #\+) (eq? char #\-)) (values 'sign 'opening_parenthesis)]
       [(char-alphabetic? char) (values 'var 'opening_parenthesis)]
       [(eq? char #\() (values 'opening_parenthesis 'opening_paretnhesis)]
       [(eq? char #\)) (values 'closing_parenthesis 'opening_parenthesis)]
       [(eq? char #\_) (values 'var 'opening_parenthesis)]
       [else (values 'inv #f)])]
    ['closing_parenthesis (cond
       [(char-numeric? char) (values 'int 'closing_parenthesis)]
       [(or (eq? char #\+) (eq? char #\-)) (values 'sign 'closing_parenthesis)]
       [(char-alphabetic? char) (values 'var 'closing_parenthesis)]
       [(eq? char #\() (values 'opening_parenthesis 'closing_parenthesis)]
       [(eq? char #\)) (values 'closing_parenthesis 'closing_parenthesis)]
       [(eq? char #\space) (values 'spa 'closing_parenthesis)]
       [(eq? char #\_) (values 'var 'closing_parenthesis)]
       [else (values 'inv #f)])]
    ))


(arithmetic-lexer "22")
