;;;=================================================================
;;; author: John Rowan
;;; class: CSC345 TR 11-11:15
;;; due date: 10/30/18
;;; description: main test cases
;;;=================================================================
   (integrate '1 'x)					 
   (integrate '1 'y 1 4)				 
   (integrate 'z 'z)					 
   (integrate '(+ x 0) 'x)				 
   (integrate '(- x) 'x 1 3)				 
   (integrate '(- - x) 'x 1 4)			 
   (integrate '(- x) 'x)				 
   (integrate '(- - x) 'x)				 
   (integrate '(- - - x) 'x)				 
   (integrate '(+ x (- x)) 'x)			 
   (integrate '(- (+ (- - x) x)) 'x 1 4)		 
   (integrate '(+ (+ (- - x) (+ x 3)) 2) 'x 2 6)	 
   (integrate '(- x (expt x 3)) 'x)			 
   (integrate '(- x (expt x 3)) 'x 2 5)		 
   (integrate '(+ (+ x (- - - x)) (expt x 3)) 'x)	 
   (integrate '(+ (- x (- x)) (expt x 3)) 'x 2 3)	 
   (integrate '(expt x -1) 'x)			 
   (integrate '(expt x -1) 'x 3 45)			 
   (integrate '(+ (+ x (- 5 x)) (expt x -1)) 'x)	 
   (integrate '(+ (+ x (- 5 x)) (expt x -1)) 'x 5 217)
