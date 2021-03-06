;;;=================================================================
;;; author: John Rowan
;;; class: CSC345 TR 11-11:15
;;; due date: 10/30/18
;;; description: implementation of definite and indefinite integration
;;;=================================================================
;;;    NAME: integrate
;;;  ARG(S): "F" function to integrate, "V" variable of integration
;;;          two optional arguments hi and low for limits of integration
;;; RETURNS: either a solved definite integral or indefinite integral
(defun integrate(F V &optional lo hi)
  "Integrates function 'F' with respect to 'V' with the option
   to include hi and lo arguments to solve definitely"
  (def-integral (indef-integral F V) lo hi))

;;;=================================================================
;;;    NAME: indef-integral
;;;  ARG(S): "F" function to integrate, "V" variable of integration
;;; RETURNS: an indefinite integral of function "F"
(defun indef-integral(F V)
  "Integrates function 'F' with respect to 'V' indefinetly"
  (cond ((numberp F)(make-product F V))
	((variable-p F)(make-product 1/2 (make-power F 2)))
	((addition-p F)(make-sum
			(indef-integral (add-operand-1 F) V)
			(indef-integral (add-operand-2 F)V)))
	((negate-p F)(cond ((resolve-negation F 1)
			    (make-negative (indef-integral(negate-operand F )V)))
			   (t(indef-integral(negate-operand F)V))))
	((subtraction-p F)(make-subtraction
			   (indef-integral (sub-operand-1 F)V)
			   (indef-integral(sub-operand-2 F)V)))
	((log-p F)(make-logarithm (log-operand-1 F)))
	((power-p F)(make-product
		     (make-division 1 (1+ (pow-operand-2 F)))
		     (make-power (pow-operand-1 F) (1+ (pow-operand-2 F)))))
	
	))

;;;=================================================================
;;;    NAME: def-integral
;;;  ARG(S): "F" function to solve definitly with limits of integration
;;;          hi and lo
;;; RETURNS: a solved definite integral
(defun def-integral(F lo hi)
  "Integrates function 'F' with limits 'hi' and 'lo' definitly
   or returns indefinite integral if 'lo' and 'hi not specified"
  (cond ((and (not lo) (not hi))(simplify F))
	(t(- (eval(my-replace hi F))(eval(my-replace lo F))))))
  
