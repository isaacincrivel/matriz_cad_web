
;;;____________________________________________________________________ INCREMENTA_LISTA  _____________________________________________________________________________
;;;____________________________________________________________________ INCREMENTA_LISTA  _____________________________________________________________________________
(defun INCREMENTA_LISTA	()
  (setq lst3 (append lst3 (list (UTM_LST gbl_var1))))
)

;;;____________________________________________________________________ ZERA_LISTA  _____________________________________________________________________________
;;;____________________________________________________________________ ZERA_LISTA  _____________________________________________________________________________
(defun ZERA_LISTA (/ str1 x)
  (setq str1 "")
  (foreach x lst2
    (setq str1
	   (strcat str1
		   (vl-princ-to-string X)
		   ";"
	   )
    )
  )
  (setq	gbl_var1 (ESHOP-JNT-LST-LST
		   lst2
		   (ESHOP-CRR-LST-ITM "" (length lst2))
		 )
  )
)


;;;____________________________________________________________________ ENEL_SUBST_ELM_LIST  _____________________________________________________________________________
;;;____________________________________________________________________ ENEL_SUBST_ELM_LIST  _____________________________________________________________________________
(defun ENEL_SUBST_ELM_LIST (prr1 vl1 /)
  (setq	gbl_var1 (subst	(cons prr1 vl1)
			(assoc prr1 gbl_var1)
			gbl_var1
		 )
  )
  gbl_var1
)

;;;____________________________________________________________________ UTM_LST  _____________________________________________________________________________
;;;____________________________________________________________________ UTM_LST  _____________________________________________________________________________
(defun UTM_LST (var1 / lst11 x)
  (foreach x var1
    (setq lst11 (append lst11 (list (cdr x))))
  )
  lst11
)


