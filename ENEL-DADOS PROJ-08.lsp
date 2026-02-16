(defun GERAR_DADOS_PROJ+
			 (lst2
			  lst4
			  /
			  var2
			  var3
			  str1
			 )

  (setq int1 1)
  (setq int2 (length lst4))


  
 (setq var2 ""
       var3 ""
 )					; Coordenadas X e Y globais nesta função
 (setq str1 "")				; Distancia Total DISTANCIATOTAL



  (setq	listatitulo
	 (list "PROP_REDE"	     "LOC_REDE"
	       "TENSA0_KV"	     "SEQ"
	       "NUMERO POSTE"	     "UP_POSTE"
	       "UP_EST_MT_NIVEL1"    "UP_ISO_NIVEL1"
	       "UP_EST_MT_NIVEL2"    "UP_ISO_NIVEL2"
	       "UP_EST_MT_NIVEL3"    "UP_ISO_NIVEL3"
	       "UP_BT_NIVEL1"	     "UP_BT_NIVEL2"
	       "UP_ESTAI"	     "QDE_ESTAI"
	       "UP_BASE_SUBSOLO"     "QDE_BASE"
	       "UP_ATERR"	     "QDE_ATERR"
	       "UP_PARA_RAIOS"	     "QDE_PARA_RAIOS"
	       "UP_CHAVE"	     "NUM_CHAVE"
	       "TRAFO"		     "CT_TRAFO"
	       "UP_CABO_MT_FASE"     "CABO_MT_FASE"
	       "UP_CABO_BT_FASE"     "CABO_BT_FASE"
	       "UP_CABO_NEUTRO"	     "COORD_X"
	       "COORD_Y"	     "UP_AVULSO1"
	       "QDE_UP_AVULSO1"	     "UP_AVULSO2"
	       "QDE_UP_AVULSO2"	     "UP_AVULSO3"
	       "QDE_UP_AVULSO3"	     "UP_AVULSO4"
	       "QDE_UP_AVULSO4"	     "UP_AVULSO5"
	       "QDE_UP_AVULSO5"	     "UP_AVULSO6"
	       "QDE_UP_AVULSO6"	     "UP_AVULSO7"
	       "QDE_UP_AVULSO7"	     "UP_AVULSO8"
	       "QDE_UP_AVULSO8"	     "UP_AVULSO9"
	       "QDE_UP_AVULSO9"	     "UP_AVULSO10"
	       "QDE_UP_AVULSO10"     "UP_AVULSO11"
	       "QDE_UP_AVULSO11"     "UP_AVULSO12"
	       "QDE_UP_AVULSO12"     "UP_AVULSO13"
	       "QDE_UP_AVULSO13"     "UP_AVULSO14"
	       "QDE_UP_AVULSO14"     "UP_AVULSO15"
	       "QDE_UP_AVULSO15"     "UP_AVULSO16"
	       "QDE_UP_AVULSO16"     "UP_AVULSO17"
	       "QDE_UP_AVULSO17"     "UP_AVULSO18"
	       "QDE_UP_AVULSO18"     "UP_AVULSO19"
	       "QDE_UP_AVULSO19"     "UP_AVULSO20"
	       "QDE_UP_AVULSO20"

	     "SERV_AVULSO1"	"QDE_SERV_AVULSO1"
	     "SERV_AVULSO2"	"QDE_SERV_AVULSO2"
	     "SERV_AVULSO3"	"QDE_SERV_AVULSO3"
	     "SERV_AVULSO4"	"QDE_SERV_AVULSO4"
	     "SERV_AVULSO5"	"QDE_SERV_AVULSO5"

	     "UP_CABO_MT_DERIV_1"	"QDE_UP_MT_DERIV_1"
	     "UP_CABO_MT_DERIV_2"	"QDE_UP_MT_DERIV_2"
	     "UP_CABO_MT_DERIV_3"	"QDE_UP_MT_DERIV_3"
	     "UP_CABO_MT_DERIV_4"	"QDE_UP_MT_DERIV_4"
	     "UP_CABO_MT_DERIV_5"	"QDE_UP_MT_DERIV_5"
	       
	      )
  )
  (setq lista_matriz (list listatitulo))

  ;; INICIO LOOP DE INSTALAÇÃO POSTE E ESTRUTURA
  (repeat int2

    ;; Inicio ou Fim rede
    (setq var1 "meio")
    (if	(= int1 1)
      (setq var1 "inicio")
    )
    (if	(= int2 int1)
      (setq var1 "fim")
    )

    
;; DECLARANDO VARIAVEIS DO PONTO
    (setq lst1 (nth (- int1 1) lst4))
    (ESHOP-TRS_LST_TXT_VAR lst2 lst1)

    ;; Gerando lista vazia
    (setq lst5 (ESHOP-CRR_LST_CRT_IGU "" 93)) ; lista referencia

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;escrever cabo
    
(ENEL_DIST_DADOS_PROJ)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    ;; ulitmo ponto
    (if	(= var1 "inicio")
      ;;9999
      (progn

	;; SALVANDO VARIAVEIS GLOBAIS DA MATRIZ
	(setq GLB_CLIENTE
	       CLIENTE
	      GLB_INSCRICAO
	       INSCRICAO
	      GLB_PROJETO
	       PROJETO
	      GLB_CONSTRUTORA
	       CONSTRUTORA
	      GLB_MUNICIPIO
	       MUNICIPIO
	      GLB_TENSAO
	       TENSAO
	      GLB_TIPO TIPO
	)
	(if (= GLB_TENSAO "15")
	  (setq GLB_TENSAO "13,8")
	  (setq GLB_TENSAO "34,5")
	)
      )
    )
    (ENEL_MONTAR_ESTRUTURAS)

    ;; pontos do meio
;;;    (if	(= var1 "meio")
;;;      (progn
;;;
;;;      )
;;;    )

    ;; ulitmo ponto
;;;    (if	(= var1 "fim")
;;;      (progn
;;;
;;;      )
;;;    )

    (setq lista_matriz (append lista_matriz (list lst5)))

    (setq int1 (+ int1 1))
  )
  
(setq	GLB_NMARQUIVO (strcat GLB_TIPO "_DADOS_PROJ" "---" GLB_CLIENTE	"---INSC-" GLB_INSCRICAO "---" GLB_DATA ))
  
  (ENEL_IMPRIMIR  lista_matriz)
)

