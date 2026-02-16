;;; <><><><><><><><><><><><><><><><><><><><><>   < STUBS KML REMOVIDO >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Stubs - fun??es KML removidas, aplica??o somente para gerar CAD
(defun GERAR_LISTA_ELM (pto2 angref tipo) nil)
(defun GERAR_LISTA_TXT (pto2 txt1) nil)

;;;<> ENEL_DEFLEX
;;;++ DESCRI??O: Calcula angulo de deflexao entre dois segmentos no vertice (pto2)
;;;++ Usa ang3 (angle pto2 pto1) e ang4 (angle pto2 pto3) definidos no escopo de chamada
;;;++ SAIDA: angulo em radianos entre 0 e pi
(defun ENEL_DEFLEX (/ diff)
  (setq diff (rem (- ang4 ang3) (* 2 pi)))
  (if (> diff pi) (setq diff (- diff (* 2 pi))))
  (if (< diff (- pi)) (setq diff (+ diff (* 2 pi))))
  (abs diff)
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < CRIA_PROJETO_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_CRIAR CAD     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> CRIA_PROJETO_CAD
;;;++ DESCRI??O: Desenha projeto dwg
;;;++ ENTRADA: 
;;;++ SAIDA: 


(defun CRIA_PROJETO_CAD
			(lst2 lst4	   /		lst1
			      ptogeral	   lst5		int1
			      int2	   int3		var1
			      lst_pto	   lst_segments	pto_orig
			      var2	   var3		var5
			      pto5	   pto6		pto4
			      str1	   str2		ang1
			      pto1	   pto2		pto3
			      GLB_CLIENTE  GLB_INSCRICAO GLB_TELEFONE
			      GLB_PROJETO  GLB_CONSTRUTORA
			      GLB_MUNICIPIO		GLB_TENSAO
			      GBL_DISTANCIA		nome_linha_viva
			      pto_angulo   quadrante1	quadrante2
			      quadrante3   GLB_TIPO	GLB_MODULO
			      GLB_VAO_FROUXO
			 )

  

  (prompt "\n CRIA_PROJETO_CAD")
  (setq gbl_erro "\n CRIA_PROJETO_CAD")

  (setq int4 0)
  ;; variavel controle para primeiro poste v?o frouxo
  (setvar "osmode" 0)

  (setq int1 1)
  (setq int2 (length lst4))
  (setq lst_pto nil lst_segments nil)	; lst_pto=(seq.pto), lst_segments=((pto1 pto2)...) para DERIVA

  (setq int3 0)				; Variavel para soma distancia
  (setq ptogeral (list 0 0))
  (ESHOP-ZOM_RAI ptogeral 100)

  (setq	var2 ""
	var3 ""
  )					; Coordenadas X e Y globais nesta fun??o
  (setq str1 "")			; Distancia Total DISTANCIATOTAL


  ;; INICIO LOOP DE INSTALA??O POSTE E ESTRUTURA
  (repeat int2


    (setq pto1 nil
	  pto2 nil
	  pto3 nil
	  var44 nil
	  quadrante1 nil
	  quadrante2 nil
	  quadrante3 nil
	  
    )

    ;; Inicio ou Fim rede
    (setq var1 "meio")
    (if	(= int1 1)
      (setq var1 "inicio")
    )
    (if	(= int2 int1)
      (setq var1 "fim")
    )

      


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (if	(> int1 1)
      (progn
	(ESHOP-TRS_LST_TXT_VAR lst2 (nth (- int1 2) lst4))
	(ENEL_ALIAS_VARS_MATRIZ_NOVA)
	(setq pto1 (list (atoi COORD_X) (atoi COORD_Y)))
      )
    )


    (if	(< int1 int2)
      (progn
	(ESHOP-TRS_LST_TXT_VAR lst2 (nth (- int1 0) lst4))
	(ENEL_ALIAS_VARS_MATRIZ_NOVA)
	(setq pto3 (list (atoi COORD_X) (atoi COORD_Y)))
      )
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (setq lst1 (nth (- int1 1) lst4))
    (ESHOP-TRS_LST_TXT_VAR lst2 lst1)
    (ENEL_ALIAS_VARS_MATRIZ_NOVA)
    (setq pto2 (list (atoi COORD_X) (atoi COORD_Y)))

    ;; Acumular pontos e segmentos para desenho (DERIVA: vazio=anterior, valor=deriva do N)
    (setq lst_pto (cons (cons (atoi SEQ) pto2) lst_pto))
    (if (> int1 1)
      (progn
	(setq pto_orig (if (and (boundp 'DERIVA) DERIVA (/= DERIVA ""))
			   (cdr (assoc (atoi DERIVA) lst_pto))
			   pto1))
	(if pto_orig
	  (setq lst_segments (append lst_segments (list (list pto_orig pto2)))))))

    (if (= var1 "inicio")
	(progn
	  ;; SALVANDO VARIAVEIS GLOBAIS DA MATRIZ
	  (setq

	    GLB_CLIENTE
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
	    GLB_FUSO
			    FUSO
	    
	    GLB_TIPO
			    TIPO
	    GLB_MODULO	    MODULO_PROJETO

	    GLB_VAO_FROUXO  VAO_FROUXO
	    GLB_TELEFONE
			    CLT_TELEFONE

	  )


	  (setq gbl_entrada MODULO_PROJETO)
	  (MODULAR_EQT gbl_entrada)
	  (setq gbl_vaofrouxo (if (and (boundp 'gbl_mdl_vaofrouxo) gbl_mdl_vaofrouxo)
				   gbl_mdl_vaofrouxo "N?O"))
	)
      )

    

;; se estrutura ? de angulo
    (if	(and (/= pto1 nil) (/= Pto2 nil) (/= Pto3 nil))
      (progn
	(setq ang3 (angle Pto2 pto1))
	(setq ang4 (angle Pto2 pto3))
	(setq var44 (+
		      (/ (+ ang3 ang4) 2)
		      (/ pi 2)
		    )
	)
	
	(setq gbl_ang_deflex (ENEL_DEFLEX))

	;; se a estrutura ? de encabe?amento e o angulo ? menor que 3 graus	
	(if (and (member ESTRUTURA GLB_LST_EST_ENCAB)
		 (< gbl_ang_deflex (/ (* 3 PI) 180))
	    )
	  (setq var44 (+ var44 (/ pi 2)))
	)

	(if (and (= gbl_vaofrouxo "SIM") (= int1 2))
	  (setq var44 (+ (angle Pto2 pto3) (/ pi 2)))
	)


	
;;; DEFININDO QUAL QUADRANTE N?O PODE COLOCAR O ANGULO
(cond ((< ang3 (/ pi 2)) (setq quadrante1 1))
	      ((< ang3 pi) (setq quadrante2 1))
	      ((< ang3 (/ (* 3 pi) 2)) (setq quadrante3 1)))
	

	(cond ((< ang4 (/ pi 2)) (setq quadrante1 1))
	      ((< ang4 pi) (setq quadrante2 1))
	      ((< ang4 (/ (* 3 pi) 2)) (setq quadrante3 1)))
	      

	;; ponto para inserir o angulo e valor para escrever

	(cond
	  ((= quadrante1 nil)
	   (setq pto_angulo (list (+ (car Pto2) 17) (+ (cadr Pto2) 17)))
	  )
	  ((= quadrante2 nil)
	   (setq pto_angulo (list (- (car Pto2) 17) (+ (cadr Pto2) 17)))
	  )
	  ((= quadrante3 nil)
	   (setq pto_angulo (list (- (car Pto2) 17) (- (cadr Pto2) 17)))
	  )
	)

	
;;;;; deixar coordenada de inser??o quadrante angulo

      )
)



;; estrutura de deriva??o
    (if	(and (= pto1 nil) (/= pto3 nil) (/= pto2 nil))
      (setq var44 (+ (angle pto2 pto3) (/ pi 2)))
    )


    ;; estrutura fim de linha
    (if	(and (/= pto1 nil) (= pto3 nil) (/= pto2 nil))
      (setq var44 (+ (angle pto2 pto1) (/ pi 2)))
    )

    ;; Se azimute do CSV estiver definido, usar para rotacionar o poste
    (if (and (boundp 'AZIMUTE) AZIMUTE (/= AZIMUTE ""))
      (setq var44 (/ (* pi (- 90 (atof (vl-string-subst "." "," AZIMUTE)))) 180))
    )
    ;; Fallback: evitar var44 nil (ex: poste unico ou casos extremos)
    (if (not (and var44 (numberp var44)))
      (setq var44 (/ pi 2))
    )



    
  (ESHOP-ZOM_RAI ptogeral 100)

  (SETQ lst5 (append lst5 (list pto2)))


  (if (= var1 "fim")
    (progn

;;; desenhando LINHAS conforme DERIVA (vazio=poste anterior, valor=deriva do N)
      (if lst_segments
	(progn
	  (setq gbl_compr 0.0 GLB_LST_CABO nil elm1 nil)
	  (foreach seg lst_segments
	    (command ".line" (car seg) (cadr seg) "")
	    (if (not elm1) (setq elm1 (entlast)))
	    (setq gbl_compr (+ gbl_compr (distance (car seg) (cadr seg))))
	    (setq GLB_LST_CABO (append GLB_LST_CABO (list (car seg) (cadr seg)))))
	  (setq pto12 (caar lst_segments)
		pto13 (cadar lst_segments)
		ang12 (angle pto12 pto13))
	  (setq pto12 (polar pto12 (+ ang12 (/ pi 4)) 15)
		pto13 (polar pto12 (- ang12 (/ pi 4)) 15))
	  (command "offset" 5 elm1 pto12 "")
	  (setq elm12 (entlast))
	  (setq GLB_LST_CABO_FAIXA1 (ESHOP-PTOS_PLINE_REP elm12))
	  (entdel elm12)
	  (command "offset" 5 elm1 pto13 "")
	  (setq elm13 (entlast))
	  (setq GLB_LST_CABO_FAIXA2 (ESHOP-PTOS_PLINE_REP elm13))
	  (entdel elm13))
	(progn
;;; fallback: polilinha sequencial (formato antigo)
	  (command ".pline")
	  (foreach x lst5 (command x))
	  (command "")
	  (setq elm1 (entlast))
	  (command "area" "e" elm1)
	  (setq gbl_compr (getvar "perimeter"))
	  (setq GLB_LST_CABO (ESHOP-PTOS_PLINE_REP (entlast)))
	  (setq pto12 (car lst5)
		pto13 (cadr lst5)
		ang12 (angle pto12 pto13))
	  (setq pto12 (polar pto12 (+ ang12 (/ pi 4)) 15)
		pto13 (polar pto12 (- ang12 (/ pi 4)) 15))
	  (command "offset" 5 elm1 pto12 "")
	  (setq elm12 (entlast))
	  (setq GLB_LST_CABO_FAIXA1 (ESHOP-PTOS_PLINE_REP elm12))
	  (entdel elm12)
	  (command "offset" 5 elm1 pto13 "")
	  (setq elm13 (entlast))
	  (setq GLB_LST_CABO_FAIXA2 (ESHOP-PTOS_PLINE_REP elm13))
	  (entdel elm13)))
    )
  )




    
    
    (CRIARCAD_INSERIR_BLOCOS_REDE)
   ; (CRIARCAD_INSERIR_BLOCOS_PLANTA_BAIXA)


    (setq int1 (+ int1 1))
  )

  (command "zoom" "e")

  ;(ORGANIZA_CAD_TEMP)
  
  (ENEL_SALVA_ARQUIVOS)
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < CRIARCAD_INSERIR_BLOCOS_REDE >    		<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_CRIAR CAD     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> CRIARCAD_INSERIR_BLOCOS_REDE
;;;++ DESCRI??O: Insere blocos ao longo da rede
;;;++ ENTRADA: 
;;;++ SAIDA:


(DEFUN CRIARCAD_INSERIR_BLOCOS_REDE (/ dst4 pto4 ang1 ang2 BLOCO_POSTE)


  ;; ISERINDO BLOCO PLINE
  (ESHOP-ZOM_RAI pto2 10)


  ;;gbl_vaofrouxo

;;;  (COMMAND "-INSERT"	"BLOCO_PONTO_TEXTO"	  pto2
;;;	   "1"		"1"	     "0"	  SEQ
;;;	   ESTRUTURA	POSTE	     COORD_X	  COORD_Y
;;;	  )

  (COMMAND "-INSERT"	"BLOCO_PONTO_TEXTO2"	  pto2
	   "1"		"1"	     "0"	  SEQ
	   ESTRUTURA	POSTE
	  )

(GERAR_LISTA_TXT pto2 (strcat SEQ "-" ESTRUTURA " -" POSTE ))

;;; inserindo angulo deflex?o
  (if (and (/= pto_angulo nil) (> gbl_ang_deflex (/ pi 60)))
    (progn
      (COMMAND "-INSERT"
	       "MTZ_ANG_DEFLEX2"
	       pto_angulo
	       "1"
	       "1"
	       "1"
	       (strcat (angtos gbl_ang_deflex 0 0) "?")

      )
      (GERAR_LISTA_TXT pto_angulo (strcat (angtos gbl_ang_deflex 0 0) "?"))
      (setq pto_angulo nil)
    )
  )

;;; COLOCAR TEXTO V?O FROUXO PROJETO
  ;; inicio if
  (if (and (= pto1 nil)
	   (/= pto3 nil)
	   (/= pto2 nil)
	   (= gbl_vaofrouxo "SIM")
      )
    (progn

      (setq dst4 (distance pto2 pto3))

					;Colocando texto na angula??o correta
      (setq ang1 (angle pto2 pto3))
      (if (or (and (>= ang1 0) (<= ang1 (/ PI 2)))
	      (and (> ang1 (/ (* 3 PI) 2)) (< ang1 (* PI 2)))
	  )
	(setq ang2 ang1)
	(setq ang2 (+ ang1 PI))
      )
      (setq pto4 (polar pto2 (angle pto2 pto3) (/ dst4 2)))

      (COMMAND "-INSERT"
	       "MTZ_TXT_VAO_FROUXO"
	       pto4
	       "1"
	       "1"
	       (angtos ang2)
      )
    )

  )
;;; FIN if

  ;; Bloco conforme status: implantar->PT_IMPL, existente->PT_EXIST, retirar->PT_RET, deslocar->PT_DESLOC, retirar+implantar->PT_RET_IMPL
  (setq BLOCO_POSTE
	 (cond
	   ((and (boundp 'STATUS) STATUS)
	    (cond ((= (strcase STATUS) "IMPLANTAR") "PT_IMPL")
		  ((= (strcase STATUS) "EXISTENTE") "PT_EXIST")
		  ((= (strcase STATUS) "RETIRAR") "PT_RET")
		  ((= (strcase STATUS) "DESLOCAR") "PT_DESLOC")
		  ((or (= (strcase STATUS) "RETIRAR_IMPLANTAR")
		       (= (strcase STATUS) "RETIRAR IMPLANTAR")
		       (and (wcmatch (strcase STATUS) "*RETIRAR*")
			    (wcmatch (strcase STATUS) "*IMPLANTAR*")))
		   "PT_RET_IMPL")
		  (t "PT_IMPL")))
	   ((= POSTE "EXIST") "PT_EXIST")
	   (t "PT_IMPL")))
  (COMMAND "-INSERT" BLOCO_POSTE pto2 "1" "1" (angtos var44))
  (GERAR_LISTA_ELM pto2 var44 (if (boundp 'STATUS) (strcase STATUS) "implantado"))

  ;; Cabos do ponto (LST_CABOS: lista "cabo_SUFIXO" ex. 1#1/0CAA_IMPL, 1#1/0CAA_DESLOC)
  (if (and (boundp 'LST_CABOS) LST_CABOS (listp LST_CABOS))
    (progn
      (setq ang1 (if (and (boundp 'var44) (numberp var44)) var44 0))
      (setq pto4 (polar pto2 (+ ang1 (/ pi 2)) 3))
      (foreach cabo LST_CABOS
	(if (and cabo (= (type cabo) 'STR) (/= cabo ""))
	  (progn
	    (command "_.text" "J" "BC" pto4 "1.5" (angtos ang1) cabo)
	    (if (boundp 'GERAR_LISTA_TXT) (GERAR_LISTA_TXT pto4 cabo))
	    (setq pto4 (polar pto4 (+ ang1 (/ pi 2)) 2))))))

					;(command "_.explode" (entlast) "")
  (if (/= pto3 nil)
    (progn
      (setq dst4 (distance pto2 pto3))

;;; Colocando texto na angula??o correta
      (setq ang1 (angle pto2 pto3))
      (if (or (and (>= ang1 0) (<= ang1 (/ PI 2)))
	      (and (> ang1 (/ (* 3 PI) 2)) (< ang1 (* PI 2)))
	  )
	(setq ang2 ang1)
	(setq ang2 (+ ang1 PI))
      )
      (setq pto4 (polar pto2 (angle pto2 pto3) (/ dst4 2)))

      (COMMAND "-INSERT"
	       "MTZ_TXT_DISTANCIA2"
	       pto4
	       "1"
	       "1"
	       (angtos ang2)
	       (strcat (rtos dst4 2 0) "m")
      )

      (GERAR_LISTA_TXT pto4 (strcat (rtos dst4 2 0) "m"))

;;;(setvar "CLAYER" "TEXTO")
;;;(command "text" "s" "MtXpl_txt_shx" "J" "BC" pto4 "2" (angtos ang2) (strcat (rtos dst4 2 0) "m"))
;;;      (SETVAR "CLAYER" "0")
      ;(ESHOP-ZOM_RAI  pto4 5)

      ;; por enquanto n?o colocar texto cabo
;;;      (COMMAND "-INSERT"
;;;	       "MTZ_TXT_CABO"
;;;	       pto4
;;;	       "1"
;;;	       "1"
;;;	       (angtos ang2)
;;;	       gbl_mdl_cabo
;;;      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      (if (and (/= CORTE_ARVORE "")
	       (/= CORTE_ARVORE nil)
	       (/= CORTE_ARVORE "0")
	  )
	(COMMAND "-INSERT"
		 "MTZ_CORTE_ARVORE2"
		 pto4
		 "1"
		 "1"
		 (angtos ang2)
		 CORTE_ARVORE
	)
      )


      (if (and (/= FAIXA "") (/= FAIXA nil) (/= FAIXA "0"))
	(COMMAND "-INSERT"
		 "MTZ_ABERTURA_FAIXA2"
		 pto4
		 "1"
		 "1"
		 (angtos ang2)
		 (strcat FAIXA "m")
	)
      )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    )
  )

  (if (= BASE_REFORCADA "1")
    (progn (COMMAND "-INSERT"
		    "MTZ_BASE_REFORCADA2"
		    pto2
		    "1"
		    "1"
		    (angtos var44)
	   )
	   (GERAR_LISTA_ELM pto2 var44 "basereforcada")
    )
  )


  (if (= BASE_CONCRETO "1")
    (progn (COMMAND "-INSERT"
		    "MTZ_BASE_CONCRETO2"
		    pto2
		    "1"
		    "1"
		    (angtos var44)
	   )
	   (GERAR_LISTA_ELM pto2 var44 "baseconcreto")
    )
  )

  (INSERIR_ESTAIS)

  (if (= var1 "fim")
    (MTZ_INSERE_CARIMBO)
  )

)


;;; <><><><><><><><><><><><><><><><><><><><><>   < INSERIR CARIMBO GERAL >    		<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   MTZ_INSERE_CARIMBO CAD     		<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> MTZ_INSERE_CARIMBO
;;;++ DESCRI??O: Insere carimbo geral
;;;++ ENTRADA: 
;;;++ SAIDA:

(DEFUN MTZ_INSERE_CARIMBO
       (/ quadrante1 quadrante2 quadrante3 pto_angulo)


  (cond	((< ang3 (/ pi 2)) (setq quadrante1 1))
	((< ang3 pi) (setq quadrante2 1))
	((< ang3 (/ (* 3 pi) 2)) (setq quadrante3 1))
  )

  (cond
    ((= quadrante1 nil)
     (setq pto_angulo (list (+ (car Pto2) 100) (+ (cadr Pto2) 100)))
    )
    ((= quadrante2 nil)
     (setq pto_angulo (list (- (car Pto2) 100) (+ (cadr Pto2) 100)))
    )
    ((= quadrante3 nil)
     (setq pto_angulo (list (- (car Pto2) 100) (- (cadr Pto2) 100)))
    )
  )


 ;(COMMAND "-INSERT" "MTZ_CARIMBO_GERAL"	pto_angulo "1" "1" "")

 (cond ((= GLB_TENSAO "15") (setq str2 "13,8KV"))
       ((= GLB_TENSAO "36") (setq str2 "34,5KV"))
 )


  (if (OR (= SEQ "") (= SEQ NIL))
    (setq SEQ "-"))


	 
 (command "-insert"
	  "MTZ_CARIMBO_DADOS_GERAIS"
	  pto_angulo
	  "1"
	  "1"
	  "0"
	  GLB_CLIENTE
	  GLB_PROJETO
	  GLB_MUNICIPIO
	  GLB_INSCRICAO
	  GLB_TELEFONE
	  str2
	  (strcat (rtos gbl_compr 2 0) "m")	; Int3 disancia total
	  gbl_mdl_cabo
	  SEQ

 )


  (if (= GLB_SENSIVEL "SIM")
    (setq GLB_SENSIVEL "!!! PROJETO DENTRO DO PERIMETRO DE AREA SENS?VEL AMBIENTAL!!!")
    (setq GLB_SENSIVEL ""))

   (NOTA_AMBIENTAL)
  
(command "-insert"
	 "MTZ_CARIMBO_AMBIENTAL"
	 pto_angulo
	 "1"
	 "1"
	 "0"
	 (strcat "TOTAL DE CORTES DE ARVORES ISOLADAS (und): "
		 (rtos GLB_ARVORE
		 2
		 0)
	 )
	 (strcat "EXTENS?O LIMPEZA FAIXA (m): " (rtos GLB_FAIXA 2 0))
	 GLB_SENSIVEL
	 NT1
	 NT2
	 NT3
	 NT4
	 NT5
	 
)

  (command "-insert" "MTZ_CARIMBO_QUALIDADE2" pto_angulo "1" "1" "0")

    
  )



(DEFUN NOTA_AMBIENTAL (/)


  (if (/= GLB_SENSIVEL "")

    (setq
      NT1 "INFORMATIVO AMBIENTAL: "

      NT2 "Este projeto encontra-se em uma ?REA AMBIENTAL SENS?VEL,"
      NT3 "para a execu??o da obra em campo, ? OBRIGAT?RIO possuir "
      NT4 "em m?os a autoriza??o do ?rg?o competente"
      NT5 "!!! NECESS?RIO LICEN?A AMBIENTAL !!!"
    )

    (if	(or (> GLB_FAIXA 0) (> GLB_ARVORE 0))

      (setq
	NT1 "INFORMATIVO AMBIENTAL: "

	NT2 "Para a execu??o deste projeto, ? OBRIGAT?RIO ter em m?os"
	NT3 "a licen?a ambiental ou o n?mero do processo aprovado"
	NT4 "junto ao ?rg?o respons?vel."
	NT5 "!!! NECESS?RIO LICEN?A AMBIENTAL !!!"
      )


      (setq
	NT1 "INFORMATIVO AMBIENTAL: "

	NT2 "Para a execu??o deste projeto, N?O ? PERMITIDO"
	NT3 "efetuar supress?o vegetal (CORTE DE ARVORES). Caso exista"
	NT4 "esta necessidade favor devolver o projeto para a ?rea respons?vel."
	NT5 ""
      )
    )
  )

)








;;; <><><><><><><><><><><><><><><><><><><><><>   < CRIARCAD_INSERIR_BLOCOS_PLANTA_BAIXA >    		<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_CRIAR CAD     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> CRIARCAD_INSERIR_BLOCOS_PLANTA_BAIXA
;;;++ DESCRI??O: Insere blocos ao longo da rede
;;;++ ENTRADA: 
;;;++ SAIDA:

(DEFUN CRIARCAD_INSERIR_BLOCOS_PLANTA_BAIXA (/ dst4 pto4 ang1 ang2)



  (if (/= CAVA_ROCHA "")
    (setq str1 "CAVA ROCHA")
  )

  ;; ulitmo ponto
  (if (= var1 "inicio")
    ;;9999
    (progn

      ;; SALVANDO VARIAVEIS GLOBAIS DA MATRIZ
;;;      (setq
;;;					;GLB_CLIENTE
;;;					;    CLIENTE
;;;	GLB_INSCRICAO
;;;	 INSCRICAO
;;;	GLB_PROJETO
;;;	 PROJETO
;;;	GLB_CONSTRUTORA
;;;	 CONSTRUTORA
;;;					;GLB_MUNICIPIO
;;;					; MUNICIPIO
;;;	GLB_TENSAO
;;;	 TENSAO
;;;	GLB_TIPO TIPO
;;;      )


      ;; Descri??o de linha viva
      (if (= GLB_TIPO "PROJETO")
	(setq nome_linha_viva "OR?ADO  DERIVA??O  L. VIVA")
	(setq nome_linha_viva "UTILIZOU  L.VIVA  DERIVA??O")
      )

      ;; Salvando as Variaveis linha 01
      (if (= SEQ "0")
	(progn
	  (command "-insert"  "PTDERIVA" ptogeral   "1"
		   "1"	      "0"	 SEQ	    ESTRUTURA
		   POSTE      NM_POSTE	 str1	    COORD_X
		   COORD_Y
		  )

	  (if (= DERV_LV "SIM")
	    (command "-insert"	     "DERIV_LINHA_VIVA"
		     ptogeral	     "1"	     "1"
		     "0"	     nome_linha_viva
		    )
	  )

	  (ENEL_ESTAI)
	  (ENEL_PLACA)
	  (ENEL_CHAVE)
	  (ENEL_ATERRAMENTO)
	  (ENEL_CERCA)
	  (ENEL_DISTANCIA)
	  (ENEL_FAIXA)
	  (ENEL_CORTE_ARVORE)

	)
      )

      (if (= SEQ "1")
	(progn
	  
	  (if (= (substr poste 1 3) "PCC")
	    (setq var5 "PTDERIVA3")
	    (setq var5 "PTDERIVA2")
	  )

	  (command "-insert"  "PTDERIVA2"	    ptogeral
		   "1"	      "1"	 "0"	    SEQ
		   ESTRUTURA  POSTE	 NM_POSTE   str1
		   COORD_X    COORD_Y	 " "
		  )

					;PTDERIVA3


	  (if (= DERV_LV "SIM")
	    (command "-insert"	     "DERIV_LINHA_VIVA"
		     ptogeral	     "1"	     "1"
		     "0"	     nome_linha_viva
		    )
	  )

	  (ENEL_ESTAI)
	  (ENEL_PLACA)
	  (ENEL_CHAVE)
	  (ENEL_ATERRAMENTO)
	  (ENEL_CERCA)
	  (ENEL_DISTANCIA)
	  (ENEL_FAIXA)
	  (ENEL_CORTE_ARVORE)

	)
      )

    )
  )

  (if (= (substr poste 1 3) "PCC")
    (setq var5 "PTREDE3")
    (setq var5 "PTREDE")
  )



  (if (= BASE_REFORCADA "2")
    (setq var5 "PTREDE2")
  )


  ;; ulitmo ponto
  (if (= var1 "meio")
    (progn

      (setq ptogeral (list (+ (car ptogeral) 12.5) 0))
      (ESHOP-ZOM_RAI ptogeral 100)



      (if (= seq "1")
	(progn


	  (if (= var5 "PTREDE")
	    (setq var5 "PTREDE2")
	  )

	  (command "-insert" var5      ptogeral	 "1"	   "1"
		   "0"	     SEQ       ESTRUTURA POSTE	   NM_POSTE
		   str1	     COORD_X   COORD_Y
		  )
	  (setq int4 (+ int4 1))
	)

	(if (= int4 0)
	  (progn
	    (if	(= var5 "PTREDE")
	      (setq var5 "PTREDE2")
	    )

	    (command "-insert" var5	 ptogeral  "1"	     "1"
		     "0"       SEQ	 ESTRUTURA POSTE     NM_POSTE
		     str1      COORD_X	 COORD_Y
		    )
	    (setq int4 (+ int4 1))
	  )
	)
      )



      (if (> int4 1)

	(command "-insert" var5	     ptogeral  "1"	 "1"
		 "0"	   SEQ	     ESTRUTURA POSTE	 NM_POSTE
		 str1	   COORD_X   COORD_Y
		)
	(setq int4 (+ int4 1))
      )
      (ENEL_ESTAI)
      (ENEL_PLACA)
      (ENEL_CHAVE)
      (ENEL_ATERRAMENTO)
      (ENEL_CERCA)
      (ENEL_DISTANCIA)
      (ENEL_FAIXA)
      (ENEL_CORTE_ARVORE)
    )
  )

  ;; ulitmo ponto
  (if (= var1 "fim")
    (progn

      (setq ptogeral (list (+ (car ptogeral) 12.5) 0))
      (ESHOP-ZOM_RAI ptogeral 100)



      (if (= var5 "PTREDE")
	(setq var5 "PTREDE2")
      )
      (COMMAND "-INSERT" var5	   ptogeral  "1"       "1"
	       "0"	 SEQ	   ESTRUTURA POSTE     NM_POSTE
	       str1	 COORD_X   COORD_Y
	      )


      (setq GBL_QTDPOSTE SEQ)
      (ENEL_ESTAI)
      (ENEL_PLACA)
      (ENEL_CHAVE)
      (ENEL_TRAFO)
      (ENEL_DISTANCIA)



      (ESHOP-ZOM_RAI pto2 200)
      (COMMAND "-INSERT" "BLOCO_PONTO_TRAFO" pto2 "1" "1" "0")


;;; desenhando PLILINHA
;;;	(command ".pline")
;;;	(foreach x lst5 (command x))
;;;	(command "")

    )
  )
)


(DEFUN ORGANIZA_CAD_TEMP ()
  ;; SE EXISTIR DISTANCIA MAIOR QUE 500 METROS MOSTRAR ERRO
  (if (= GBL_DISTANCIA "erro")
    (progn
      (alert
	"ERRO DISTANCIA: EXISTE V?OS MAIORES QUE 500 METROS, FAVOR CORRIGIR!!"
      )
      (exit)
    )
  )

  (ESHOP-ZOM_RAI (list 0 0) 600)
  (ENEL_CARIMBO)

  ;; MODENVDO PROJETO PARA PROXIMO PLINE
  (setq ang1 (angle (car lst5) (last lst5)))
  (if (and (> (atoi (angtos ang1)) 80)
	   (< (atoi (angtos ang1)) 190)
      )
    (setq pto6 (car lst5))
    (setq pto6 (last lst5))
  )

  (ESHOP-ZOM_RAI (list -15 70) 2000)
  (setvar "osmode" 0)
  (setq sel1 (ssget "W" (list -15 70) (list 8000 -1000)))
  (command "zoom" "e")
  (command "MOVE"
	   sel1
	   ""
	   (list -15 70)
	   pto6
  )
  (command "zoom" "e")
)





;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_CARIMBO >    				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_CRIAR CAD     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_CARIMBO
;;;++ DESCRI??O: Insere carimbo na prancha
;;;++ ENTRADA: 
;;;++ SAIDA: 


(DEFUN ENEL_CARIMBO (/ str1 str2 int7 int5 int6 int7 int8 pto7)


  (prompt "\n ENEL_CARIMBO")
  (setq gbl_erro "\n ENEL_CARIMBO")


  ;; xxxxxxxxxxxxxx alguns projetos ficam sem a ultima folha do carimbo - salvei o caminhamento que gera isso
  (setq int8 0)
  (setq int5 (/ (atof GBL_QTDPOSTE) 8))
  (setq	int6 0
	int7 1
  )
  (setq pto7 (list 0 0))
  (setq str1 (rtos (+ (atoi (rtos int5)) 1)))
  (while (> int5 int6)
    (progn
      (command "-insert"
	       "CARIMBO"
	       pto7
	       "1"
	       "1"
	       "0"
	       GLB_CLIENTE
	       GLB_INSCRICAO
	       GLB_CONSTRUTORA
	       GLB_PROJETO
	       GLB_MUNICIPIO
	       ""
	       ""
	       ""
	       (rtos int7)
	       str1

      )
      (cond ((= GLB_TENSAO "15") (setq str2 "13,8KV"))
	    ((= GLB_TENSAO "36") (setq str2 "34,5KV"))
      )

      (command "-INSERT"
	       "EXTTOTAL"
	       pto7
	       "1"
	       "1"
	       "0"
	       (strcat (rtos int3 2 0) "m") ; Int3 disancia total
	       str2
	       gbl_mdl_cabo

      )
      (command "-INSERT" "BLC_ENEL_TIPO" pto7 "1" "1" "0" GLB_TIPO)
      (if (= gbl_var_carga "N?O")
	(progn
	  (COMMAND "-INSERT" "TXTCARGAINST" pto7 "1" "1" "0")
	)
      )
      (if (= gbl_var_carga "N?O")
	(progn
	  (COMMAND "-INSERT" "TXTCARGAINST" pto7 "1" "1" "0")
	)
      )
      ;; KIT INTERNO
      (if (= gbl_var_plpt "SIM")
	(COMMAND "-INSERT" "TXTKITINTSIM" pto7 "1" "1" "0")
	(Progn
	  (if (and (= gbl_var_cadunico "SIM") (= gbl_var_carga "SIM"))
	    (COMMAND "-INSERT" "TXTKITINTSIM" pto7 "1" "1" "0")
	    (COMMAND "-INSERT" "TXTKITINTNAO" pto7 "1" "1" "0")
	  )
	)
      )
;;;; TRA??O E REGRA A SER ADOTADA
      (if (= gbl_regra "REDUZIDA")
	(COMMAND "-INSERT" "TXTDAN2" pto7 "1" "1" "0")
      )

      (if (= gbl_regra "ESP1013")
	(COMMAND "-INSERT" "TXTDAN1013" pto7 "1" "1" "0")
      )
;;;      (if (= gbl_regra "UMVAO")
;;;  (COMMAND "-INSERT" "TXTDANFROUXO" pto7 "1" "1" "0")
;;;)
      (if (= int7 1)
	(progn
	  (if (= gbl_vaofrouxo "SIM")
	    (COMMAND "-INSERT" "TXTDANFROUXO" pto7 "1" "1" "0")
	  )
	)
      )
      

      (setq GLB_NMARQUIVO
	     (strcat GLB_TIPO	   "_PDF" ;"---" GLB_CLIENTE
		     "---INSC-"	   GLB_INSCRICAO "---"
		     GLB_DATA
		    )
      )

      ;; PLOTANDO O PDF
      (command "-plot"
	       "yes"
	       ""
	       "DWG TO PDF.PC3"
	       "ISO full bleed A4 (297.00 x 210.00 MM)"
	       "M"
	       "L"
	       ""
	       "W"
	       (list (- (car pto7) 6.25) (+ (cadr pto7) 32.2596))
	       (list (+ (car pto7) 93.75) (- (cadr pto7) 38.0101))
	       "F"
	       "C"
	       "Y"
	       "acad.ctb"
	       "Y"
	       ""
	       (strcat "C:\\matriz\\"
		       GLB_NMARQUIVO
		       "-"
		       (rtos int7)
		       "-"
		       str1
		       ".pdf"
	       )
	       ""
	       ""
      )
      (SETQ int7 (+ int7 1))
      (SETQ pto7 (LIST (+ int8 100) 0))
      (SETQ int8 (+ int8 100))
    )
    (SETQ int5 (- int5 1))
  )
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < INSERIR_ESTAIS >    				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   INSERIR ESTAIS     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_CARIMBO
;;;++ DESCRI??O: Insere estais no projeto
;;;++ ENTRADA: 
;;;++ SAIDA: 


(DEFUN INSERIR_ESTAIS ()



  



  
(if (= ESTAI_ANCORA "1")

    (progn


      (cond ((= var1 "inicio") (setq ang_estai gbl_ang_p2_p1))
	    ((= var1 "fim") (setq ang_estai gbl_ang_p1_p2))
	    ((= var1 "meio") (setq ang_estai gbl_ang_bicetriz1))
      )
	       
    (COMMAND "-INSERT"
	     "MTZ_ANCORA_SIMPLES"
	     pto2
	     "1"
	     "1"
	     ;(angtos var44)
	     (angtos ang_estai)
	     
	     
    )
      (GERAR_LISTA_ELM pto2 ang_estai "estai")
      
          
    )
  )


  (if (= ESTAI_ANCORA "2")
    (progn
    (command "-INSERT"
	     "MTZ_ANCORA_SIMPLES"
	     pto2
	     "1"
	     "1"
	     ;(angtos var44)
	     (angtos gbl_ang_p1_p2)
	     
	     
    )
    (GERAR_LISTA_ELM pto2 gbl_ang_p1_p2 "estai")
        
    (command "-INSERT"
	     "MTZ_ANCORA_SIMPLES"
	     pto2
	     "1"
	     "1"
	     ;(angtos var44)
	     (angtos gbl_ang_p2_p3)
	     
	     
    )
    (GERAR_LISTA_ELM pto2 gbl_ang_p2_p3 "estai")
    
    ;(command "_.explode" (entlast) "")
    )
  )


  (if (= ESTAI_ANCORA "3")
    (progn
      (command "-INSERT"
	       "MTZ_ANCORA_SIMPLES"
	       pto2
	       "1"
	       "1"
					;(angtos var44)
	       (angtos gbl_ang_p1_p2)


      )
      (GERAR_LISTA_ELM pto2 gbl_ang_p1_p2 "estai")
     (command "-INSERT"
	       "MTZ_ANCORA_SIMPLES"
	       pto2
	       "1"
	       "1"
					;(angtos var44)
	       (angtos gbl_ang_p2_p3)


      )
      (GERAR_LISTA_ELM pto2 gbl_ang_p2_p3 "estai")

      (command "-INSERT"
	       "MTZ_ANCORA_SIMPLES"
	       pto2
	       "1"
	       "1"
					;(angtos var44)
	       (angtos gbl_ang_bicetriz1)
      )
      (GERAR_LISTA_ELM pto2 gbl_ang_bicetriz1 "estai")
    )
  )


  (if (= ESTAI_ANCORA "4")
    (progn
      (command "-INSERT"
	       "MTZ_ANCORA_SIMPLES"
	       pto2
	       "1"
	       "1"
					;(angtos var44)
	       (angtos gbl_ang_p1_p2)


      )
      (GERAR_LISTA_ELM pto2 gbl_ang_p1_p2 "estai")
      
      (command "-INSERT"
	       "MTZ_ANCORA_SIMPLES"
	       pto2
	       "1"
	       "1"
					;(angtos var44)
	       (angtos gbl_ang_p2_p3)


      )
      (GERAR_LISTA_ELM pto2 gbl_ang_p2_p3 "estai")

      (command "-INSERT"
	       "MTZ_ANCORA_SIMPLES"
	       pto2
	       "1"
	       "1"
					;(angtos var44)
	       (angtos gbl_ang_bicetriz1)
      )
      (GERAR_LISTA_ELM pto2 gbl_ang_bicetriz1 "estai")
      
      (command "-INSERT"
	       "MTZ_ANCORA_SIMPLES"
	       pto2
	       "1"
	       "1"
					;(angtos var44)
	       (angtos gbl_ang_bicetriz2)
      )
      (GERAR_LISTA_ELM pto2 gbl_ang_bicetriz2 "estai")
    )
  )
  )
