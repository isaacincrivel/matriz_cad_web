;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   PLINHAS E LINHAS     <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


;;;<> ESHOP-CRR_PLL
;;;++ DESCRIÇÃO: CRIA POLILINHA SOLICITANDO PONTOS
;;;++ ENTRADA: sel1:SELEÇÃO
;;;++ SAIDA: DESTACA ELEMENTOS
(defun ESHOP-CRR_PLL (/ pto1 pto2 int1 msg1)
  (if (setq pto1 (getpoint "\n=> Defina ponto inicial : "))
    (progn (setq int1 0
		 msg1 "\n-> Defina segundo ponto : "
	   )
	   (while (setq pto2 (getpoint pto1 msg1))
	     (if (= int1 0)
	       (progn (command "_.pline")
		      (command "_non" pto1 "_non" pto2)
		      (setq int1 1
			    pto1 pto2
			    msg1
				 "\n-> Próximo ponto ou tecle enter para encerrar : "
		      )
	       )
	       (progn (command "_non" pto2) (setq pto1 pto2))
	     )
	   )
	   (if (= (getvar "cmdactive") 1)
	     (command "")
	   )
    )
    (princ "\n-> ponto inicial não fornecido")
  )
  (entlast)
)

;;;<> ESHOP-PTO_PLINE
;;;++ DESCRIÇÃO: EXTRAI PONTOS DE UMA POLILYNE SEM REPETIR 
;;;++ ENTRADA: elm1:polilinha
;;;++ SAIDA: lista de pontos
(DEFUN ESHOP-PTOS_PLINE	(elm1
			 /
			 lst1
			)
  (foreach x (entget elm1)
    (if	(= (car x) 10)
      (setq lst1 (append lst1 (list (cdr x))))
    )
  )
  (ESHOP-EXC_DUP lst1)
)



;;;<> ESHOP-PTO_PLINE_REP
;;;++ DESCRIÇÃO: EXTRAI PONTOS DE UMA POLILYNE COM VALORES REPTIDOS
;;;++ ENTRADA: elm1:polilinha
;;;++ SAIDA: lista de pontos
(DEFUN ESHOP-PTOS_PLINE_REP	(elm1
			 /
			 lst1
			)
  (foreach x (entget elm1)
    (if	(= (car x) 10)
      (setq lst1 (append lst1 (list (cdr x))))
    )
  )
  lst1
)

;;;<> ESHOP-CENTROIDE  
;;;++ DESCRIÇÃO: RETORNA CENTRO POLILINHA
;;;++ ENTRADA: str1:elemento polilinha
;;;++ SAIDA: ponto centroide
(defun ESHOP-CENTROIDE (elm1   /      ety1   lst1   ety1   int1
			int2   int3   int4   int5   int6   int7
			int8   int9   int10  int11  int12  x
		       )
  (setq	ety1 (entget elm1)
  )
  (foreach x ety1
    (if	(= (car x) 10)
      (PROGN
	(setq varx (atof (rtos (cadr x) 2 0))
	      vary (atof (rtos (last x) 2 0))
	)
	(setq lst1 (append lst1 (list (list varx vary 0.0))))
      )
    )
  )
  (setq int1 (length lst1))
  (setq lst1 (append lst1 (list (car lst1))))

  (setq	int12
	 (/ (- (apply
		 '+
		 (mapcar '* (mapcar 'car lst1) (cdr (mapcar 'cadr lst1)))
	       )
	       (apply
		 '+
		 (mapcar '* (mapcar 'cadr lst1) (cdr (mapcar 'car lst1)))
	       )
	    )
	    2
	 )
  )
  (setq
    int2 0
    int3 0
    int4 0
    int5 nil
    int6 nil
    int7 nil
    int8 nil
    int9 nil
    int10 nil
  )
  (repeat int1
    (setq
      int5  (nth int4 lst1)
      int4  (1+ int4)
      int6  (nth int4 lst1)
      int7  (car int5)
      int8  (car int6)
      int10 (cadr int6)
      int9  (cadr int5)
      int11 (- (* int7 int10) (* int8 int9))
      int2  (+ int2 (* (+ int7 int8) int11))
      int3  (+ int3 (* (+ int9 int10) int11))
    )
  )
  (list	(/ int2 (* 6 int12))
	(/ int3 (* 6 int12))
  )
)


;;;<> ESHOP-CRI_PLL_MNL
;;;++ DESCRIÇÃO: CRIA POLILYNE A PARTIR DE PONTOS DO USUARIO, CLICADOS NA TELA
;;;++ ENTRADA: COMANDOS CLICADOS NA TELA
;;;++ SAIDA: POLILYNE, E O RETORNO É O ENTITYNAME DA POLILYNE CRIADA
(defun ESHOP-CRI_PLL_MNL (/ pto1 int1 var1 pto2)
  (if (setq pto1 (getpoint "\n=> Defina Ponto Inicial:"))
    (progn (setq int1 0
		 var1 "\n-> Defina Segundo Ponto:"
	   )
	   (while (setq pto2 (getpoint pto1 var1))
	     (if (= int1 0)
	       (progn (command "_.pline")
		      (command "_NON" pto1 "_NON" pto2)
		      (setq int1 1
			    pto1 pto2
			    var1 "\n-> Proximo ponto ou tecle <ENTER> para encerrar:"
		      )
	       )
	       (progn (command "_NON" pto2) (setq pto1 pto2))
	     )
	   )
	   (if (= (getvar "cmdactive") 1)
	     (command "")
	   )
    )
    (princ "\n-> Ponto inicial não fornecido!")
  )
  (entlast)
)

;;;<> ESHOP-EXC_DUP >>>> PONTOS_DUPLICADOS
;;;++ DESCRIÇÃO: EXTRAI PONTOS DE UMA POLILYNE INCLUSIVE PONTO REPETIDO
;;;++ ENTRADA: elm1:ELEMENTO POLILYNE
;;;++ SAIDA: PONTOS DA POLILINHA EM LISTA
(defun ESHOP-RTN_PTO_PLL (elm1 / lst1 x int1)
  (setq etg1 (entget elm1))
  (foreach x etg1
    (if	(= (car x) 10)
      (setq lst1 (append lst1 (list (cdr x))))
    )
  )
  (setq int1 (cdr (assoc 70 etg1)))
  (if (or (= int1 1) (= int1 129))
    (setq lst1 (append lst1 (list (car lst1))))
  )
  lst1
)


;;;<> ESHOP-CRR_PLL_LST
;;;++ DESCRIÇÃO: CRIA POLILINHA A PARTIR DE UMA LISTA DE PONTOS
;;;++ ENTRADA: lst1:lista de pontos 
;;;++ SAIDA: polilinha gerada
(defun ESHOP-CRR_PLL_LST (lst1 / x)
  (command ".pline")
  (foreach x lst1 (command x))
  (command "")
  ;(command "c")
)




;;;<> ESHOP_ADD_VERTICE
;;;++ DESCRIÇÃO: ADICIONA UM VERTICE EM UMA POLILINHA
;;;++ ENTRADA: pt1x:PONTO A INSERIR  polilinha 
;;;++ SAIDA: polilinha gerada
(defun ESHOP_ADD_VERTICE (ent1 pt1 / )
      (command "pedit" ent1 "")
      (command "break" ent1 pt1 pt1)
      (command "pedit" ent1 "j" (entlast) "" "")  
)