(defun ENEL_MONTAR_ESTRUTURAS (/ int5)
  (setq varxx 0)

  (setq int5 33)

;;; COLOCAR DADOS PADRAO
  (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "COMPANHIA" 0 lst5))
  (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "RURAL" 1 lst5))
  (setq lst5 (ESHOP-SBT_ELM_LST_SEQ GLB_TENSAO 2 lst5))
  (setq lst5 (ESHOP-SBT_ELM_LST_SEQ SEQ 3 lst5))
  (setq lst5 (ESHOP-SBT_ELM_LST_SEQ NM_POSTE 4 lst5))
  (setq lst5 (ESHOP-SBT_ELM_LST_SEQ POSTE 5 lst5))

  ;; UP DE SERVIÇO POSTE
  (if (/= POSTE "EXIST")
    (PROGN
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO110" int5 lst5)
	    int5 (1+ int5)
      )
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
	    int5 (1+ int5)
      )
      
    )
  )  

  (if (= ESTRUTURA "U3-U3")
    (progn
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "U3" 6 lst5))
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "U3" 8 lst5))
      (setq varxx 1)
    )
  )

  (if (= ESTRUTURA "U1-U3")
    (progn
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "U1" 6 lst5))
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "U3" 8 lst5))
      (setq varxx 1)
    )
  )
  (if (= ESTRUTURA "N1-U3")
    (progn
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "N1" 6 lst5))
      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "U3" 8 lst5))
      (setq varxx 1)
    )
  )
  
  (if (= varxx 0)
    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ ESTRUTURA 6 lst5))
  )

  
  ;;; UPS DE DERIVAÇÃO - SERVIÇO DE ELENCO COMPENSI
    (if	(= var1 "inicio")
      (progn

	(if (= ESTRUTURA "U3")
	  (progn
	    (IF	(= DERV_LV "SIM")
	      (PROGN
		;; SE A DERIVAÇÃO FOR COM LINHA VIVA SOLOCAR ITENS

		(setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO815" int5 lst5)
		      int5 (1+ int5)
		)
		(setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		      int5 (1+ int5)
		)

		(setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO820" int5 lst5)
		      int5 (1+ int5)
		)
		(setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		      int5 (1+ int5)
		)
	      )
	      (PROGN

		(setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO121" int5 lst5)
		      int5 (1+ int5)
		)
		(setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		      int5 (1+ int5)
		)
	      )
	    )
	  )
	)

	;; SE POSTE FOR INTERCALADO
	(if (and (= SEQ "1") (= DERV_LV "SIM"))
	  (PROGN

	    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO804" int5 lst5)
		  int5 (1+ int5)
	    )
	    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		  int5 (1+ int5)
	    )

	  )
	)

      )
    )

  ;;;;;

  (cond
    ((= ESTRUTURA "UP1")
     (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S1.1" 12 lst5))
    )
    ((= ESTRUTURA "U3")
     (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S3.1" 12 lst5))
    )
    ((= ESTRUTURA "UP4")
     (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S4.1" 12 lst5))
    )
    ((= ESTRUTURA "U2")
     (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S1.1" 12 lst5))
     ((= ESTRUTURA "UP2")
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S1.1" 12 lst5))
     )
    )
    ((= ESTRUTURA "UP3-1")
     (PROGN (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S1.1" 12 lst5))
	    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S3.1" 13 lst5))
     )
    )
    ((= ESTRUTURA "U3-U3")
     (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S4.1" 12 lst5))
    )
    ((= ESTRUTURA "U1-U3")
     (PROGN (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S1.1" 12 lst5))
	    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S3.1" 13 lst5))
     )
    )
    ((= ESTRUTURA "N1-U3")
     (PROGN (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S1.1" 12 lst5))
	    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "S3.1" 13 lst5))
     )
    )
  )


					;"ESTAI_ANCORA" "ESTAI_SUBSOLO"
    (if
     (/= ESTAI_ANCORA "")
     (progn
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "EST003" 14 lst5))
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ ESTAI_ANCORA 15 lst5))

       ;; UP SERVIÇO ESTAI
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO127" int5 lst5)
	     int5 (1+ int5)
       )
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ ESTAI_ANCORA int5 lst5)
	     int5 (1+ int5)
       )

     )
    )

    (if
     (/= PLACA_SUBSOLO "")
     (progn
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "EST013" 16 lst5))
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ PLACA_SUBSOLO 17 lst5))
     )
    )

    ;; ATERRAMENTO DE NEUTRO
    (if
     (= ATERR_NEUTRO "1")
     (progn
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "ATE020" 18 lst5))
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ ATERR_NEUTRO 19 lst5))

       ;; UP SERVIÇO ATERR NEUTRO
