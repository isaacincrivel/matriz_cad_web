;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_CABOS_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-INSERE-CABOS-CAD.lsp
;;;<> ENEL_INSERE_CABOS_CAD
;;;++ DESCRICAO: Desenha linhas de cabo do ponto sequencia ao ponto deriva, a partir de lst8 (ENEL_CONVERT_LIST_CABO)
;;;++ ENTRADA: lst8 - (list lst_header lst_cabos) retorno de ENEL_CONVERT_LIST_CABO
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
			       pt1 pt2 ang1_rad ang2_rad
			       i idx_base is_bt dist_offset)
  (setq lst_cabos (cadr lst8))
  (if (not lst_cabos)
    (princ "\n ENEL_INSERE_CABOS_CAD: lst8 sem dados.")
    (progn
      (setq dist_offset 1.465)
      ;; Indices: 0=seq, 1=deriva, 2=corrx_1, 3=corry_1, 4=corrx_2, 5=corry_2, 6-65=CB, 66=azimute_1, 67=azimute_2
      ;; Ultimo poste: deriva vazia e sem proximo -> corrx_2/corry_2 vazios -> nao desenhar cabo
      (foreach row lst_cabos
	(if (and row (>= (length row) 68)
		 (nth 4 row) (nth 5 row)
		 (/= (vl-princ-to-string (nth 4 row)) "")
		 (/= (vl-princ-to-string (nth 5 row)) ""))
	  (progn
	    (setq cx1 (_ENEL_STR_NUM (nth 2 row))
		  cy1 (_ENEL_STR_NUM (nth 3 row))
		  cx2 (_ENEL_STR_NUM (nth 4 row))
		  cy2 (_ENEL_STR_NUM (nth 5 row))
		  az1 (_ENEL_STR_NUM (nth 66 row))
		  az2 (_ENEL_STR_NUM (nth 67 row))
		  ang1_rad (* az1 (/ pi 180.0))
		  ang2_rad (* az2 (/ pi 180.0)))
	    ;; 15 cabos: CB_1A(6), CB_1B(10), CB_2A(14)... CB_6B(50), CB_BT1(54), CB_BT2(58), CB_BT3(62)
	    (setq i 0)
	    (while (< i 15)
	      (setq idx_base (+ 6 (* i 4))
		    is_bt (>= i 12))
	      (if (_ENEL_CABO_TEM_VALOR row idx_base)
		(progn
		  (if is_bt
		    ;; BT: polar 1.465 a partir do centro
		    (progn
		      (setq pt1 (polar (list cx1 cy1) ang1_rad dist_offset)
			    pt2 (polar (list cx2 cy2) ang2_rad dist_offset))
		      (setvar "clayer" "_CABOS_BT"))
		    ;; MT (CB_1A..CB_6B): centro a centro
		    (progn
		      (setq pt1 (list cx1 cy1)
			    pt2 (list cx2 cy2))
		      (setvar "clayer" "_CABOS_MT")))
			  (command "_.LINE" pt1 pt2 "")
		  ))
	      (setq i (1+ i))
	      ))
	  ))
      ))
  (princ)
)