;;;<> ENEL_ALIAS_VARS_MATRIZ_NOVA
;;;++ DESCRICAO: Mapeia variaveis do formato MATRIZ_NOVA ou consolidado para nomes usados pelo CRIA_PROJETO_CAD
;;;++ Apos ESHOP-TRS_LST_TXT_VAR, define COORD_X/Y, SEQ, DERIVA, POSTE, NM_POSTE, ESTRUTURA
;;;++ Suporta formato consolidado (POSTE_FINAL, EST_1A_IMPL..) e MATRIZ_NOVA (tipo_poste, EST_1A..)
(DEFUN ENEL_ALIAS_VARS_MATRIZ_NOVA (/ vx vy ex tp)
  (setq vx (vl-princ-to-string (or (and (boundp 'utm_x) utm_x) "")))
  (setq vy (vl-princ-to-string (or (and (boundp 'utm_y) utm_y) "")))
  (setq COORD_X (fix (atof (vl-string-subst "." "," vx))))
  (setq COORD_Y (fix (atof (vl-string-subst "." "," vy))))
  (setq SEQ (vl-princ-to-string (or (and (boundp 'sequencia) sequencia) "")))
  (setq DERIVA (vl-princ-to-string (or (and (boundp 'deriva) deriva) "")))
  (setq tp (or (and (boundp 'tipo_poste) tipo_poste) (and (boundp 'POSTE_FINAL) POSTE_FINAL)
	     (and (boundp 'POSTE_IMPL) POSTE_IMPL) (and (boundp 'POSTE_EXIST) POSTE_EXIST) ""))
  (setq POSTE (vl-princ-to-string tp))
  (setq NM_POSTE (vl-princ-to-string (or (and (boundp 'num_poste) num_poste) "")))
  ;; ESTRUTURA = primeira EST_* nao vazia (formato MATRIZ_NOVA ou consolidado EST_*_IMPL/EXIST/RET/DESLOC)
  (setq ex (or (and (boundp 'EST_1A) EST_1A (/= (vl-princ-to-string EST_1A) ""))
	       (and (boundp 'EST_1A_IMPL) EST_1A_IMPL (/= (vl-princ-to-string EST_1A_IMPL) ""))
	       (and (boundp 'EST_1B) EST_1B (/= (vl-princ-to-string EST_1B) ""))
	       (and (boundp 'EST_1B_IMPL) EST_1B_IMPL (/= (vl-princ-to-string EST_1B_IMPL) ""))
	       (and (boundp 'EST_2A) EST_2A (/= (vl-princ-to-string EST_2A) ""))
	       (and (boundp 'EST_2A_IMPL) EST_2A_IMPL (/= (vl-princ-to-string EST_2A_IMPL) ""))
	       (and (boundp 'EST_2B) EST_2B (/= (vl-princ-to-string EST_2B) ""))
	       (and (boundp 'EST_2B_IMPL) EST_2B_IMPL (/= (vl-princ-to-string EST_2B_IMPL) ""))
	       (and (boundp 'EST_3A) EST_3A (/= (vl-princ-to-string EST_3A) ""))
	       (and (boundp 'EST_3A_IMPL) EST_3A_IMPL (/= (vl-princ-to-string EST_3A_IMPL) ""))
	       (and (boundp 'EST_3B) EST_3B (/= (vl-princ-to-string EST_3B) ""))
	       (and (boundp 'EST_4A) EST_4A (/= (vl-princ-to-string EST_4A) ""))
	       (and (boundp 'EST_4A_IMPL) EST_4A_IMPL (/= (vl-princ-to-string EST_4A_IMPL) ""))
	       (and (boundp 'EST_4B) EST_4B (/= (vl-princ-to-string EST_4B) ""))
	       (and (boundp 'EST_5A) EST_5A (/= (vl-princ-to-string EST_5A) ""))
	       (and (boundp 'EST_5B) EST_5B (/= (vl-princ-to-string EST_5B) ""))
	       (and (boundp 'EST_6A) EST_6A (/= (vl-princ-to-string EST_6A) ""))
	       (and (boundp 'EST_6B) EST_6B (/= (vl-princ-to-string EST_6B) ""))
	       (and (boundp 'EST_BT1) EST_BT1 (/= (vl-princ-to-string EST_BT1) ""))
	       (and (boundp 'EST_BT1_IMPL) EST_BT1_IMPL (/= (vl-princ-to-string EST_BT1_IMPL) ""))
	       (and (boundp 'EST_BT2) EST_BT2 (/= (vl-princ-to-string EST_BT2) ""))
	       (and (boundp 'EST_BT3) EST_BT3 (/= (vl-princ-to-string EST_BT3) ""))))
  (setq ESTRUTURA (vl-princ-to-string (or ex "")))
  ;; Variaveis ausentes em MATRIZ_NOVA - garantir que existam para CRIA_PROJETO_CAD
  (foreach sym '(CLIENTE INSCRICAO PROJETO CONSTRUTORA TENSAO TIPO MODULO_PROJETO VAO_FROUXO CLT_TELEFONE)
    (if (not (boundp sym)) (set sym "")))
)

;;;<> ENEL_LISTA_PADRAO
;;;++ DESCRICAO: Cabe?alhos do formato interno (lst4), alinhados ao modelo MATRIZ_NOVA
;;;++ MATRIZ_NOVA: sequencia, deriva, status, num_poste, tipo_poste, estru_mt_nv1/2/3,
;;;++   estai_ancora, base_reforcada, base_concreto, aterr_neutro, chave, utm_x, utm_y,
;;;++   faixa, cort_arvores_isol, municipio, fuso, azimute, CB_1A..CB_BT3
;;;++ SAIDA: 50 colunas (lst2 = append resultado + "STATUS" "AZIMUTE" "DERIVA" "LST_CABOS")
(DEFUN ENEL_LISTA_PADRAO ()
  (list
    "sequencia"	   "deriva"	  "status"	 "CB_1A"
    "CB_1B"	   "CB_2A"	  "CB_2B"	 "CB_3A"
    "CB_3B"	   "CB_4A"	  "CB_4B"	 "CB_5A"
    "CB_5B"	   "CB_6A"	  "CB_6B"	 "CB_BT1"
    "CB_BT2"	   "CB_BT3"	  "lat"		 "long"
    "num_poste"	   "tipo_poste"	  "EST_1A"	 "EST_1B"
    "EST_2A"	   "EST_2B"	  "EST_3A"	 "EST_3B"
    "EST_4A"	   "EST_4B"	  "EST_5A"	 "EST_5B"
    "EST_6A"	   "EST_6B"	  "EST_BT1"	 "EST_BT2"
    "EST_BT3"	   "estai_ancora" "base_reforcada"
    "base_concreto"		  "aterr_neutro" "chave_fusivel" "chave_faca"
    "trafo"	   "para_raios" "religador" "banco_regulador" "banco_capacitor" "banco_reator"  "faixa"	 "cort_arvores_isol"
    "adiconal_1"   "qdt_adic_1"	  "adiconal_2"	 "qdt_adic_2"
    "adiconal_3"   "qdt_adic_3"	  "adiconal_4"	 "qdt_adic_4"
    "adiconal_5"   "qdt_adic_5"	  "adiconal_6"	 "qdt_adic_6"
    "adiconal_7"   "qdt_adic_7"	  "rotacao_poste"
    "municipio"	   "fuso"	  "utm_x"	 "utm_y"
    "azimute"	   "enc_tang"
   )
)



;;;<> ENEL_LISTA_POSTE
;;;++ DESCRICAO: Cabe?alhos do formato consolidado (1 linha por poste), alinhados a ENEL_CONVERT_LIST_POSTE
;;;++ sequencia, POSTE_*, EST_*_IMPL/EXIST/RET/DESLOC (60), num_poste..azimute, deriva, faixa..long, CB_*, adicionais
(DEFUN ENEL_LISTA_POSTE (/ est_names sufixos lst_header e s i cb)
  (setq est_names '("EST_1A" "EST_1B" "EST_2A" "EST_2B" "EST_3A" "EST_3B"
		   "EST_4A" "EST_4B" "EST_5A" "EST_5B" "EST_6A" "EST_6B"
		   "EST_BT1" "EST_BT2" "EST_BT3")
	sufixos '("_IMPL" "_EXIST" "_RET" "_DESLOC")
	lst_header (list "sequencia" "POSTE_IMPL" "POSTE_EXIST" "POSTE_RET" "POSTE_DESLOC" "POSTE_FINAL"))
  (foreach e est_names
    (foreach s sufixos
      (setq lst_header (append lst_header (list (strcat e s))))))
  (setq lst_header (append lst_header
    (list "num_poste"
	  "estai_ancora_IMPL" "estai_ancora_EXIST" "estai_ancora_RET" "estai_ancora_DESLOC"
	  "base_reforcada_IMPL" "base_reforcada_EXIST" "base_reforcada_RET" "base_reforcada_DESLOC"
	  "base_concreto_IMPL" "base_concreto_EXIST" "base_concreto_RET" "base_concreto_DESLOC"
	  "aterr_neutro_IMPL" "aterr_neutro_EXIST" "aterr_neutro_RET" "aterr_neutro_DESLOC"
	  "chave_fusivel_IMPL" "chave_fusivel_EXIST" "chave_fusivel_RET" "chave_fusivel_DESLOC"
	  "chave_faca_IMPL" "chave_faca_EXIST" "chave_faca_RET" "chave_faca_DESLOC"
	  "trafo_IMPL" "trafo_EXIST" "trafo_RET" "trafo_DESLOC"
	  "para_raios_IMPL" "para_raios_EXIST" "para_raios_RET" "para_raios_DESLOC"
	  "religador_IMPL" "religador_EXIST" "religador_RET" "religador_DESLOC"
	  "banco_regulador_IMPL" "banco_regulador_EXIST" "banco_regulador_RET" "banco_regulador_DESLOC"
	  "banco_capacitor_IMPL" "banco_capacitor_EXIST" "banco_capacitor_RET" "banco_capacitor_DESLOC"
	  "banco_reator_IMPL" "banco_reator_EXIST" "banco_reator_RET" "banco_reator_DESLOC"
	  "rotacao_poste" "utm_x" "utm_y" "azimute" "deriva"
	  "faixa" "cort_arvores_isol" "cerca" "municipio" "fuso")))
  (setq cb '("CB_1A" "CB_1B" "CB_2A" "CB_2B" "CB_3A" "CB_3B" "CB_4A" "CB_4B"
	     "CB_5A" "CB_5B" "CB_6A" "CB_6B" "CB_BT1" "CB_BT2" "CB_BT3"))
  (foreach n cb (setq lst_header (append lst_header (list n))))
  (setq i 1)
  (repeat 7 (setq lst_header (append lst_header (list (strcat "adiconal_" (itoa i)) (strcat "qdt_adic_" (itoa i)))) i (1+ i)))
  (setq lst_header (append lst_header (list "enc_tang")))
  lst_header
)














;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_SALVA_ARQUIVOS >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_SISTEMA     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_SALVA_ARQUIVOS
;;;++ DESCRI??O: Salva arquivo csv Matriz.csv
;;;++ ENTRADA: 
;;;++ SAIDA: 

(DEFUN ENEL_SALVA_ARQUIVOS (/ str3 str4)
  (prompt "\n EQTL_SALVA_ARQUIVOS")
  (setq gbl_erro "\n EQTL_SALVA_ARQUIVOS")



;(setq str4  (strcat str4 "\\" ))
  
  (setq	GLB_NMARQUIVO
	 (strcat GLB_TIPO      "_MATRIZ" ;"---" GLB_CLIENTE
		 "---INSC-"    GLB_INSCRICAO "---"
		 GLB_DATA
		)
  )
 

  (ENEL_IMPRIMIR (ESHOP-CNV-CSV-LST "C:\\MATRIZ\\MATRIZ_NOVA.csv"))
  
  (setq	GLB_NMARQUIVO
	 (strcat GLB_TIPO      "_CAD"	;"---"
					;GLB_CLIENTE
		 "---INSC-"    GLB_INSCRICAO "---"
		 GLB_DATA
		)
  )
  (setq	str3 (STRCAT GLB_DIRETORIO 
		     GLB_NMARQUIVO
		     ".dwg"
	     )
  )
  (if (findfile str3)
    (alert
      "ARQUIVO JA EXISTENTE, PARA SALVAR EXCLUIR ARQUIVO."
    )
    (progn
      (setq str3 (vl-string-subst "-" "/" str3 0))
      (command "_.qsave" str3)
      (alert (strcat GLB_TIPO
		     " GERADO COM SUCESSO!!"
	     )
      )
    )
  )
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_IMPRIMIR >    				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_SISTEMA     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_IMPRIMIR
;;;++ DESCRI??O: IMPRIME LISTA EM ARQUIVO CSV
;;;++ ENTRADA: Precisa da variavel GLB_NMARQUIVO
;;;++ SAIDA: 

(DEFUN ENEL_IMPRIMIR (lista /)

         (prompt "\n ENEL_IMPRIMIR")
  (setq gbl_erro "\n ENEL_IMPRIMIR")


  
;;;(setq	GLB_NMARQUIVO
;;;	 (strcat "P"	      GLB_PROJETO  "---" "INSC-"	GLB_INSCRICAO
;;;		 "---"	      GLB_CONSTRUTORA		"---" data
;;;		 	      "---"	XXXXX   
;;;		)
;;;  )  
  
  (ESHOP-IMP_TAB_CVS
    GLB_NMARQUIVO
    (strcat (ESHOP-CNV_LST_STR_CSV
	      lista
	    )
	    "\n"
    )
    GLB_DIRETORIO 
    ;"C:\\MATRIZ\\"
  )
)




