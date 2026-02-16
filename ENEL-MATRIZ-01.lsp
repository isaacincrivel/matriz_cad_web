;;; <><><><><><><><><><><><><><><><><><><><><>   < C:MATRIZ >    	<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_MATRIZ     	<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> C:MATRIZ
;;;++ DESCRI??O: FUN??O PRINCIPAL INICIAL
;;;++ COMANDO PARA ENTRADA NO SISTEMA
;;;++ ENTRADA: 
;;;++ SAIDA: 

(DEFUN C:MATRIZ	(/ lst1 lst2 lst3 lst4 gbl_erro)
					;se for fazer teste colocar gbl_teste igual a 1
  (setq gbl_teste 0)

  (alert "Sistema Matriz - versão 2000")

  (if (ESHOP-CSV-FECHADO-ABERTO "C:\\MATRIZ\\MATRIZ_NOVA.csv")
    (setq isaac 1)
    (progn
      (Alert "Feche o arquivo CSV C:\\MATRIZ\\MATRIZ_NOVA.csv")
      (exit)
    )
  )

  ;; Sistema simplificado: apenas desenho a partir do CSV (MATRIZ_NOVA.csv)
  (setq gbl_tipo_projeto "asbuilt")
  (ENEL_ASBUILT)
  (prompt fr1)
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INICIO >    	<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_MATRIZ     	<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_INICIO
;;;++ DESCRI??O: CONFIGURA??O DE PARAMETROS INCIAIS DO SISTEMA
;;;++ ENTRADA: 
;;;++ SAIDA: 

(DEFUN ENEL_INICIO (/ str1)
  (vla-put-supportpath
    (setq files
	   (vla-get-files (vla-get-preferences (vlax-get-acad-object)))
    )
    (strcat ";C:\\MATRIZ_SISTEMA\\BLOCOS"
	    ";"
	    (vla-get-supportpath files)
    )
  )					; Colocando a pasta blocos dentr do diretorio raiz
  (setq	frx
	 (strcat
	   "__________________________________________________________________________\n"
	   "__________________________________________________________________________\n"
	   "SISTEMA MATRIZ 01 \n \n__________________________________________________________________________\n"
	   "Frase aleat?ria:\n"
	 )
  )
  (setq frase (atoi (substr (rtos (getvar "date") 2 8) 15 1)))
  (cond	((= frase 0)
	 (setq fr1
		"Qualidade ruim ? lembrada por muito tempo depois que os pre?os baixos s?o esquecidos. \n (Charles Rolls)"
	 )
	)
	((= frase 1)
	 (setq fr1
		"Trabalhar com seguran?a ? acreditar que voc? ? a ferramenta mais importante para a empresa"
	 )
	)
	((= frase 2)
	 (setq fr1
		"Produtividade nunca ? por acaso. ? sempre resultado de comprometimento com a excelencia, planejamento e foco"
	 )
	)
	((= frase 3)
	 (setq fr1
		"O sucesso de uma empresa ? o resultado do trabalho de uma grande equipe"
	 )
	)
	((= frase 4)
	 (setq fr1
		"Um grande dia come?a com grandes projetos e termina com excelentes realiza??es"
	 )
	)
	((= frase 5)
	 (setq fr1
		"O segredo do SUCESSO ? pontualidade, responsabilidade, compromisso e carater."
	 )
	)
	((= frase 6)
	 (setq fr1 "Um bom trabalho ? fruto de uma boa COMUNICA??O")
	)
	((= frase 7)
	 (setq fr1
		"Acredite nas suas CAPACIDADES e lute todos os dias para que elas sobressaiam no seu trabalho."
	 )
	)
	((= frase 8)
	 (setq fr1 "Fa?a sua parte o impossivel DEUS faz acontecer")
	)
	((= frase 9)
	 (setq fr1
		"Qualidade ruim ? lembrada por muito tempo depois que os pre?os baixos s?o esquecidos. \n (Charles Rolls)"
	 )
	)
  )
  ;; Validade do Sistema MATRIZ
  (setq str1 (substr (rtos (getvar "cdate") 2 5) 1 14))
  (setq	int1 (atoi (strcat (substr str1 1 4)
			   (substr str1 5 2)
			   (substr str1 7 2)
		   )
	     )
  )
  (setq int2 20260301)			; Data de vencimento sistema
  (if (> int1 int2)
    (progn
      (alert "Erro 11")
      (exit)
    )
  )
  (if (> int1 (- int2 5))
    (alert
      "Sistem Matriz proximo a Expirar - Entrar contato com Admin."
    )
  )

;;CRIAR LAYERS
(ESHOP-CRR_LAY "_POSTES" 6 "default"  "continuous")

 
  

  
  (SETQ	gbl_cmdecho
	 (GETVAR "CMDECHO")
	gbl_blipmode
	 (GETVAR "BLIPMODE")
	gbl_clayer
	 (GETVAR "CLAYER")
	gbl_osmode
	 (GETVAR "OSMODE")
	gbl_osnapcoord
	 (GETVAR "OSNAPCOORD")
	gbl_cecolor
	 (GETVAR "CECOLOR")
	erro-original
	 *error*
	*error*	erro
  )
  (SETVAR "attdia" 0)
  (SETVAR "CMDECHO" 0)
  (SETVAR "BLIPMODE" 0)
  (SETVAR "OSNAPCOORD" 2)
  (SETVAR "OSMODE" 0)
  (SETVAR "CECOLOR" "BYLAYER")
  (setvar "OSMODE" 0)
  (SETVAR "CLAYER" "0")
  (command "_UNDO" "_BEGIN")
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < erro >    <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_MATRIZ     <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> erro
;;;++ DESCRI??O: FUN??O ERRO
;;;++ ENTRADA: 
;;;++ SAIDA: 

;;PARAMETROS DO SISTEMA
(DEFUN erro (msg)
  (PROMPT (strcat "\n erro " gbl_erro))
  (if msg
    (PROMPT (strcat "\nDetalhe: " (vl-princ-to-string msg)))
  )
  (PROMPT "\nO Comando foi Cancelado...")
  (SETVAR "CMDECHO" gbl_cmdecho)
  (SETVAR "BLIPMODE" gbl_blipmode)
  (SETVAR "CLAYER" gbl_clayer)
  (SETVAR "OSMODE" gbl_osmode)
  (SETVAR "OSNAPCOORD" gbl_osnapcoord)
  (SETVAR "CECOLOR" gbl_cecolor)
  (SETQ *error* erro-original)
  (PRINC "\nFim")
  (PRINC)
)

;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_FIM >    <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_MATRIZ     <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_FIM
;;;++ DESCRI??O: RETORNANDO CONFIGURA??ES INICIAIS
;;;++ ENTRADA: 
;;;++ SAIDA: 

(defun ENEL_FIM	()
  (princ)
  (command "regen")
  (SETVAR "CMDECHO" gbl_cmdecho)
  (SETVAR "BLIPMODE" gbl_blipmode)
  (SETVAR "CLAYER" gbl_clayer)
  (SETVAR "OSMODE" gbl_osmode)
  (SETVAR "OSNAPCOORD" gbl_osnapcoord)
  (SETVAR "CECOLOR" gbl_cecolor)
  (SETQ *error* ERRO_ORIGINAL)
  (COMMAND "_UNDO" "_END")
  (princ)
)


