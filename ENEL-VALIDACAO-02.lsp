;;; <><><><><><><><><><><><><><><><><><><><><>   < VALIDA_MATRIZ >    				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_VALIDACAO     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_ASBUILT
;;;++ DESCRI??O: Valida dados gerados na planilha CSV matriz
;;;++ ENTRADA: lst2: lista com o titulo da matriz, lst4 lista com os dados da matriz
;;;++ SAIDA: Valida??o do arquivo CSV com msgs 


(DEFUN VALIDA_MATRIZ (lst2 lst4	/ int1 int2 int3 int4 lst1 lst5	var1
		      var2 var4	var5 var_erro_valida 
		   
		      )
(setq GLB_FAIXA 0
      GLB_ARVORE 0
      GLB_SENSIVEL ""
       )
  
  (prompt "\n VALIDA_MATRIZ")
  (setq gbl_erro "\n VALIDA_MATRIZ")
  (setq var_erro_valida nil)

  (setq var1 "nao")			; Varial contro erro inconsistencia
  (setq int1 1)
  (setq int2 (length lst4))
  (setq	var2 ""
	var3 ""
  )

  (repeat int2
    (setq lst1 (nth (- int1 1) lst4))

    ;; Inicio ou Fim rede
    (setq var5 "meio")
    (if	(= int1 1)
      (setq var5 "inicio")
    )
    (if	(= int2 int1)
      (setq var5 "fim")
    )

    (ESHOP-TRS_LST_TXT_VAR lst2 lst1)
    ;; tranforma lista em variavel

    ;; 	O PROJ N?O POSSUI ESTRUTURA UP2 AINDA
    ;;    (if	(= ESTRUTURA "UP2")
    ;;      (setq ESTRUTURA "U2")
    ;;    )
    (setq int3 (atoi SEQ))

    ;; Se for a primeira linha de dados
    (if	(= var5 "inicio")
      (progn
	(VALIDA_DADOS_GERAIS)

	;; para controle sequencia
	(setq int4 int3)

	(VALIDA_DADOS_TECNICOS var5)
;;; FAZER PARA OUTRAS VARIAVEIS

	(setq var4 TIPO)		; Tipo da matriz
      )
    )


    
(VALIDA_DADOS_TECNICOS "geral")
   

    ;; Se for o ultimo poste
    (if	(= var5 "fim")
      (progn


	(VALIDA_DADOS_TECNICOS var5)

	

	(setq isaac 1)
	;; somente para manter a fun??o
      )
    )

    ;; int4 valida??o de sequencia
    (setq int4 (+ int4 1))
    (if	(/= int4 (+ int3 1))
      (progn
	(alert
	  "ERRO SEQUENCIA: \n VERIFIQUE SEQUENCIA DE LAN?AMENTO POSTES."
	)
	(setq var1 "SIM")
      )
    )

    (setq int1 (+ int1 1))
  )
  (if (= var1 "SIM")
    (exit)
  )
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < VALIDA_POSTE >    				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_VALIDACAO     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> VALIDA_POSTE
;;;++ DESCRI??O: Valida postes para uso na ferramenta
;;;++ ENTRADA: str1 nome da estrutura a ser verificado
;;;++ SAIDA: SIM ou N?O (validado ou N?O validado)

(DEFUN VALIDA_POSTE (str1 /)
  (if (member str1
	      (list "PDT9/300"	      "PDT9/1500"
		    "PDT10/150"	      "PDT10/300"
		    "PDT11/300"	      "PDT12/300"
		    "PDT13/300"	      "PDT10/600"
		    "PDT11/600"	      "PDT12/600"
		    "PDT13/600"	      "PDT14/600"
		    "PDT10/1000"      "PDT11/1000"
		    "PDT12/1000"      "PDT13/1000"
		    "PDT14/1000"      "PDT11/1500"
		    "PDT12/1500"      "PDT13/1500"
		    "PDT14/1500"      "PDT11/2000"
		    "PDT12/2000"      "PDT13/2000"
		    "PDT14/2000"      "PDT12/300"
		    "PDT13/300"	      "PDT10/600"
		    "PCC10/600"	      "PCC10/1000"
		    "PCC13/1000"      "PCC13/600"
		    "PCC11/1000"      "PCC11/600"
		    "PCC11/1500"      "PCC11/2000"
		    "3XPDT11/600"
		    "EXIST"
		   )
      )
    "SIM"
    "N?O"
  )
)



;;; <><><><><><><><><><><><><><><><><><><><><>   < VALIDA_ESTRUTURA >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_VALIDACAO     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> VALIDA_ESTRUTURA
;;;++ DESCRI??O: Valida estruturas para uso na ferramenta
;;;++ ENTRADA: str1 nome do poste a ser verificado
;;;++ SAIDA: SIM ou N?O (validado ou N?O validado)

(DEFUN VALIDA_ESTRUTURA	(str1 /)
  (if (member str1
	      (list "U3"     "UP1"    "U23"    "UP4"	"U2"
		    "U2P"    "UP2"    "UP3-1"  "U3-U3"	"U1-U3" 
		    "N1-U3"  "EXIST"  "N3"     "N1"	"N23"
		    "N4"     "N2"     "P2"     "P3"	"P4" "P1-A" "N3-N3" "P4" "TE" "U3-U3"
		    "U3U3" "HTE"
		   )
      )
    "SIM"
    "N?O"
  )
)



;;; <><><><><><><><><><><><><><><><><><><><><>   < VALIDA_ESTRUTURA_TANGENTE >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_VALIDACAO     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> VALIDA_ESTRUTURA
;;;++ DESCRI??O: Verifica se estrutura ? tangente ou n?o
;;;++ ENTRADA: str1 nome da estrutura a ser verificada
;;;++ SAIDA: SIM ou N?O (validado ou N?O validado)

(DEFUN VALIDA_ESTRUTURA_TANGENTE (str1 /)
  (if (member str1
	      (list "UP1" "U2" "U2P" "UP2" "N1"	"P1" "N2" "P2" "P1-A" "PTA1"
		    "T1")
      )
    "SIM"
    "N?O"
  )
)

;;; <><><><><><><><><><><><><><><><><><><><><>   < VALIDA_CERCA >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_VALIDACAO     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> VALIDA_CERCA
;;;++ DESCRI??O: Valida cercas para uso na ferramenta
;;;++ ENTRADA: str1 nome do poste a ser verificado
;;;++ SAIDA: SIM ou N?O (validado ou N?O validado)

(DEFUN VALIDA_CERCA (str1 /)
  (if (member str1
	      (list "0"	     "1FF"    "2FF"    "3FF"	"4FF"
		    "5FF"    "6FF"    "7FF"    "8FF"	"9FF"
		    "10FF"   "11FF"   "1FL"    "2FL"	"3FL"
		    "4FL"    "5FL"    "6FL"    "7FL"	"8FL"
		    "9FL"    "10FL"   "11FL"
		   )
      )
    "SIM"
    "N?O"
  )
)


(DEFUN VALIDA_PI (str1 /)
  (if (member str1
	      (list "UNI"    "UNR"    "LPT"
		   )
      )
    "SIM"
    "N?O"
  )
)


(DEFUN VALIDA_DADOS_GERAIS (/ lst_erro var_erro_valida)
  ;; MATRIZ_NOVA n?o possui colunas de dados gerais - pular valida??o quando ASBUILT
  (if (= (strcase gbl_tipo_projeto) "ASBUILT")
    (setq var_erro_valida nil)
    (progn
  (setq var_erro_valida nil)
  (setq str1 "")
  (MODULAR_EQT MODULO_PROJETO)

  (if (and (/= TIPO "PROJETO") (/= TIPO "ASBUILT"))
    (progn
      (setq var_erro_valida "erro")
      (setq str1
	     (strcat
	       str1
	       "Em TIPO, colocar projeto ou ASbuilt \n"
	     )
      )
    )
  )

  (if (= PROJETO "")
    (progn
      (setq var_erro_valida "erro")
      (setq
	str1 (strcat str1
		     "Erro Inconsist?ncia: Colocar numero Projeto \n"
	     )
      )
    )
  )

(if (and (= gbl_mdl_ssligacao "SIM") (= INSCRICAO ""))
  (progn
    (setq var_erro_valida "erro")
    (setq str1
	   (strcat
	     str1
	     "Colocar numero Inscri??o / Solicita??o (SS liga??o nova)\n"
	   )
    )
  )
)
  
  (if (and (= gbl_mdl_cliente "SIM") (= CLIENTE ""))
  (progn
    (setq var_erro_valida "erro")
    (setq str1
	   (strcat
	     str1
	     "Colocar nome do cliente \n"
	   )
    )
  )
)

 (if (and (= gbl_mdl_parcprojeto "SIM") (= PARCEIRA_PROJETO ""))
   (progn
     (setq var_erro_valida "erro")
     (setq str1
	    (strcat
	      str1
	      "Colocar parceira que elaborou projeto em PARCEIRA_PROJETO \n"
	    )
     )
   )
 )

 (if (and (= gbl_mdl_parcconstrucao "SIM")
	  (= PARCEIRA_CONTRUCAO "")
     )
   (progn
     (setq var_erro_valida "erro")
     (setq str1
	    (strcat
	      str1
	      "Colocar parceira que execu??o em PARCEIRA_CONTRUCAO \n"
	    )
     )
   )
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (and (= gbl_mdl_area_ambiental "SIM")
	 (and (/= UC_SENSIVEL "SIM") (/= UC_SENSIVEL "N?O"))
     )
   (progn
     (setq var_erro_valida "erro")
     (setq str1
	    (strcat
	      str1
	      "Campo de UC_Sensivel deve ser Preenchido (SIM ou N?O) \n"
	    )
     )
   )

  (if (= UC_SENSIVEL "SIM")
    (progn

(setq GLB_SENSIVEL "SIM")


    )
    (setq GLB_SENSIVEL"N?O")
  )







  
 )


  (if (and (= gbl_mdl_cadunico "SIM")
	 (and (/= CAD_UNICO "SIM") (/= CAD_UNICO "N?O"))
     )
   (progn
     (setq var_erro_valida "erro")
     (setq str1
	    (strcat
	      str1
	      "Campo de CAD_unico deve ser Preenchido (SIM ou N?O) \n"
	    )
     )
   )
 )
  (if (and (= gbl_mdl_carte_arvores "SIM")
	   (= CORTE_ARVORE "")
      )
    (progn
      (setq var_erro_valida "erro")
      (setq str1
	     (strcat
	       str1
	       "Campo CORTE_ARVORE deve ser Preenchido em todas as linhas (SE N?O EXISTIR COLOCAR 0) \n"
	     )
      )
    )
  )


  (if (and (= gbl_mdl_limpeza_faixa "SIM")
	   (= FAIXA "")
      )
    (progn
      (setq var_erro_valida "erro")
      (setq str1
	     (strcat
	       str1
	       "Campo FAIXA deve ser Preenchido em todas as linhas da planilha (SE N?O EXISTIR COLOCAR 0) \n"
	     )
      )
    )
  )

   (if (and (= gbl_mdl_municipio "SIM") (= MUNICIPIO ""))
   (progn
     (setq var_erro_valida "erro")
     (setq str1 (strcat str1 "Colocar o Municipio \n"))
   )
 )


  (if (and (= gbl_mdl_telefone "SIM") (= CLT_TELEFONE ""))
    (progn
      (setq var_erro_valida "erro")
      (setq str1 (strcat str1 "Colocar telefone do cliente \n"))
    )
  )

  (if (= var_erro_valida "erro")
    (progn
      (Alert str1)
      (princ str1)
      (Alert
	"O sistema sera fechado, CORRIGIR as valida??es em Matriz.csv e gerar novamente o projeto"
      )
      (exit)
    )
  )

    )
  )
)


(DEFUN VALIDA_DADOS_TECNICOS (var5 /)

  (if (= var5 "inicio")
    (progn

      ;; VALIDA??O POSTE EXISTENTE
;;;	(if (= SEQ "0")
;;;
;;;	  (if (or (/= POSTE "EXIST") (/= ESTRUTURA "U3"))
;;;	    (progn
;;;	      (alert
;;;		"ERRO POSTE OU ESTRUTURA \n SEMPRE QUE FOR POSTE EXISTENTE COLOCAR NA COLUNA POSTE - EXIST E ESTRUTURA - U3."
;;;	      )
;;;	      (setq var1 "SIM")
;;;	    )
;;;	  )
;;;
;;;	  (if (= SEQ "1")
;;;	    (if	(and (/= ESTRUTURA "U1-U3")
;;;		     (/= ESTRUTURA "N1-U3")
;;;		     (/= ESTRUTURA "UP3-1")
;;;		)
;;;	      (progn
;;;		(alert
;;;		  "ERRO ESTRUTURA INTERCALADA \n ESTRUTURA INTERCALADA OU SERA U1-U3 OU N1-U3."
;;;		)
;;;		(setq var1 "SIM")
;;;	      )
;;;	    )
;;;	    (progn
;;;	      (alert
;;;		"ERRO POSTE INICIAL \n SEQUENCIA INICIAL SER? 0 OU 1."
;;;	      )
;;;	      (setq var1 "SIM")
;;;	    )
;;;	  )
;;;	)
      
      (if (and (= gbl_mdl_tiptrafo "SIM") (= "CT_TRAFO" ""))
	(progn
	  (alert "ERRO INCONSISTENCIA: \n COLOCAR TRAFO")
	  (setq var1 "SIM")
	)
      )

      ;; Verifica??o de tens?o desativada - tens?o obtida das colunas CB_* via modulos.lsp ou valor padr?o
      ;;(if (and (/= TENSAO "15") (/= TENSAO "36"))
      ;;(progn
      ;;  (alert
      ;;    "ERRO INCONSISTENCIA: \n COLOCAR TENS?O 15(13,8KV) OU 36(34,5KV)."
      ;;  )
      ;;  (setq var1 "SIM")
      ;;)
      ;;)
      
    )
  )


  (if (= var5 "geral")
    (progn

 (VALIDA_DADOS_CONTINUOS)

    (if	(/= BASE_CONCRETO "")
      (if (/= BASE_REFORCADA "")
	(progn
	  (alert
	    "ERRO BASE REFORCADA - N?O PODE EXISTIR BASE REFORCADA E BASE CONCRETO NO MESMO POSTE"
	  )
	  (setq var1 "SIM")
	)
      )
    )

    ;; CHAVE FUSIVEL
    (if	(or (= ESTRUTURA "UP1")
	    (= ESTRUTURA "U2")
	    (= ESTRUTURA "P1")
	    (= ESTRUTURA "N1")
	)
      (if (/= CHAVE "")
	(progn
	  (alert
	    "ERRO CHAVE - USO CHAVE FUSIVEL EM ESTRUTURA UP1 OU UP2"
	  )
	  (setq var1 "SIM")
	)
      )
    )

    (if	(= (VALIDA_POSTE POSTE) "N?O")
      (progn
	(alert
	  (strcat "\n Erro no poste: " POSTE ", TIPO N?O CADASTRADO")
	)
	(setq var1 "SIM")
      )
    )

    ;; Valida??o de estrutura desativada
    ;;(if	(= (VALIDA_ESTRUTURA ESTRUTURA) "N?O")
    ;;(progn
    ;;	(alert
    ;;	  (strcat "\n Erro na estrutura: "
    ;;		  ESTRUTURA
    ;;		  ", TIPO N?O CADASTRADO"
    ;;	  )
    ;;	)
    ;;	(setq var1 "SIM")
    ;;  )
    ;;)

    ;; Analise numero postes
    (if	(= var4 "ASBUILT")
      (if (= NM_POSTE "")
	(progn
	  (alert
	    "ERRO INCONSISTENCIA: \n SE TRATANDO DE ASBUILT DEVE-SE COLOCAR NUMERO DE POSTE."
	  )
	  (setq var1 "SIM")
	)
      )
    )     
    )
  )


 (if (= var5 "fim")
   (progn

;;;;;;;;;;;;
    ;; XXXX FAZER CONDI??ES EM RELA??O AO MODULAR, EX: SE FALA QUE TEM QUE TER TRANSFORMADOR, COLOCAR
    ;;	(if (= CT_TRAFO "")
    ;;	  (progn
    ;;	    (alert "ERRO CT TRAFO \n COLOCAR CT TRANSFORMADOR.")
    ;;	    (setq var1 "SIM")
    ;;	  )
    ;;	)
    ;;
    ;;	(if (= CHAVE
    ;;	       ""
    ;;	    )
    ;;	  (progn
    ;;	    (alert "ERRO CHAVE TRAFO \n N?O COLOCOU CHAVE TRAFO.")
    ;;	    (setq var1 "SIM")
    ;;	  )
    ;;	)

    ;;	(if (= RAMAL_CASA
    ;;	       ""
    ;;	    )
    ;;	  (progn
    ;;	    (alert "ERRO RAMAL SERVI?O \n N?O COLOCOU RAMAL SERVI?O.")
    ;;	    (setq var1 "SIM")
    ;;	  )
    ;;	)

    ;;	(if (= OHM
    ;;	       ""
    ;;	    )
    ;;	  (progn
    ;;	    (alert
    ;;	      "ERRO RESISTENCIA OHM \n COLOCAR RESISTENCIA ATERRAMENTO."
    ;;	    )
    ;;	    (setq var1 "SIM")
    ;;	  )
    ;;	)

    ;;	(if (= var4 "ASBUILT")
    ;;	  (if (= MEDIDOR "")
    ;;	    (progn
    ;;	      (alert
    ;;		"ERRO MEDIDOR: \n SE TRATANDO DE ASBUILT DEVE-SE COLOCAR NUMERO DE MEDIDOR."
    ;;	      )
    ;;	      (setq var1 "SIM")
    ;;	    )
    ;;	  )
    ;;	)
;;;;;;;;;
   )
 )

)



(DEFUN VALIDA_DADOS_CONTINUOS (/)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; VALIDA??O DE CERCA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VALIDA??O PARA FOR?AR COLOCAR CERCA
(if (and (= gbl_mdl_cerca "SIM")
	 (or
	   (= CERCA_01 "")
	   (= CERCA_02 "")
	   (= CERCA_03 "")
	 )
    )
  (progn
    (setq var_erro_valida "erro")
    (setq str1
	   (strcat
	     str1
	     "Campos de cercas CERCA_1 CERCA_2 e CERCA3 devem ser Preenchido em todas as linhas, (VAZIO COLOCAR 0) \n"
	   )
    )
  )
)
;; VALIDA SE A CERCA FOI COLOCADA CERTA
(if
  (and (= gbl_mdl_cerca "SIM")
       (or
	 (= (VALIDA_CERCA CERCA_01) "N?O")
	 (= (VALIDA_CERCA CERCA_02) "N?O")
	 (= (VALIDA_CERCA CERCA_03) "N?O")
       )
  )
   (progn
     (setq var_erro_valida "erro")
     (setq str1
	    (strcat
	      str1
	      "Existe campos de cerca digitados fora do padr?o Modelo Ex: 1FF OU 1FL  \n"
	    )
     )
   )
)


;; VALIDA??O PARA FOR?AR COLOCAR CERCA
(if
  (and (= gbl_mdl_tipopi "SIM")
       (= (VALIDA_PI TIPO_PI) "N?O")
  )
   (progn
     (setq var_erro_valida "erro")
     (setq str1
	    (strcat
	      str1
	      "Cadastrar tipo de PI em TIPO_PI ou dado cadastrado errado  \n"
	    )
     )
   )

  
)


  (if (and (= gbl_mdl_carte_arvores "SIM")
	   (= CORTE_ARVORE "")
      )
    (progn
      (setq var_erro_valida "erro")
      (setq str1
	     (strcat
	       str1
	       "Campo de Supress?o vegetal (corte de arvores) deve ser Preenchido em todas as linhas \n"
	     )
      )
    )
    (setq GLB_ARVORE (+ GLB_FAIXA (atoi CORTE_ARVORE)))
  )


  (if (and (= gbl_mdl_limpeza_faixa "SIM")
	   (= FAIXA "")
      )
    (progn
      (setq var_erro_valida "erro")
      (setq str1
	     (strcat
	       str1
	       "Campo de FAIXA deve ser Preenchido em todas as linhas da planilha \n"
	     )
      )
    )
    (setq GLB_FAIXA (+ GLB_FAIXA (atoi FAIXA)))    
  )


  (if (= var_erro_valida "erro")
    (progn
      (Alert str1)
      (princ str1)
      (Alert
	"O sistema sera fechado, CORRIGIR as valida??es em Matriz.csv e gerar novamente o projeto"
      )
      (exit)
    )
  )


)