;;;=================================================================
;;; SYMBOLS
(defconstant variable-symbols '(U V W X Y Z))
(defconstant negative-symbol  '-)
(defconstant sum-symbol       '+)
(defconstant product-symbol   '*)
(defconstant division-symbol  '/)
(defconstant log-symbol       'log)
(defconstant power-symbol     'expt)

;;;=================================================================
;;; SELECTORS -- OPERATORS

;;;=================================================================
;;;    NAME: prefix-operator,negate-operator,addition-operator,
;;;          multi-operator,subtraction-operator,div-operator,
;;;          log-operator,pow-operator
;;;  ARG(S): "F" function 
;;; RETURNS: the prefix operator of function "F"
(defun prefix-operator(F)
  "Documentation: (prefix-operator F) returns the operator of 
   function 'F' (this is the generic version mainly for testing)"
  (first F))

(defun negate-operator(F)
  "Documentation: (negate-operator F) returns the operator of
   a negation function 'F' ex. '-'"
  (first F))

(defun addition-operator(F)
  "Documentation: (addition-operator F) returns the operator of
   an addition function 'F' ex. '+'"
  (first F))

(defun multi-operator(F)
  "Documentation: (multi-operator F) returns the operator of
   a multiplication function 'F' ex. '*'"
  (first F))

(defun subtraction-operator(F)
  "Documentation: (subtraction-operator F) returns the operator
   of a subtraction function 'F' ex. '-'"
  (first F))

(defun div-operator(F)
  "Documentation: (div-operator F) returns the operator of a
   division function 'F' ex. '/'"
  (first F))

(defun log-operator(F)
  "Documentation: (log-operator) returns the operator of a 
   power function 'F' ex. 'expt'"
  (first F))

(defun pow-operator(F)
  "Documentation: (pow-operator) returns the operator of a 
   power function 'F' ex. 'expt'"
  (first F))


;;;=================================================================
;;; SELECTORS -- OPERANDS

;;;=================================================================
;;;    NAME: negative-operand,add-operand-1,add-operand-2,
;;;          sub-operand-1,sub-operand-2,log-operand-1,log-operand-2,
;;;          div-operand-1,div-operand-2,pow-operand-1,pow-operand-2,
;;;          operand-1,operand-2,negate-operand
;;;  ARG(S): "F" function 
;;; RETURNS: the corresponding operand of function "F"
(defun negative-operand(F)
  "Documentation: (negative-operand F) returns the operand of the 
   negation function 'F', example (- 8) => 8"
  (second F))

(defun add-operand-1(F)
  "Documentation: (add-operand-1 F) returns the first operand of the
   addition function 'F', example (+ X 9) => X"
  (second F))

(defun add-operand-2(F)
  "Documentation: (add-operand-2 F) returns the second operand of the
   addition function 'F', example (+ X 9) => 9"
  (third F))

(defun sub-operand-1(F)
  "Documentation: (sub-operand-1 F) returns the first operand of the 
   subtraction function 'F', example (- X 9) => X"
  (second F))

(defun sub-operand-2(F)
  "Documentation: (sub-operand-2 F) returns the second operand of the
   subtraction function 'F', example (- X 9) => 9"
  (third F))

(defun log-operand-1(F)
  "Documentation: (log-operand-1 F) returns the first operand of the
   expt function 'F', example (expt X -1) => X"
  (second F))

(defun log-operand-2(F)
  "Documentation: (log-operand-2 F) returns the second operand of the
   expt function 'F', example (expt X -1) => -1"
  (third F))

(defun div-operand-1(F)
  "Documentation: (div-operand-1 F) returns the first operand of the
   division function 'F', example (/ 1 9) => 1"
  (second F))

(defun div-operand-2(F)
  "Documentation: (div-operand-2 F) returns the second operand of the
   division function 'F', example (/ 1 9) => 9"
  (third F))

(defun pow-operand-1(F)
  "Documentation: (pow-operand-1 F) returns the first operand of the 
   expt function 'F', example (expt X 3) => X"
  (second F))

(defun pow-operand-2(F)
  "Documentation: (pow-operand-2 F) returns the second operand of the 
   expt function 'F', example (expt X 3) => 3"
  (third F))

(defun operand-1(F)
  "Documentation: (operand-1 F) returns the first operand of the 
   function 'F' (generic method for testing)"
  (second F))

(defun operand-2(F)
  "Documentation: (operand-2 F) returns the second operand of the
   function 'F' (generic method for testing)"
  (third F))

(defun negate-operand(F)
  "Documentation: (negate-operand F) returns the first operand of the
   negate function 'F', example (- - - - X) => X"
  (cond ((not (equal (first F) negative-symbol))(first F))
	(t (negate-operand (rest F)))))


;;;=================================================================
;;; PREDICATES

;;;=================================================================
;;;    NAME: variable-p,addition-p,multiplication-p,negate-p,
;;;          subtraction-p,log-p,power-p,resolve-negation
;;;  ARG(S): "F" function 
;;; RETURNS:  t or nil

(defun variable-p(F)
  "Documentation: (variable-p F) returns t if 'F' is contained in
   'variable-symbols' constant, nil otherwise"
  (member F variable-symbols))

(defun addition-p(F)
  "Documentation: (addition-p F) returns t if 'F' is an addition
   function eg (+ 8 9), nil otherwise"
  (equal (addition-operator F) sum-symbol))

(defun multiplication-p(F)
  "Documentation: (multiplication-p F) returns t if 'F' is a
   multiplication function eg (* 8 9), nil otherwise"
  (equal (multi-operator F) product-symbol))

(defun negate-p(F)
  "Documentation: (negate-p F) returns t if 'F' is a negation function
   eg (- 9), nil otherwise"
  (and
   (equal (negate-operator F) negative-symbol)
   (or
    (not (operand-2 F))
    (equal (operand-1 F)negative-symbol))))

(defun subtraction-p(F)
  "Documentation: (subtraction-p F) returns t if 'F' is a subtraction
   function eg (- 8 9), nil otherwise"
  (and (equal (subtraction-operator F) negative-symbol)(= 3 (length F))))

(defun log-p(F)
  "Documentation: (log-p F) returns t if 'F' is an expt function with
   the power set to -1 eg (expt X -1), nil otherwise"
  (and (equal (log-operator F) power-symbol)(= -1 (log-operand-2 F))))

(defun power-p(F)
  "Documentation: (power-p F) returns t if 'F' is an expt function
   eg (expt X 3), nil otherwise"
  (equal (pow-operator F) power-symbol))

(defun resolve-negation(F g)
  "Documentation: (resolve-negation F g) returns t if 'F' resolves to a 
   negation function eg (- - - X), nil otherwise eg (- - X)"
  (cond ((and (not (equal (negate-operator F)negative-symbol)) (< g 0))t)
	((and (not (equal (negate-operator F)negative-symbol))(> g 0))nil)
	(t(resolve-negation (rest F) (* -1 g)))))

;;;=================================================================
;;; CONSTRUCTORS

;;;=================================================================
;;;    NAME: make-variable,make-sum,make-subtraction,make-product
;;;          make-division,make-power,make-logarithm,make-negative
;;;  ARG(S): two Functions or numbers or one of each, in the case
;;;          of one argument it is either a function or a number
;;; RETURNS: Fuction or result of function
(defun make-variable(V)
  "Documenation: (make-variable V) returns the variable V"
  V)

(defun make-sum(F G)
  "Documentation: (make-sum F G) returns either and addition function
   eg (+ F G) or the result of addition function eg (+ 0 F) => F"
  (cond ((eq 0 F) G)
	((eq 0 G) F)
	((and(numberp F)(numberp G))(+ F G))
	(t (list sum-symbol F G))))

(defun make-subtraction(F G)
  "Documentation: (make-subtraction F G) returns either a subtraction
   function eg (- F G) or the result of subtraction of 2 numbers (- 2 1) => 2"
  (cond ((and(numberp F)(numberp G))(- F G))
	(t (list negative-symbol F G))))

(defun make-product(F G)
  "Documentation: (make-product F G) returns either a multiplication
   function eg (* F G) or the result of multiplying 2 numbers (* 2 2) => 4"
  (cond ((and(numberp F)(numberp G))(* F G))
	(t (list product-symbol F G))))

(defun make-division(F G)
  "Documentation: (make-division F G) returns either a division function
   eg (/ F G) or the result of dividing 2 numbers (/ 2 2) => 1"
  (cond ((and(numberp F)(numberp G))(/ F G))
	(t (list division-symbol F G))))

(defun make-power(F ex)
  "Documentation: (make-power F ex) returns an expt function eg
   (expt F ex)"
  (list power-symbol F ex))

(defun make-logarithm(F)
  "Documentation: (make-logarithm F) returns a logarithm function eg
   (LOG F)"
  (list log-symbol F))

(defun make-negative(F)
  "Documentation: (make-negative F) returns the negation function eg
   (- F)"
  (list negative-symbol F))

;;;=================================================================
;;; HELPER FUNCTIONS

;;;=================================================================
;;;    NAME: my-replace
;;;  ARG(S): "hilo" number, "L" function
;;; RETURNS: a function with all occurances of variables replaced
;;;          with the number "hilo"
(defun my-replace(hilo  L)
  "Documentation: (my-replace hilo L) replaces all occurances of a variable
   with 'hilo' and returns that function"
  (cond ((endp L)nil);base case
        ((variable-p  (first L))(cons hilo (my-replace hilo  (rest L))))
	((listp (first L))(cons (my-replace hilo (first L))(my-replace hilo (rest L))))
	(t(cons (first L)(my-replace hilo (rest L))))))

;;;=================================================================
;;;    NAME: simplify
;;;  ARG(S): "F" function
;;; RETURNS: the simplified function F
(defun simplify(F)
  "Documentation: (simplify F) attempts to simplify function 'F'"
  (cond ((numberp F)F)
	((variable-p F)F)
        ((endp F)nil)
	((addition-p F)(cond  ((eq (simplify(operand-1 F))0)(operand-2 F))
			      ((eq (simplify(operand-2 F))0)(operand-1 F))
			      ((and
				(negate-p (operand-1 F))
				(not (negate-p (operand-2 F)))
				(equal (second(operand-1 F))(operand-2 F)))
			       0)
			      ((and
				(negate-p (operand-2 F))
				(not (negate-p (operand-1 F)))
				(equal (second(operand-2 F))(operand-1 F)))
			       0)
			      (t(list sum-symbol
				      (simplify (operand-1 F))
				      (simplify (operand-2 F))))))
	((multiplication-p F)(cond ((eq 0 (simplify(operand-1 F)))0)
				   ((eq 0 (simplify(operand-2 F)))0)
				   ((eq 1 (simplify(operand-1 F)))(operand-2 F))
				   ((eq 1 (simplify(operand-2 F)))(operand-1 F))
				   (t(list product-symbol
					   (simplify (operand-1 F))
					   (simplify (operand-2 F))))))
	(t F)
	))
