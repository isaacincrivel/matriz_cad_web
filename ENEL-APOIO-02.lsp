
(defun pointInPolygon  (pts pt / i j odd
                        qtd it jt)
  (setq i   0
        j   0
        odd nil
        qtd (length pts)
        x   (car pt)
        y   (cadr pt))
  (repeat qtd
    (setq j  (if (= (1+ j) qtd)
               0
               (1+ j))
          it (cadr (nth i pts))
          jt (cadr (nth j pts)))
    (if (or (and (< it y) (>= jt y))
            (and (< jt y) (>= it y)))
      (if (< (+ (car (nth i pts))
                (* (/ (- y it) (- jt it))
                   (- (car (nth j pts))
                      (car (nth i pts)))))
             x)
        (setq odd (not odd))))
    (setq i (1+ i)))
  odd)




(DEFUN ENEL_DISTANCIA ()
  (if (and (/= COORD_X "") (/= COORD_Y ""))
    (progn
      (if (and (/= var2 "") (/= var3 ""))
	(progn
	  (setq pto4 (list (atoi var2) (atoi var3)))
	  (setq pto5 (list (atoi COORD_X) (atoi COORD_Y)))
	  (setq int3 (+ int3 (distance pto4 pto5)))
	  (command "-INSERT"
		   "DISTANCIA"
		   ptogeral
		   "1"
		   "1"
		   "0"
		   (strcat (rtos (distance pto4 pto5) 2 0) "m")
	  )

	  (if (/= GBL_DISTANCIA "erro")
	    (if	(> (distance pto4 pto5) 500)
	      (setq GBL_DISTANCIA "erro")
	    )
	  )


	  (setq	var2 COORD_X
		var3 COORD_Y
	  )
	)
	(setq var2 COORD_X
	      var3 COORD_Y
	)
      )
    )
  )
)


(defun ENEL_ESTAI	()


  
  (if (/= BASE_CONCRETO "")
    (progn
      (command "-insert" "BASECONCRETO" ptogeral "1" "1" "0")
    )
  )

  
  
)


(defun ENEL_PLACA ()

  (if (and (= var1 "meio") (/= seq "1") (/= seq "2"))
    
    (progn
      (if (= BASE_REFORCADA "1")
	(progn
	  (command "-insert" "ESTAISUBSOLO" ptogeral "1" "1" "90")
	)
      )
      (if (= BASE_REFORCADA "2")
	(progn
	  (command "-insert" "ESTAISUBSOLO2" ptogeral "1" "1" "0")
	)
      )
    )

    (progn
      (if (= BASE_REFORCADA "1")
	(progn
	  (command "-insert" "ESTAISUBSOLO" ptogeral "1" "1" "0")
	)
      )
    )
    
  )
)


