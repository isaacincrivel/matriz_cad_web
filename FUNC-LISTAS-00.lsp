
;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>  MANIPULAÇÃO LISTAS    <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


;;;;<> ESHOP-EXC_ELM_LST  >>>>>>> REMOVE-ELEM-LISTA
;;;;++ DESCRIÇÃO: REMOVE ELMENTO DE UMA LISTA 
;;;;++ ENTRADA:  INT1:POSIÇÃO DO ELEMENTO A SER RETIRADO; LST1:LISTA A SER TRATADA
;;;;++ SAIDA: LISTA SEM O ELEMENTO RETIRADO
(defun ESHOP-EXC_ELM_LST (int1 lst1 / c x)
  (setq c -1)
  (apply 'append
	 (mapcar '(lambda (x)
		    (if	(/= (setq c (1+ c)) int1)
		      (list x)
		    )
		  )
		 lst1
	 )
  )
)

;;;;<> ESHOP-EXC_LST_LST  >>>>>>> REMOVE-ELEMS-LISTA
;;;;++ DESCRIÇÃO: EXCLUI OS ELEMENTOS DE UMA LISTA DA OUTRA LISTA
;;;;++ ENTRADA:  LST1:LISTA REMOVEDORA; LST2:LISTA PRINCIPAL
;;;;++ SAIDA: LISTA COM OS ELEMENTOS RETIRADOS
(DEFUN ESHOP-EXC_LST_LST (LST1 LST2 /)
  (FOREACH X LST1
    (SETQ LST2 (VL-REMOVE X LST2))
  )
  (SETQ LST2 LST2)
)

;;;<> ESHOP-CRR_LST_CRT_IGU
;;;++ DESCRIÇÃO: CRIA LISTA COM CARACTERES IGUAIS REPETIDOS
;;;++ ENTRADA: VAR1:ELEMENTO A SER REPETIDO; INT1:QUANTIDADE A SER REPETIDA
;;;++ SAIDA: LISTA COM ESSES ELEMENTOS REPETIDOS
(defun ESHOP-CRR_LST_CRT_IGU (var1 int1 / lst1)
  (repeat int1
    (setq lst1 (append lst1 (list var1)))
  )
  lst1
)


;;;<> ESHOP-TRS_STR_LST_PRR
;;;++ DESCRIÇÃO: TRANFORMA UMA STRING EM LISTAS, O DELIMITADOR É O PARAMENTRO 
;;;++ ENTRADA: str1:STRING COMPLETA; crt1:CARACTERE DELIMITADOR PARA DEFINIR LISTA
;;;++ SAIDA: LISTA COM VARIAS LINHAS DA STRING DEFINIDAS PELO DELIMITADOR
(defun ESHOP-TRS_STR_LST_PRR (str1 crt1 / int1 int2 str2 lst1 crt2)
  (setq	int1 (strlen str1)
	int2 1
	str2 ""

  )
  (while (<= int2 int1)
    (setq crt2 (substr str1 int2 1))
    (if	(= crt2 crt1)
      (progn
	(setq lst1 (cons str2 lst1))
	(setq str2 "")
      )
      (progn
	(setq str2 (strcat str2 crt2))
	(if (= int2 int1)
	  (progn
	    (setq lst1 (cons str2 lst1))

	  )
	)
      )
    )
    (setq int2 (1+ int2))
  )
  (reverse lst1)
)


;;;<> ESHOP-TRS_STR_LST_PRR
;;;++ DESCRIÇÃO: CRIA LISTA SEQUENCIAL A PARTIR DE ENTRADAS A PARTIR DE (NUMERO) ATE (NUMERO)
;;;++ ENTRADA: int1:PONTO INICIAL; int2:PONTO FINAL
;;;++ SAIDA: LISTA COM PONTOS SEQUENCIAIS
(DEFUN ESHOP-CRR_LST_SEQ (int1 int2 / lst1)
  (setq lst1 nil)
  (while (> int2 int1)
    (if	(= lst1 nil)
      (setq lst1 (list (rtos int1 2 0)))
      (setq lst1 (append lst1 (list (rtos int1 2 0))))
    )
    (setq int1 (1+ int1))
  )
  lst1
)


;;;<> ESHOP-SBT_ELM_LST_SEQ
;;;++ DESCRIÇÃO: SUBSTITUIR ELENTO EM UMA LISTA POR UMA SEQUENCIA
;;;++ ENTRADA: var1:Elemento para entrar na lista; int1:sequencia a substituir; lst1:lista original
;;;++ SAIDA: LISTA ATUALIZADA COM ELEMENTO SUBSTITUIDO
(defun ESHOP-SBT_ELM_LST_SEQ (var1 int1 lst1 / var2)
  (cond	((or (< int1 0) (>= int1 (length lst1))) lst1)
	((< int1 (/ (length lst1) 2))
	 (repeat int1
	   (setq var2	(cons (car lst1) var2)
		 lst1	(cdr lst1)
	   )
	 )
	 (append (reverse var2) (list var1) (cdr lst1))
	)
	(t
	 (setq lst1 (reverse lst1))
	 (repeat (- (length lst1) int1)
	   (setq var2	(cons (car lst1) var2)
		 lst1	(cdr lst1)
	   )
	 )
	 (append (reverse lst1) (list var1) (cdr var2))
	)
  ) 
)


;;;<> ESHOP-MNT_LST_RLC
;;;++ DESCRIÇÃO: Uma lista tem valores, outra tem titulos, e a outra é a referencia titulo do banco à organizar
;;;++ ENTRADA: lst1:lista com valores; lst2:lista com titulos; lst3:titulo referencia
;;;++ SAIDA: list aorganizada e lista de titulo acrescentada valores

(defun ESHOP-MNT_LST_RLC ( lst2 lst1 lst3 / lst4	int1 x)
  (setq lst4 (ESHOP-CRR_LST_CRT_IGU "" (length lst3)))
  (setq int1 0)
  (foreach x lst2
    (if	(member x lst3)
      (setq lst3 lst3)
      (setq lst3 (append lst3 (list x)))
    )
    (setq lst4 (ESHOP-SBT_ELM_LST_SEQ
		 (nth int1 lst1)
		 (vl-position (nth int1 lst2) lst3)
		 lst4
	       )
    )
    (setq int1 (1+ int1))
  )
  (list lst4 lst3)
)

;;;<> ESHOP-CRR_LST_PRS
;;;++ DESCRIÇÃO: Cria lista de pares associados utilizando duas listas
;;;++ ENTRADA: lst1:lista com valores 1; lst2:lista com valores 2; lst3:titulo referencia
;;;++ SAIDA: ((cons x 1)(cons y 2)...)

(defun ESHOP-CRR_LST_PRS (lst1 lst2 / lst3 int1 x )
  (setq int1 0)
  (foreach x lst1
    (setq lst3 (append lst3
		       (list (cons x
				   (nth	int1
					lst2
				   )
			     )
		       )
	       )
    )
    (setq int1 (1+ int1))
  )
  lst3
)