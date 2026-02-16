;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_POSTES_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-INSERE-POSTES.lsp
;;;<> ENEL_INSERE_POSTES_CAD
;;;++ DESCRICAO: Para cada linha, atribui tipo_poste (POSTE_FINAL), azimute, utmx (utm_x), utmy (utm_y)
;;;++ e insere o bloco do poste.
;;;++ POSTE_FINAL (col 5) deve ser: PT_IMPL, PT_DESLOC, PT_RET, PT_EXIST ou PT_RET_IMPL.
(defun ENEL_INSERE_POSTES_CAD (lst1 / lst4 row seq blocos_ok lst_inv utmx utmy azimute)
  (setq lst4 (cadr lst1))
  (setq lst_inv nil)
  ;; Validar POSTE_FINAL de todas as linhas
  (foreach row lst4
    (if	(and row (>= (length row) 78))
      (progn
	(setq tipo_poste
	       (nth 5 row)
	)
	(setq azimute (atof (vl-string-subst "." "," (nth 77 row)))
	      utmx    (atof (vl-string-subst "." "," (nth 75 row)))
	      utmy    (atof (vl-string-subst "." "," (nth 76 row)))
	      base_concreto    (nth 69 row)
	      base_reforcada    (nth 68 row)
	      aterr_neutro	(nth 70 row)
	      trafo	(nth 72 row)
	      chave	(nth 71 row)	      
	)
	(setvar "clayer" "_POSTES")

	
	(command "_.INSERT"
		 tipo_poste
		 (list utmx utmy)
		 "1"
		 "1"
		 azimute
	)


(if (/= base_concreto "")
	(command "_.INSERT"
		 "BC_CONC"
		 (list utmx utmy)
		 "1"
		 "1"
		 azimute
	))

(if (/= base_reforcada "")	
	(command "_.INSERT"
		 "BC_REFOR"
		 (list utmx utmy)
		 "1"
		 "1"
		 azimute
	))

(if (/= aterr_neutro "")	
	(command "_.INSERT"
		 "ATE_NEUTRO"
		 (list utmx utmy)
		 "1"
		 "1"
		 azimute
	))
	
	

	
      )
    )
  )
)





















