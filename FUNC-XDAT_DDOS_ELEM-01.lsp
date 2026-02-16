

;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><> XDATA, DADOS ELEMENTO  <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



;;;<> ESHOP-DDS_ELM
;;;++ DESCRIÇÃO: Retorna dados elementos em forma lista
;;;++ ENTRADA: elm1:Elemento a extrair dados;
;;;++ SAIDA: lista com dados (xdata)
(defun ESHOP-DDS_ELM
       (elm1 xdt1 / x int1 lst1 lst2 lst3 var1 var2 var3 var4)

  ;; <> ESHOP-DDS_XDTA_LST - função interna comando
  (defun ESHOP-DDS_XDTA_LST (lst1 / x int1 int2 lst2 lst3 var1 var2)
    (setq int1 0
	  int2 0
    )
    (while (= int2 0)
      (setq x	 (car lst1)
	    lst1 (cdr lst1)
      )
      (if (and (/= x "{") (/= x "}"))
	(progn
	  (if var1
	    (setq var2 x
	    )
	    (setq var1 x
	    )
	  )
	  (if (and (/= var1 nil) (/= var2 nil))
	    (progn
	      (setq lst2 (append lst2 (list (cons var1 var2))))

	      (setq var1 nil
		    var2 nil
	      )
	    )
	  )
	)
      )
      (if (and (= x "}") (= (car lst1) "}"))
	(progn
	  (setq int2 1)
	)
      )
      (setq int1 (1+ int1))
    )
    (setq lstx (cdr lst1))
    (list lst2 lstx)
  )

  (setq lst1 (car (cdr (assoc -3 (entget elm1 (LIST xdt1))))))
  (setq	var4 (car lst1)
	lst1 (cdr lst1)
  )
  ;; (setq lst1 (cdr (car (cdr (assoc -3 (entget elm1 (LIST "*")))))))
  (setq var1 (cdr (car lst1))) ;_ Extrai var1uencia ponto
  (setq lst1 (cdr lst1))
  (setq lst2 nil)
  (foreach x lst1
    (setq lst2 (append lst2 (list (cdr x))))
  )
  (setq	int1 0
	lst3 nil
  )
  (setq lst1 lst2)
  (setq lst3 (append lst3 (list (cons "seq" var1))))

  (if (/= lst1 nil) ;; xxxx
  (while (= int1 0)
    (setq var2 (car (cdr lst1))
	  lst1 (cdr (cdr lst1))
    )
    (setq var3 (ESHOP-DDS_XDTA_LST lst1)
	  lst1 (car (cdr var3))
    )
    (setq lst3 (append lst3 (list (cons var2 (list (car var3)))))) ;_ função x cria os cons
    (setq var3 nil)
    ;(if	(<= (length lst1) 1)
      (if	(< (length lst1) 1)
      (setq int1 1)
    )
  );; xxxx
    )
  
  (list var4 lst3)
)


;;;<> ESHOP-PRX_ID   >>>>>LOCALIZAR_SEQ
;;;++ DESCRIÇÃO: PROUCURA A CATEGORIA SOLICITADA E RETORNA O NUMERO DISPONIVEL PARA UTILIZAR NOVO ELEMENTO
;;;++ ENTRADA:  str1:XDATA
;;;++ SAIDA: SEQUENCIA DISPONIVEL
(defun ESHOP-PRX_ID (str1 / int1 int2 int3 int4 sel1 lst1)
  (if (= (setq sel1 (ssget "x" (list (list -3 (list str1)))))
	 nil
      )
    (setq int1 1)
    (progn
      (setq int2 (sslength sel1))
      (while (> int2 0)
	(setq lst1


	       (append
		 lst1
		 (list
		   (ESHOP-BSC_SEQ_XDT
		     (ssname sel1 (- int2 1))
		     str1
		   )
		 )
	       )
	)
	(setq int2 (- int2 1))
      )
      (setq lst1 (ESHOP-ORD_INT lst1))
      (setq int3 0)
      (setq int4 0)
      (while (= int4 0)
	(if
	  (or
	    (= (member (setq int3 (+ int3 1))
		       lst1
	       )
	       nil
	    )
	    (= lst1 nil)
	  )
	   (setq int1 int3
		 int4 1
	   )
	)
      )
    )
  )
  (setq int1 int1)
)

;;;;<> ESHOP-BSC_SEQ_XDT >>>> BUSC_COLUN_ELM
;;;;++ DESCRIÇÃO: BUSCA SEQUENCIA DE UM DETERMINADO XDATA
;;;;++ ENTRADA: elm1:ELEMENTO <> str1:XDATA A SER BUSCADO
;;;;++ SAIDA: DADO DA COLUNA DO XDATA REQUERIDO
;;;(DEFUN ESHOP-BSC_SEQ_XDT (elm1 str1 / var1)
;;;  (SETQ var1 (entget elm1 (LIST str1)))
;;;  (CDR
;;;    (NTH 0 (DXF (CAR (CAR (DXF -3 var1))) (DXF -3 var1)))
;;;  )
;;;)

(defun ESHOP-BSC_SEQ_XDT (elm1 str1 / var1)
  (setq var1 (entget elm1 (list str1)))
  (cdr
    (nth 0
	 (cdr (assoc (car (car (cdr (assoc -3 var1))))
		     (cdr (assoc -3 var1))
	      )
	 )
    )
  )
)

;;;<> ESHOP-BSC_TAB_CLN
;;;++ DESCRIÇÃO: Busca tabela solicitada no endereço padrão, e retorna sua coluna correspondente
;;;++ ENTRADA: str1:Nome da tabela, sem o CSV; int1:Indice a ser retornado
;;;++ SAIDA: Lista com os dados na tabela
(defun ESHOP-BSC_TAB_CLN (str1 int1 /)
  (ESHOP-RTN-CLN-LST
    (ESHOP-CNV-CSV-LST
      (STRCAT CAMINHO-TABELA "\\" str1 ".csv")
    )
    int1
  )
)

;;;<> ESHOP-CLC_XDT_ELM
;;;++ DESCRIÇÃO: ESCREVE, OU ADICIONA O XDATA NO ELEMENTO
;;;++ ENTRADA: elm1:ELEMENTO <> xdt1:XDATA A SER ESCRITO ide1:sequencia do xdata lst1:lista a ser escrita
;;;++ SAIDA: DADOS ESCRITOS NO ELEMENTO
(defun ESHOP-CLC_XDT_ELM (elm1 xdt1 ide1 lst1 /)
  (regapp (strcase xdt1 1))
  (entmod
    (append (entget elm1)
	    (list
	      (cons -3
		    (list (cons xdt1 (ESHOP-MNT_LST_DAD ide1 lst1)))
	      )
	    )
    )
  )
)

;;;<> ESHOP-CLC_XDT_SEQ
;;;++ DESCRIÇÃO: ESCREVE, OU ADICIONA O XDATA NO ELEMENTO COM SOMENTE A SEQUENCIA
;;;++ ENTRADA: elm1:ELEMENTO <> xdt1:XDATA A SER ESCRITO ide1:sequencia do xdata 
;;;++ SAIDA: XDTA E SEQUENCIA ESCRINA NO ELEMENTO
(defun ESHOP-CLC_XDT_SEQ (elm1 xdt1 ide1 /)
  (regapp (strcase xdt1 1))
  (entmod
    (append (entget elm1)
	    (list
	      (cons -3
		    (list (cons xdt1 (list (cons 1070 ide1))))
	      )
	    )
    )
  )
)



;;;<> ESHOP-DEL_XDTA_ELM
;;;++ DESCRIÇÃO: ROTINA APAGAR TODAS AS XDATAS DO ELEMENTO
;;;++ ENTRADA: elm1:ssname do elemento
;;;++ SAIDA: ELEMENTO SEM O XDTA
(defun ESHOP-DEL_XDTA_ELM (elm1 / xdt1 ety1)
  (setq ety1 (entget elm1 '("*")))
  (setq xdt1 (assoc '-3 ety1))
  (setq	ety1
	 (subst	(cons (car xdt1) (list (list (car (car (cdr xdt1))))))
		xdt1
		ety1
	 )
  )
  (entmod ety1)
  elm1
)

;;;<> ESHOP-MUD_DDS_XDT
;;;++ DESCRIÇÃO: Modifica tabelas (PLURAL) do elemento, entrada lista com tabelas e lista com valores
;;;++ ENTRADA:elm1:elemento para mudar xdata; xdta1:xdata a ser modificada; prr1:chave a ser mudada ex:dds_grl; lst1:lista a ser modificada; lst2:valores a ser modificados
;;;++ SAIDA: Modifica as tabelas do elemento e retorna a sequencia do elemento
(defun ESHOP-MUD_DDS_XDT
       (elm1 xdt1 prr1 lst1 lst2 / lst3 lst4 int1 int2 x var1)
  (setq lst3 (ESHOP-DDS_ELM elm1 xdt1))
  (setq int1 (cdr (car (cadr lst3))))
  (setq lst4 (cadr (assoc prr1 (cadr lst3))))
  (setq int2 0)
  (foreach x lst1
    (setq var1 (nth int2 lst2))
    (setq lst4 (subst (cons x var1)
		      (assoc x lst4)
		      lst4
	       )
    )
    (setq int2 (1+ int2))
  )
  (ESHOP-CLC_XDT_ELM
    (ESHOP-DEL_XDTA_ELM elm1)
    xdt1
    int1
    (list (list prr1 lst4))
  )
  int1
)

;;;<> ESHOP-RTN_XDT_VLR1  
;;;++ DESCRIÇÃO: RETORNA VALOR DE UM CAMPO NO XDTA, DENTRO DE UM PARAMETRO
;;;++ ENTRADA: XDT:XDTA ELEMENTO; PRR1:PARAMETRO ENTRADA EX"dad_grl"; PRR2:CAMPO SOLICITADO EX"clt_ptoentrega"
;;;++ SAIDA: VALOR DO CAMPO SOLICITADO
(defun ESHOP-RTN_XDT_VLR1 (xdt1 prr1 prr2 elm1 /)
  (cdr
    (assoc prr2
	   (cadr (assoc prr1 (cadr (ESHOP-DDS_ELM elm1 xdt1))))
    )
  )
)


;;;<> ESHOP-RTN_XDT_SEL   >>>>>>>>> SOMENTE_XDATA
;;;++ DESCRIÇÃO: DEIXA NA SELEÇÃO SOMENTE O XDATA ESCOLHIDO RETIRANDO TODAS AS OUTRAS ENTIDADES
;;;++ ENTRADA: sel1:seleção de elementos ; xdat:xdata para retornar
;;;++ SAIDA: lista com somente os elementos xdatas.

(defun ESHOP-RTN_ELM_XDT_SEL (sel1 xdt1 / int1 int2 elm1)

  (setq int1 0)
  (setq int2 (sslength sel1))
  (while (> int2 int1)
    (setq elm1 (ssname sel1 int1))
    (if	(cdr
	  (assoc xdt1
		 (cdr (assoc -3 (entget elm1 (list xdt1))))
	  )
	)
      (setq int1 (+ int1 1))
      (ssdel elm1 sel1)

    )
    (setq int2 (sslength sel1))
  )
  (if (= (sslength sel1) 0)
    (setq sel1 nil)
  )
  (setq sel1 sel1)
)


;;;<> ESHOP-XDTS_ELM
;;;++ DESCRIÇÃO: RETORNA TODOS OS XDATAS DO ELEMENTO
;;;++ ENTRADA: elm:SSNAME DO ELEMENTO
;;;++ SAIDA: LISTA COM O XDATAS
(DEFUN ESHOP-RTN_XDT_ELM (elm1 /)
  (cdr (assoc -3 (entget elm1 (LIST "*"))))
)


;;;<> ESHOP-MD_ETY_ELM
;;;++ DESCRIÇÃO: MODIFICA ELEMENTO SOLICITANDO CARACTERISTICAS
;;;++ ENTRADA: elm1:elemento, dxf1:qual dxf vai mudar, var1:novo valor caracteristica 
;;;++ SAIDA: ELEMENTO ALTERADO
(defun ESHOP-MUD_CRC_ELM (elm1 dxf1 str1 / ety1)
  (if (= dxf1 2)
    (progn
      (if (not (tblsearch "BLOCK" str1))
	(progn
	  (command "_.INSERT" str1)
	  (command)
	)
      )
    )
  )
  (setq ety1 (entget elm1))
  (setq	ety1 (subst (cons dxf1 str1)
		    (assoc 2 ety1)
		    ety1
	     )
  )
  (entmod ety1)
)



;;;<> ESHOP-DAD_GRL
;;;++ DESCRIÇÃO: retorna dados do elemento selecionado
;;;++ ENTRADA: 
;;;++ SAIDA: LISTA COM OS DADOS SOLICITADOS
(defun ESHOP-DAD_GRL (xdt1 elm1 lst1 / x lst2)
  (foreach x lst1
    (setq lst2
	   (append
	     lst2
	     (list
	       (cdr
		 (assoc
		   x
		   (car
		     (cdr
		       (assoc "dad_grl" (cadr (ESHOP-DDS_ELM elm1 xdt1)))
		     )
		   )
		 )
	       )
	     )
	   )
    )
  )
  lst2
)


;;;<> ESHOP-MNT_LST_DAD
;;;++ DESCRIÇÃO: CRIA ASSOCIAÇÃOD E PARES DE LISTA EX:(1000 "123"). SE NA LISTA TIVER UM PONTO (X,Y) COLOCA-SE 1010
;;;++ ENTRADA: lst:LISTA COM STRINGS '("123" "134")
;;;++ SAIDA: LISTA COM OS PARES ASSOCIADOS)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CORRIGIR VARIAVEIS LOCAIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CORRIGIR VARIAVEIS LOCAIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CORRIGIR VARIAVEIS LOCAIS
(defun ESHOP-MNT_LST_DAD (ide1 lst1 / var1 var2 lst2 x y y2 z lst2)
  (setq lst2 (append lst2 (list (cons 1070 ide1))))
  (if (/= lst1 nil)
    (progn
      (foreach x lst1
	(setq lst2 (append lst2 (list (cons 1002 "{"))))
	(setq var2 (car x))
	(cond
	  ((= (type var2) (type "STR")) (setq var2 1000))
	  ((= (type var2) (type 10)) (setq var2 1070))
	)
	(setq lst2 (append lst2 (list (cons var2 (car x)))))
	(foreach y (cadr x)
	  (setq y2 (car Y))
	  (setq lst2 (append lst2 (list (cons 1002 "{"))))
	  (cond
	    ((= (type y2) (type "STR")) (setq var1 1000))
	    ((= (type y2) (type 10)) (setq var1 1070))
	  )
	  (setq lst2 (append lst2 (list (cons var1 y2))))
	  ;; se for colocar lista posteriormente habilitar o foreach z
					;(foreach z (cdr Y)
	  (setq z (cdr y))
	  (cond
	    ((= (type z) (type "STR")) (setq var1 1000))
	    ((= (type z) (type 10)) (setq var1 1070))
	    ((= (type z) (type 1.2)) (setq var1 1040))
	    ((= (type z) (type (list 0 0 0)) (setq var1 1010)))
	  )

	  (if (= lst2 nil)
	    (setq lst2 (list (cons var1 z)))
	    (setq lst2
		   (append lst2
			   (list (cons var1 z))
		   )
	    )
	  )
					; )
	  (setq lst2 (append lst2 (list (cons 1002 "}"))))
	) ;_foreach y
	(setq lst2 (append lst2 (list (cons 1002 "}"))))
      ) ;_foreach x
    )
  )
  (setq lst2 lst2)
)