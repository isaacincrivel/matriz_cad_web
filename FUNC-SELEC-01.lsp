;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>       SELEÇAO          <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


;;;<> ESHOP-CXA_PTOS  
;;;++ DESCRIÇÃO: RETORNA LISTA DE PONTOS FAZENDO UMA CAIXA COM REFERENCIA A DOIS PONTOS, bastante utilizada em seleção "cp"
;;;++ ENTRADA: PTO1:PONTO1; PTO2:PONTO2; ANG1:ANGULO EM TEXTO; DIS1:DISTANCIA DO PONTO;
;;;++ SAIDA: LISTA COM ESSES PONTOS.
(defun ESHOP-CXA_PTOS (pto1 pto2 ang1 dis1 / lst1 lst2 ang3 ang2)
  (setq	ang3 (angle pto1 pto2)
	ang2 (angle pto2 pto1)
  )
  (setq	lst1 (list (append (polar pto1 (+ ang3 (angtof ang1 0)) dis1)			   
		   )
		   (append (polar pto2 (- ang2 (angtof ang1 0)) dis1)			   
		   )
		   (append (polar pto2 (+ ang2 (angtof ang1 0)) dis1)			   
		   )
		   (append (polar pto1 (- ang3 (angtof ang1 0)) dis1)			   
		   )
	     )
	lst2 (ESHOP-MIN_MAX_LST lst1)
  )
  (command "zoom" (car lst2) (cadr lst2))
  lst1
)

;;;<> ESHOP-REDRAW_SEL
;;;++ DESCRIÇÃO: REDRAW EM SELEÇÃO
;;;++ ENTRADA: sel1:SELEÇÃO
;;;++ SAIDA: DESTACA ELEMENTOS
(defun ESHOP-REDRAW_SEL	(sel1 / int1)
  (if (/= sel1 nil)
    (progn
      (setq int1 0)
      (repeat (sslength sel1)
	(redraw (ssname sel1 int1) 3)
	(setq int1 (1+ int1))
      )
    )
  )
)

;;;<> ESHOP-SEL_UM_TXT  
;;;++ DESCRIÇÃO: ROTINA PARA SELECIONAR APENAS UM TEXTO - NÃO SAI DA ROTINA ENQUANTO NÃO SELECIONA SOMENTE UM TEXTO
;;;++ ENTRADA: str1:texto para apresentar no prompt a cada loop
;;;++ SAIDA: apenas um texto selecionado
(defun ESHOP-SEL_UM_TXT	(str1 / int1 str2 sel1)
  (setq int1 2)
  (setq	str2
	 (getstring
	   str1
	 )
  )
  (if (= str2 "")
    (while (> int1 1)
      (if (/= int1 2)
	(alert "selecione somente um texto")
      )
      (setq int1
	     (sslength (setq sel1
			      (ssget
				'((-4 . "<or")
				  (0 . "text")
					;(0 . "mtext")
				  (-4 . "or>")
				 )
			      )
		       )
	     )
      )
      (setq str2 (cdr (assoc 1 (entget (ssname sel1 0))))
      )
    )
  )
  str2
)


;;;<> ESHOP-SEL_ELM_CTR  <<<<<<< SELEC_ELEMENTO_CONTROLE 
;;;++ DESCRIÇÃO: SELECIONA ELEMENTO COM RESTRIÇÃO DE QUANTIDADE DE ELEMENTOS
;;;++ ENTRADA: xdt1:Tipode elemento que ira selecionar; str1:texto para escrever no momento da seleção; int:Quantidade maxima de elementos
;;;++ SAIDA: Seleção dos pontos
(defun ESHOP-SEL_ELM_CTR (xdt1 str1 int1 / int2 int3 sel1)
  (setq int2 0)
  (while (= int2 0)
    (princ str1)
    (setq sel1 (ssget (list (list -3 (list xdt1)))))
    (setq int3 (sslength sel1))
    (if	int3
      (if (> int3 int1)
	(alert (strcat "Numero Maximo de elementos permitiso :  "
		       (rtos int1)
	       )
	)
	(setq int2 1)
      )
      (princ (strcat "ERRO - " str1))
    )
    (setq sel1 sel1)
  )
  sel1
)

;;;<> ESHOP-JNT_2_SEL
;;;++ DESCRIÇÃO: JUNTA DOIS CONJUNTOS DE SELEÇÃO
;;;++ ENTRADA: sel1:PRIMEIRO CONJUNTO DE SELEÇÃO sel2:SEGUNDO CONJUNTO DE SELEÇÃO
;;;++ SAIDA: CONJUNTO DE SELEÇÃO COM SOMENTE ESSE TIPO DE OBEJETO.
(defun ESHOP-JNT_2_SEL (sel1 sel2 / int1)
  (Repeat (setq int1 (sslength sel1))
    (Ssadd (ssname sel1 (setq i (1- int1))) sel2)
  )
)


;;;<> ESHOP-RTN_SEL_PTO   >>>>>>>>> SELECAO_PONTO
;;;++ DESCRIÇÃO: RETORNA SELEÇÃO DE TODOS OS ELEMENTOS QUE ESTÃO NO PONTO NUM RAIO SOLICITADO
;;;++ ENTRADA: ptox: PONTO A VERIFICAR ; prrx: PARAMETRO RAIO A VERIFICAR; xdtx:xdata a ser buscado
;;;++ SAIDA: se existir duplicados retorna 1 se não nil
(defun ESHOP-RTN_SEL_PTO
			 (ptox	 prrx	xdtx   /      X	     Y
			  pto1	 pto2	pto3   pto4   pto5   pto6
			  pto7	 pto8	prr1   prr2   sel1   lst1
			 )
  (setvar "OSMODE" 0)
  (setq prrx (* prrx 1.0))
  (setq	X (nth 0 ptox)
	Y (nth 1 ptox)
  )
  (setq	prr2 (* 0.3827 prrx)
	prr1 (* 0.9239 prrx)
	pto1 (list (- X prr1) (+ Y prr2))
	pto2 (list (- X prr2) (+ Y prr1))
	pto3 (list (+ X prr2) (+ Y prr1))
	pto4 (list (+ X prr1) (+ Y prr2))
	pto5 (list (+ X prr1) (- Y prr2))
	pto6 (list (+ X prr2) (- Y prr1))
	pto7 (list (- X prr2) (- Y prr1))
	pto8 (list (- X prr1) (- Y prr2))
  )
  (setq	lst1
	 (ESHOP-MIN_MAX_LST
	   (list pto1 pto2 pto3 pto4 pto5 pto6 pto7 pto8 pto1)
	 )
  )
  (command "ZOOM" (car lst1) (cadr lst1))
  (command "REGEN")
  (if xdtx
    (ssget "cp"
	   (list pto1 pto2 pto3 pto4 pto5 pto6 pto7 pto8 pto1)
	   (list (list -3 (list xdtx)))
    )
    (ssget "cp"
	   (list pto1 pto2 pto3 pto4 pto5 pto6 pto7 pto8 pto1)

    )
  )
)