;;;      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO129" int5 lst5)
;;;	    int5 (1+ int5)
;;;      )
;;;      (setq lst5 (ESHOP-SBT_ELM_LST_SEQ ATERR_NEUTRO int5 lst5)
;;;	    int5 (1+ int5)
;;;      )

     )
    )

    ;; CHAVE FUSIVEL TRONCO
    (if
     (and (= GLB_TENSAO "13,8") (/= CHAVE ""))
     (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CHA010" 22 lst5))
    )

    (if
     (and (= GLB_TENSAO "34,5") (/= CHAVE ""))
     (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CHA017" 22 lst5))
    )

    (if
     (= var1 "fim")
     (progn

       ;; Se tensão 13,8
       (if (= GLB_TENSAO "13,8")
	 (progn
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "PAR007" 20 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" 21 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CHA010" 22 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ CHAVE 23 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "TRA002" 24 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ CT_TRAFO 25 lst5))

	   ;; AVULSOS
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "ELO2H" int5 lst5)
		 int5 (1+ int5)
	   )
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		 int5 (1+ int5)
	   )
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "SUP012" int5 lst5)
		 int5 (1+ int5)
	   )
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		 int5 (1+ int5)
	   )
	 )

	 ;; Se tensão 34,5
	 (progn
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "PAR011" 20 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" 21 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CHA017" 22 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ CHAVE 23 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "TRA035" 24 lst5))
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ CT_TRAFO 25 lst5))

	   ;; AVULSOS
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "ELO05H" int5 lst5)
		 int5 (1+ int5)
	   )
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		 int5 (1+ int5)
	   )
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "SUP013" int5 lst5)
		 int5 (1+ int5)
	   )
	   (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
		 int5 (1+ int5)
	   )
	 )
       )

       ;; ATERRAMENTO TRANFORMADOR
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "ATE024" 18 lst5))
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ ATERR_NEUTRO 19 lst5))
       

       ;; SERVIÇO CAIXA MEDIÇÃO
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CHO514" int5 lst5)
	     int5 (1+ int5)
       )
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
	     int5 (1+ int5)
       )


       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "MED041" int5 lst5)
	     int5 (1+ int5)
       )
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
	     int5 (1+ int5)
       )
       
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "PLA002" int5 lst5)
	     int5 (1+ int5)
       )
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
	     int5 (1+ int5)
       )

       ;; SERVIÇO INSTALAÇÃO TRAFO
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO310" int5 lst5)
					; TRANSFORMADOR
	     int5 (1+ int5)
       )
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "1" int5 lst5)
	     int5 (1+ int5)
       )

     )
    )

;;;    (if
;;;     (/= var1 "fim")
;;;     (progn
;;;       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CAB011" 26 lst5))
;;;       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "A" 27 lst5))
;;;       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "N" 29 lst5))
;;;       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CAB011" 30 lst5))
;;;     )
;;;    )

       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CAB011" 26 lst5))
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "A" 27 lst5))
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "N" 29 lst5))
       (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "CAB011" 30 lst5))

    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ COORD_X 31 lst5))
    (setq lst5 (ESHOP-SBT_ELM_LST_SEQ COORD_Y 32 lst5))

  )



(DEFUN ENEL_DIST_DADOS_PROJ ()
  (if (and (/= COORD_X "") (/= COORD_Y ""))
    (progn
      (if (and (/= var2 "") (/= var3 ""))
	(progn
	  (setq pto4 (list (atoi var2) (atoi var3)))
	  (setq pto5 (list (atoi COORD_X) (atoi COORD_Y)))
					;(setq int3 (+ int3 (distance pto4 pto5)))

	  ;; LANCAMENTO DE CONDUTOR
	  (setq lst5 (ESHOP-SBT_ELM_LST_SEQ "AHO201" 83 lst5))
	  (setq	lst5 (ESHOP-SBT_ELM_LST_SEQ
		       (rtos (distance pto4 pto5) 2 0)
		       84
		       lst5
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













	
  
