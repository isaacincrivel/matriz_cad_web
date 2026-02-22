;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_POSTES_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-INSERE-POSTES.lsp
;;;<> ENEL_INSERE_POSTES_CAD
;;;++ DESCRICAO: Insere bloco do poste (POSTE_FINAL) e equipamentos conforme lst1
;;;++ Estai_ancora: 1ES=1, 1ED=2, 1ET=3, 1EQ=4 blocos por coluna
;;;++ Outros: 1 bloco por coluna se tiver texto. MANUAL=orientação usuário; AUTOMATICO=azimute
(defun _ENEL_INS_V (row idx)
  (cond ((null row) "")
	((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

(defun _ENEL_INS_TEM_TEXTO (row idx)
  (and row (nth idx row) (/= (_ENEL_INS_V row idx) "")))

;;;++ Retorna quantidade de estais: 1ES=1, 1ED=2, 1ET=3, 1EQ=4, outro=1
(defun _ENEL_INS_QTD_ESTAI (val / s)
  (setq s (strcase (vl-princ-to-string (or val ""))))
  (cond ((= s "1ES") 1)
	((= s "1ED") 2)
	((= s "1ET") 3)
	((= s "1EQ") 4)
	((and s (/= s "")) 1)
	(t 0)))

;;;++ Processa 4 colunas de um radical: estai_ancora usa qtd; outros 1 bloco se tem texto
(defun _ENEL_INS_PROC_MANUAL (row utmx utmy azimute idx_base nomes_base layer / idx val qtd)
  ;; nomes_base = ("estai_ancora_IMPL" "estai_ancora_EXIST" ...) - estai: qtd por 1ES/1ED/1ET/1EQ
  (if (and (numberp utmx) (numberp utmy))
    (ESHOP-ZOM_RAI (list utmx utmy) 50))
  (setvar "clayer" layer)
  (foreach n nomes_base
    (setq idx (+ idx_base (vl-position n nomes_base))
	  val (_ENEL_INS_V row idx)
	  qtd (_ENEL_INS_QTD_ESTAI val))
    (if (> qtd 0)
      (repeat qtd (INSERIR_BLOCO_MODELO_MANUAL n utmx utmy azimute)))))

(defun _ENEL_INS_PROC_MANUAL_SIMPLES (row utmx utmy azimute idx_base nomes_base layer / idx)
  ;; Outros manuais: 1 bloco por coluna se tem texto
  (if (and (numberp utmx) (numberp utmy))
    (ESHOP-ZOM_RAI (list utmx utmy) 50))
  (setvar "clayer" layer)
  (setq idx idx_base)
  (foreach n nomes_base
    (if (_ENEL_INS_TEM_TEXTO row idx)
      (INSERIR_BLOCO_MODELO_MANUAL n utmx utmy azimute))
    (setq idx (1+ idx))))

(defun _ENEL_INS_PROC_AUTOMATICO (row utmx utmy azimute idx_base nomes_base layer / idx)
  (setvar "clayer" layer)
  (setq idx idx_base)
  (foreach n nomes_base
    (if (_ENEL_INS_TEM_TEXTO row idx)
      (INSERIR_BLOCO_MODELO_AUTOMATICO n utmx utmy azimute))
    (setq idx (1+ idx))))

(defun ENEL_INSERE_POSTES_CAD (lst1 / lst4 row utmx utmy azimute)
  (setq lst4 (cadr lst1))
  (foreach row lst4
    (if (and row (>= (length row) 119))
      (progn
	(setq tipo_poste (_ENEL_INS_V row 5)
	      azimute (atof (vl-string-subst "." "," (_ENEL_INS_V row 118)))
	      utmx    (atof (vl-string-subst "." "," (_ENEL_INS_V row 116)))
	      utmy    (atof (vl-string-subst "." "," (_ENEL_INS_V row 117))))
	;; Poste principal
	(setvar "clayer" "_POSTES")
	(INSERIR_BLOCO_MODELO_AUTOMATICO tipo_poste utmx utmy azimute)
	;; _BASES_E_ESTAIS: estai_ancora, base_reforcada, base_concreto
	;; MANUAL - estai_ancora (67-70): qtd por 1ES/1ED/1ET/1EQ
;;;	(_ENEL_INS_PROC_MANUAL row utmx utmy azimute 67
;;;	  '("estai_ancora_IMPL" "estai_ancora_EXIST" "estai_ancora_RET" "estai_ancora_DESLOC") "_BASES_E_ESTAIS")
;;;	;; AUTOMATICO - base_reforcada (71-74), base_concreto (75-78)
;;;	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 71
;;;	  '("base_reforcada_IMPL" "base_reforcada_EXIST" "base_reforcada_RET" "base_reforcada_DESLOC") "_BASES_E_ESTAIS")
;;;	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 75
;;;	  '("base_concreto_IMPL" "base_concreto_EXIST" "base_concreto_RET" "base_concreto_DESLOC") "_BASES_E_ESTAIS")
;;;	;; _ATERRAMENTOS_CHAVES: aterr_neutro, chave_fusivel, chave_faca, para_raios
;;;	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 79
;;;	  '("aterr_neutro_IMPL" "aterr_neutro_EXIST" "aterr_neutro_RET" "aterr_neutro_DESLOC") "_ATERRAMENTOS_CHAVES")
;;;	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 83
;;;	  '("chave_fusivel_IMPL" "chave_fusivel_EXIST" "chave_fusivel_RET" "chave_fusivel_DESLOC") "_ATERRAMENTOS_CHAVES")
;;;	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 87
;;;	  '("chave_faca_IMPL" "chave_faca_EXIST" "chave_faca_RET" "chave_faca_DESLOC") "_ATERRAMENTOS_CHAVES")
;;;	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 95
;;;	  '("para_raios_IMPL" "para_raios_EXIST" "para_raios_RET" "para_raios_DESLOC") "_ATERRAMENTOS_CHAVES")
;;;	;; _EQUIPAMENTOS: trafo, religador, banco_regulador, banco_capacitor, banco_reator
;;;	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 91
;;;	  '("trafo_IMPL" "trafo_EXIST" "trafo_RET" "trafo_DESLOC") "_EQUIPAMENTOS")
;;;	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 99
;;;	  '("religador_IMPL" "religador_EXIST" "religador_RET" "religador_DESLOC") "_EQUIPAMENTOS")
;;;	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 103
;;;	  '("banco_regulador_IMPL" "banco_regulador_EXIST" "banco_regulador_RET" "banco_regulador_DESLOC") "_EQUIPAMENTOS")
;;;	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 107
;;;	  '("banco_capacitor_IMPL" "banco_capacitor_EXIST" "banco_capacitor_RET" "banco_capacitor_DESLOC") "_EQUIPAMENTOS")
;;;	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 111
;;;	  '("banco_reator_IMPL" "banco_reator_EXIST" "banco_reator_RET" "banco_reator_DESLOC") "_EQUIPAMENTOS")
      )
    )
  )
)

;_____________________________________________________________________________________

(defun ENEL_INSERE_ELEMENTOS_CAD (lst1 / lst4 row utmx utmy azimute)
  (setq lst4 (cadr lst1))

  (SETVAR "OSMODE" 512)
  
  (foreach row lst4
    (if (and row (>= (length row) 119))
      (progn
	(setq azimute (atof (vl-string-subst "." "," (_ENEL_INS_V row 118)))
	      utmx    (atof (vl-string-subst "." "," (_ENEL_INS_V row 116)))
	      utmy    (atof (vl-string-subst "." "," (_ENEL_INS_V row 117))))
	;; Poste principal
	
	(_ENEL_INS_PROC_MANUAL row utmx utmy azimute 67
	  '("estai_ancora_IMPL" "estai_ancora_EXIST" "estai_ancora_RET" "estai_ancora_DESLOC") "_BASES_E_ESTAIS")
	;; AUTOMATICO - base_reforcada (71-74), base_concreto (75-78)
	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 71
	  '("base_reforcada_IMPL" "base_reforcada_EXIST" "base_reforcada_RET" "base_reforcada_DESLOC") "_BASES_E_ESTAIS")
	(_ENEL_INS_PROC_AUTOMATICO row utmx utmy azimute 75
	  '("base_concreto_IMPL" "base_concreto_EXIST" "base_concreto_RET" "base_concreto_DESLOC") "_BASES_E_ESTAIS")
	;; _ATERRAMENTOS_CHAVES: aterr_neutro, chave_fusivel, chave_faca, para_raios
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 79
	  '("aterr_neutro_IMPL" "aterr_neutro_EXIST" "aterr_neutro_RET" "aterr_neutro_DESLOC") "_ATERRAMENTOS_CHAVES")
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 83
	  '("chave_fusivel_IMPL" "chave_fusivel_EXIST" "chave_fusivel_RET" "chave_fusivel_DESLOC") "_ATERRAMENTOS_CHAVES")
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 87
	  '("chave_faca_IMPL" "chave_faca_EXIST" "chave_faca_RET" "chave_faca_DESLOC") "_ATERRAMENTOS_CHAVES")
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 95
	  '("para_raios_IMPL" "para_raios_EXIST" "para_raios_RET" "para_raios_DESLOC") "_ATERRAMENTOS_CHAVES")
	
	;; _EQUIPAMENTOS: trafo, religador, banco_regulador, banco_capacitor, banco_reator
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 91
	  '("trafo_IMPL" "trafo_EXIST" "trafo_RET" "trafo_DESLOC") "_EQUIPAMENTOS")

	
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 99
	  '("religador_IMPL" "religador_EXIST" "religador_RET" "religador_DESLOC") "_EQUIPAMENTOS")
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 103
	  '("banco_regulador_IMPL" "banco_regulador_EXIST" "banco_regulador_RET" "banco_regulador_DESLOC") "_EQUIPAMENTOS")
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 107
	  '("banco_capacitor_IMPL" "banco_capacitor_EXIST" "banco_capacitor_RET" "banco_capacitor_DESLOC") "_EQUIPAMENTOS")
	(_ENEL_INS_PROC_MANUAL_SIMPLES row utmx utmy azimute 111
	  '("banco_reator_IMPL" "banco_reator_EXIST" "banco_reator_RET" "banco_reator_DESLOC") "_EQUIPAMENTOS")
      )
    )
  )
)
;;-------------------------------------------------------------------------------


















(defun INSERIR_BLOCO_MODELO_AUTOMATICO (nome utmx utmy azimute /)
  (command "_.INSERT" nome (list utmx utmy) "1" "1" azimute))

(defun INSERIR_BLOCO_MODELO_MANUAL (nome utmx utmy azimute /)
  (command "_.INSERT" nome (list utmx utmy) "1" "1" PAUSE))
