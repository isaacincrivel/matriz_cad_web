
;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><> CSV, TEXTO, CONVERSÃO  <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


;;;<> ESHOP-CNV-CSV-LST   >>>>>CSV->LISTA_DADOS
;;;++ DESCRIÇÃO: PEGA O ARQUIVO CSV E TRASFORMA NO FORMATO (("XXXX" "YYYY" "ZZZZ")("AAAA" "BBBB" "CCCC"))
;;;++ ENTRADA:  ENDEREÇO CSV
;;;++ SAIDA: LISTA FORMATO (("XXXX" "YYYY" "ZZZZ")("AAAA" "BBBB" "CCCC"))

(defun ESHOP-CNV-CSV-LST (str1 / lst1 lst2 str2 arq1)
  (SETQ arq1 (OPEN str1 "r"))
  (while (setq str2 (read-line arq1))
    (progn
      (setq lst1 (ESHOP-CNV-STR-LST str2))
      (if lst1
	(if lst2
	  (setq lst2 (append lst2 (list lst1)))
	  (setq	lst2 lst1
		lst2 (list lst2)
	  )
	)
      )
      (setq lst1 nil
	    lst1 nil
      )
    )
  )
  (close arq1)
  lst2
)



;;;<> ESHOP-CNV-CSV-LST-MAISCULA   >>>>>CSV->LISTA_DADOS
;;;++ DESCRIÇÃO: PEGA O ARQUIVO CSV E TRASFORMA NO FORMATO (("XXXX" "YYYY" "ZZZZ")("AAAA" "BBBB" "CCCC")), COM TODAS AS LETRAS EM MAIUSCULAS
;;;++ ENTRADA:  ENDEREÇO CSV
;;;++ SAIDA: LISTA FORMATO (("XXXX" "YYYY" "ZZZZ")("AAAA" "BBBB" "CCCC"))

(defun ESHOP-CNV-CSV-LST-MAISCULA (str1 / lst1 lst2 str2 arq1)
  (SETQ arq1 (OPEN str1 "r"))
  (while (setq str2 (read-line arq1))
    (setq str2 (strcase str2))
    (progn
      (setq lst1 (ESHOP-CNV-STR-LST str2))
      (if lst1
	(if lst2
	  (setq lst2 (append lst2 (list lst1)))
	  (setq	lst2 lst1
		lst2 (list lst2)
	  )
	)
      )
      (setq lst1 nil
	    lst1 nil
      )
    )
  )
  (close arq1)
  lst2
)