;;;(defun ENEL_ESTAI ()
;;;
;;;  (if (= var1 "inicio")
;;;    (cond
;;;      ((= BASE_CONCRETO "1")
;;;       (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "-90")
;;;      )
;;;
;;;      ((= BASE_CONCRETO "3")
;;;       (progn
;;;	 (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "-90")
;;;	 (command "-insert" "ESTAIDUPLO" ptogeral "1" "1" "-90")
;;;       )
;;;      )
;;;    )
;;;  )
;;;
;;;
;;;  (if (= var1 "fim")
;;;    (cond
;;;      ((= BASE_CONCRETO "1")
;;;       (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "90")
;;;      )
;;;
;;;      ((= BASE_CONCRETO "3")
;;;       (progn
;;;	 (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "90")
;;;	 (command "-insert" "ESTAIDUPLO" ptogeral "1" "1" "90")
;;;       )
;;;      )
;;;    )
;;;  )
;;;
;;;  (if (= var1 "meio")
;;;    (cond
;;;      ((and
;;;	 (= ESTRUTURA "U3-U3")
;;;	 (= BASE_CONCRETO "2")
;;;       )
;;;       (progn
;;;	 (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "0")
;;;	 (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "-90")
;;;       )
;;;      )
;;;
;;;      ((and
;;;	 (= ESTRUTURA "UP4")
;;;	 (= BASE_CONCRETO "2")
;;;       )
;;;       (command "-insert" "ESTAIDUPLO" ptogeral "1" "1" "0")
;;;      )
;;;
;;;      ((and
;;;	 (= ESTRUTURA "UP4")
;;;	 (= BASE_CONCRETO "1")
;;;       )
;;;       (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "-90")
;;;      )
;;;
;;;      ((and
;;;	 (= ESTRUTURA "UP4")
;;;	 (= BASE_CONCRETO "4")
;;;       )
;;;       (progn
;;;	 (command "-insert" "ESTAIDUPLO" ptogeral "1" "1" "0")
;;;	 (command "-insert" "ESTAIDUPLO" ptogeral "1" "1" "-90")
;;;       )
;;;      )
;;;
;;;      ((and
;;;	 (= ESTRUTURA "UP4")
;;;	 (= BASE_CONCRETO "3")
;;;       )
;;;       (progn
;;;	 (command "-insert" "ESTAIDUPLO" ptogeral "1" "1" "0")
;;;	 (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "0")
;;;       )
;;;      )
;;;      ((= BASE_CONCRETO "1")
;;;       (command "-insert" "ESTAISIMPLES" ptogeral "1" "1" "0")
;;;      )
;;;    )
;;;  )
;;;
;;;)

(defun ENEL_CHAVE ()
  (if (/= CHAVE "")
    (progn
      (command "-insert" "CHAVETEXTO" ptogeral "1" "1" "0" CHAVE)
      (command "-insert" "CHAVEFUS" ptogeral "1" "1" "0")
    )
  )
)

(defun ENEL_ATERRAMENTO	()
  (if (/= ATERR_NEUTRO "")
    (progn
      (command "-insert" "ATERNEUTRO" ptogeral "1" "1" "0")
    )
  )
)

(defun ENEL_CERCA ()
  (if (/= CERCA_01 "")
    (progn
      (COMMAND "-insert" "CERCA1" ptogeral "1" "1" "0" CERCA_01)
    )
  )
  (if (/= CERCA_01 "")
    (progn
      (COMMAND "-insert" "CERCA2" ptogeral "1" "1" "0" CERCA_01)
    )
  )
  (if (/= CERCA_01 "")
    (progn
      (COMMAND "-insert" "CERCA3" ptogeral "1" "1" "0" CERCA_01)
    )
  )
)

(DEFUN ENEL_FAIXA ()
  (if (/= FAIXA "")
    (command "-insert"
	     "FAIXA"
	     ptogeral
	     "1"
	     "1"
	     "0"
	     (STRCAT FAIXA "m")
    )
  )
)

(DEFUN ENEL_CORTE_ARVORE ()
  (if
    (/= CORTE_ARVORE "")
     (command "-insert"
	      "CORTEARVORE"
	      ptogeral
	      "1"
	      "1"
	      "0"
	      (STRCAT CORTE_ARVORE "und")
     )
  )
)

(DEFUN ENEL_TRAFO ()
  (if (/= CT_TRAFO "")
    (progn
      (command "-insert" "TRAFOBLOCO" ptogeral "1" "1" "0")
      (command "-insert" "TRAFOTEXTO" ptogeral "1" "1" "0" CT_TRAFO	"10KVA")
    )
  )
  (if (/= RAMAL_CASA "")
    (progn
      (command "-insert" "RSERVICO" ptogeral "1" "1" "0" "20m")
    )
  )

  (if (/= RESISTENCIA_OHM "")
    (progn
      (command "-insert"
	       "RESISTENCIA"
	       ptogeral
	       "1"
	       "1"
	       "0"
	       (strcat RESISTENCIA_OHM "-OHM")
	       "10KVA"
      )
    )
  )

  (if (/= MEDIDOR "")
    (progn
      (command "-insert" "CHAVEMEDIDOR" ptogeral "1" "1" "0" MEDIDOR)
    )
  )
)



