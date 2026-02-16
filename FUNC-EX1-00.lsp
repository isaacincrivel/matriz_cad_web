;;;;- ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ -
;;;;- ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ - - ELETRIZ -

;;;;;*********************************** INICIO ROTINA EX1 E UND-EXPLODIR  ************************
;;;;;*********************************** INICIO ROTINA EX1 E UND-EXPLODIR  ************************

(defun und-explodir (/ i l n s x)
;;; bloquei a o bloco para explosão
  (vlax-for b (vla-get-blocks
		(vla-get-activedocument (vlax-get-acad-object))
	      )
    (if
      (and
	(= :vlax-false (vla-get-isxref b))
	(= :vlax-false (vla-get-islayout b))
	(not (wcmatch (vla-get-name b) "`**,_*"))
	(vlax-property-available-p b 'explodable t)
	(= :vlax-true (vla-get-explodable b))
      )
       (setq l (cons (cons (strcase (vla-get-name b)) b) l))
    )
  )
  (if l
    (if
      (setq s
	     (ssget
	       "X"
	       (list
		 '(0 . "INSERT")
		 (cons 2
		       (substr
			 (apply	'strcat
				(mapcar '(lambda (x) (strcat "," (car x))) l)
			 )
			 2
		       )
		 )
	       )
	     )
      )
       (repeat (setq i (sslength s))
	 (if
	   (not
	     (member
	       (setq n
		      (strcase
			(LM:blockname
			  (vlax-ename->vla-object
			    (ssname s (setq i (1- i)))
			  )
			)
		      )
	       )
	       x
	     )
	   )
	    (progn
	      (setq x (cons n x))
	      (vla-put-explodable (cdr (assoc n l)) :vlax-false)
	    )
	 )
       )
    )
    ;(princ "\nAll blocks are already unexplodable.")
  )
  (princ)
)

;; Block Name  -  Lee Mac
;; Returns the true (effective) name of a supplied block reference

(defun LM:blockname (obj)
  (if (vlax-property-available-p obj 'effectivename)
    (defun LM:blockname (obj) (vla-get-effectivename obj))
    (defun LM:blockname (obj) (vla-get-name obj))
  )
  (LM:blockname obj)
)
(vl-load-com)
(princ)

(defun c:ex1 ()
;;;; permite explodir o bloco
  (vl-load-com)
  (vlax-for b (vla-get-Blocks
		(vla-get-ActiveDocument (vlax-get-acad-object))
	      )
    (or	(wcmatch (vla-get-Name b) "`**_Space*")
	(vla-put-explodable b :vlax-true)
					;<-switch to false should do it?
    )
  )
  (princ)
)