;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_CABOS_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-INSERE-CABOS-CAD.lsp
;;;<> ENEL_INSERE_CABOS_CAD
;;;++ DESCRICAO: Desenha linhas de cabo a partir de lst8 (ENEL_CONVERT_LIST_CABO)
;;;++ ENTRADA: lst8 - (list lst_header lst_cabos) retorno de ENEL_CONVERT_LIST_CABO
;;;++ corrx_1=sequencia, corrx_2=anterior, corrx_3=posterior. Desenha seq->posterior ou anterior->seq (ultimo)
;;;++ MT (CB_1A..CB_6B): ponto = centro; BT (CB_BT1..BT3): ponto = polar(centro, azimute, 1.465)
;;;++ Desenha cabo se existir valor em qualquer coluna IMPL/EXIST/RET/DESLOC do trecho

(defun _ENEL_STR_NUM (s)
  (if (and s (/= (vl-princ-to-string s) ""))
    (atof (vl-string-subst "." "," (vl-princ-to-string s)))
    0.0))


(defun _ENEL_CABO_TEM_VALOR (row idx_base)
  (or (and (nth idx_base row) (/= (vl-princ-to-string (nth idx_base row)) ""))
      (and (nth (1+ idx_base) row) (/= (vl-princ-to-string (nth (1+ idx_base) row)) ""))
      (and (nth (+ idx_base 2) row) (/= (vl-princ-to-string (nth (+ idx_base 2) row)) ""))
      (and (nth (+ idx_base 3) row) (/= (vl-princ-to-string (nth (+ idx_base 3) row)) ""))))

(defun ENEL_INSERE_CABOS_CAD (lst8 / lst_cabos row
			       cx1 cy1 cx2 cy2 az1 az2
			       pt1 pt2 centro1 centro2 ang1_rad ang2_rad
			       i idx_base is_bt dist_offset tem_posterior)
  (setq lst_cabos (cadr lst8))
  (if (not lst_cabos)
    (princ "\n ENEL_INSERE_CABOS_CAD: lst8 sem dados.")
    (progn
      (setq dist_offset 1.465)
      ;; Indices: 2,3=corrx_1,corry_1 (seq); 4,5=corrx_2,corry_2 (anterior); 72,73=corrx_3,corry_3 (posterior)
      ;; Desenha seq->posterior quando existe posterior; senao anterior->seq (ultimo poste)
      (foreach row lst_cabos
	(if (and row (>= (length row) 76))
	  (progn
	    (setq cx1 (_ENEL_STR_NUM (nth 2 row))
		  cy1 (_ENEL_STR_NUM (nth 3 row))
		  cx2 nil cy2 nil tem_posterior nil)
	    (if (and (nth 72 row) (nth 73 row)
		     (/= (vl-princ-to-string (nth 72 row)) "")
		     (/= (vl-princ-to-string (nth 73 row)) ""))
	      (setq cx2 (_ENEL_STR_NUM (nth 72 row))
		    cy2 (_ENEL_STR_NUM (nth 73 row))
		    tem_posterior T))
	    (if (and (not tem_posterior) (nth 4 row) (nth 5 row)
		     (/= (vl-princ-to-string (nth 4 row)) "")
		     (/= (vl-princ-to-string (nth 5 row)) ""))
	      (setq cx2 (_ENEL_STR_NUM (nth 4 row))
		    cy2 (_ENEL_STR_NUM (nth 5 row))))
	    (if (and cx2 cy2)
	      (progn
		(setq az1 (_ENEL_STR_NUM (nth 66 row))
		      az2 (_ENEL_STR_NUM (nth 67 row))
		      ang1_rad (* az1 (/ pi 180.0))
		      ang2_rad (* az2 (/ pi 180.0)))
		(if tem_posterior
		  (setq centro1 (list cx1 cy1) centro2 (list cx2 cy2))
		  (setq centro1 (list cx2 cy2) centro2 (list cx1 cy1)
			ang1_rad (* az2 (/ pi 180.0))
			ang2_rad (* az1 (/ pi 180.0))))
		(setq i 0)
		(while (< i 15)
		  (setq idx_base (+ 6 (* i 4))
			is_bt (>= i 12))
		  (if (_ENEL_CABO_TEM_VALOR row idx_base)
		    (progn
		      (if is_bt
			(setq pt1 (polar centro1 ang1_rad dist_offset)
			      pt2 (polar centro2 ang2_rad dist_offset))
			(setq pt1 centro1 pt2 centro2))
		      (if is_bt (setvar "clayer" "_CABOS_BT") (setvar "clayer" "_CABOS_MT"))
		      (command "_.LINE" pt1 pt2 "")))
		  (setq i (1+ i))))))))
      ))
  (princ)
)