;;;;<> ESHOP-JNT-LST-LST
;;;;++ DESCRIÇÃO: CRIA UMA NOVA LISTA COM PARES DE DUAS LISTAS
;;;;++ ENTRADA:  LST1:LISTA 1 ; LST2:LISTA 2 (EX: ("AA" "BB" "CC") E ("1" "2" "3"), A NOVA LISTA (("AA" "1") ("BB" "2") ("CC" "3"))
;;;;++ SAIDA: LISTA CRIADA COM PARES
(defun ESHOP-JNT-LST-LST (lst1 lst2 / int1 x lst3)
  (setq int1 0)
  (foreach x lst1
    (setq lst3 (append lst3 (list (cons x (nth int1 lst2)))))
    (setq int1 (1+ int1))
  )
  lst3
)

;;;;<> ESHOP-CRR-LST-ITM
;;;;++ DESCRIÇÃO: CRIA UMA LISTA COM SOMENTE O ITEM SOLICITADO
;;;;++ ENTRADA:  str1:item a ser repetido ; int1:quantidade a ser repetida
;;;;++ SAIDA: LISTA CRIADA ELEMENTOS IGUAIS
(defun ESHOP-CRR-LST-ITM (str1 int1 / lst1)
  (repeat int1
    (setq lst1 (append lst1 (list str1)))
  )
  lst1
)

;;;<> ESHOP-TRS_LST_TXT_VAR   --- ANTIGO LSTTEXTO_PARA_VAR
;;;++ DESCRIÇÃO:  duas listas, uma com string (sera transformada em variavel) e outra com valores
;;;++ ENTRADA:  lst1:lista texto lst2:lista valores
;;;++ SAIDA: SEQUENCIA DISPONIVEL
(defun ESHOP-TRS_LST_TXT_VAR (lst1 lst2 / int1 x)
  (setq int1 0)
  (foreach x lst1
    (set (read x) (nth int1 lst2))
    (setq int1 (1+ int1))
  )
)

;;;<> ESHOP-RTN-CLN-LST RETORNA COLUNA DA LISTA (INDICE) >>>>>>>LST->LST-INDICE
;;;++ DESCRIÇÃO:  RETORNA INDIDE DE UMA LISTA (COLUNA)
;;;++ ENTRADA:  (("WEWR" "DSFLJSDFLKJ" "SLDKFJ")("WDSF" "DSFLJSDFLKJ" "SLDKFJ")("WEWR" "DSFLJSDFLKJ" "SLDKFJ"))
;;;++ SAIDA: (("WEWR")("WDSF")), SE INDICE FOR 0
(DEFUN ESHOP-RTN-CLN-LST (lst1 int1 / var1 x)
  (SETQ	var1 (MAPCAR '(LAMBDA (x) (NTH int1 x)) lst1)
;;;	var1 (IF (> (LENGTH var1) 1)
	
;;;	       (ACAD_STRLSORT var1)
;;;	       var1
;;;	     )
  )
)

;;;<> ESHOP-CNV-STR-LST   >>>>>STRING->LISTA
;;;++ DESCRIÇÃO: PEGA O TXT NO FORMADO XXXX;YYYY;ZZZZ E JOGA NO FORMATO (XXXXX YYYY ZZZZZ)
;;;++ ENTRADA:  TEXTO "XXXXX;YYYYY;ZZZZ"
;;;++ SAIDA: LISTA (XXXXX YYYY ZZZZ)
(defun ESHOP-CNV-STR-LST (str1 / int1 int2 str2 crt1 lst1)
  (setq	int1 (strlen str1)
	int2 1
	str2 ""
  )
  (while (<= int2 int1)
    (setq crt1 (substr str1 int2 1))
    (if	;(or
	  (= crt1 ";")
	  ;(= crt1 ",")
	  ;)
      (progn
	(setq lst1 (cons str2 lst1))
	(setq str2 "")
      )
      (progn
	(setq str2 (strcat str2 crt1))
	(if (= int2 int1)
	  (setq lst1 (cons str2 lst1))
	)
      )
    )
    (setq int2 (1+ int2))
  )
  (reverse lst1)
)

;;;<> ESHOP-CNV_LST_STR_CSV   >>>>>STRING->LISTA
;;;++ DESCRIÇÃO: PEGA O lista de txt no formato (XXXXX YYYY ZZZZ) E JOGA NO FORMATO XXXX;YYYY;ZZZZ, para ser inmpresas no cvs
;;;++ ENTRADA:  LISTA (XXXXX YYYY ZZZZ)
;;;++ SAIDA: TEXTO  XXXX;YYYY;ZZZZ
(defun ESHOP-CNV_LST_STR_CSV (lst1 / lst1 lst2 str1 x y)
  (setq lst2 nil)
  (setq str1 "")

  
  (foreach x lst1
    (foreach y x
      (if (= lst2 nil)
	(setq lst2 (vl-princ-to-string y))
	(setq lst2
	       (strcat lst2
		       ";"
		       (vl-princ-to-string y)
	       )
	)

      )
    )

    
    (setq str1 (strcat str1
		       lst2
		       "\n"
	       )
    )
    (setq lst2 nil)
  )
  str1
)


;;;<> ESHOP-IMP_TAB_CVS
;;;++ DESCRIÇÃO: cria o arquivo csv, o nome é baseado no xdata e imprime nele
;;;++ ENTRADA: xdt1:xdata para criar nome arquivo; str1:o que sera impresso no arquivo; end1:endereço que sera criado
;;;++ SAIDA: arquivo e tabela criada.
(defun ESHOP-IMP_TAB_CVS (xdt1 str1 end1 / arq)
  (setq	arq (open
	      (strcat end1
		      "\\"
		      xdt1
		      ".csv"
	      )
	      "w"
	    )
  )
  (princ str1 arq)
  (close arq)
)




;;;<> ESHOP-CNV-STR-LST-DELIMITADOR   >>>>>STRING->LISTA
;;;++ DESCRIÇÃO: PEGA O TXT NO FORMADO XXXX_YYYY_ZZZZ E JOGA NO FORMATO (XXXXX YYYY ZZZZZ) PODE UTILIZAR OUTRO DELIMINADOR _
;;;++ ENTRADA:  TEXTO "XXXXX;YYYYY;ZZZZ"
;;;++ SAIDA: LISTA (XXXXX YYYY ZZZZ)
(defun ESHOP-CNV-STR-LST-DELIMITADOR (str1 str3 / int1 int2 str2 crt1 lst1)
  (setq	int1 (strlen str1)
	int2 1
	str2 ""
  )
  (while (<= int2 int1)
    (setq crt1 (substr str1 int2 1))
    (if	;(or
	  (= crt1 str3)
	  ;(= crt1 ",")
	  ;)
      (progn
	(setq lst1 (cons str2 lst1))
	(setq str2 "")
      )
      (progn
	(setq str2 (strcat str2 crt1))
	(if (= int2 int1)
	  (setq lst1 (cons str2 lst1))
	)
      )
    )
    (setq int2 (1+ int2))
  )
  (reverse lst1)
)



;;;<> ESHOP-CSV-FECHADO-ABERTO   >>>>>STRING->LISTA
;;;++ DESCRIÇÃO: IDENTIFICA SE O ARQUIVO CSV ESTA ABERTO OU FECHADO
;;;++ ENTRADA:  ENDEREÇO DO ARQUIVO
;;;++ SAIDA: SINAL ABERTO OU FECHADO


(defun ESHOP-CSV-FECHADO-ABERTO (file / fh)
(if (setq fh (open file "a"))
(not (close fh))
)
)