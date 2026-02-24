;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_EVENTUAIS >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-INSERE-EVENTUAIS.lsp
;;;<> ENEL_INSERE_EVENTUAIS
;;;++ DESCRICAO: Insere blocos ABERTURA_FAIXA, CORTE_ARV_ISOLADA, CERCA_DE_ARAME quando faixa, cort_arvores_isol ou cerca tem dados
;;;++ ENTRADA: lst8 - (list lst_header lst_cabos) retorno de ENEL_CONVERT_LIST_CABO
;;;++ Posicao: ponto_meio_vao (meio entre seq e deriva), quadrantes 45/135/225/315, distancia 15
;;;++ Multiplos blocos: primeiro em 15, seguintes +9 na mesma direcao (15, 24, 33...)
;;;++ Area vazia: quadrado 10x10 para ssget

(defun _ENEL_EV_V (row idx)
  (cond ((null row) "")
	((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

(defun _ENEL_EV_AREA_VAZIA (pto lado / c1 c2 ss)
  (setq c1 (list (- (car pto) (/ lado 2.0)) (- (cadr pto) (/ lado 2.0)))
	c2 (list (+ (car pto) (/ lado 2.0)) (+ (cadr pto) (/ lado 2.0))))
  (setq ss (ssget "_C" c1 c2))
  (null ss))

;;;(defun _ENEL_EV_INSERE_BLOCO (blocname pt valor / val_str)
;;;  (setq val_str (vl-princ-to-string (or valor "")))
;;;  (if (tblsearch "BLOCK" blocname)
;;;    (progn
;;;      (command "_.INSERT" blocname pt "1" "1" "0" val_str)
;;;      T)
;;;    (progn
;;;      (princ (strcat "\n Bloco " blocname " nao encontrado."))
;;;      nil)))

(defun ENEL_INSERE_EVENTUAIS (lst8 / lst_cabos row
			      cx1 cy1 cx2 cy2 ponto_meio_vao
			      faixa cort_arv cerca
			      lst_blocos bloc_item blocname valor
			      angulos ang ok idx dist_inser
			      pt_inser)
  (setq lst_cabos (cadr lst8))
  (if (not lst_cabos)
    (princ "\n ENEL_INSERE_EVENTUAIS: lst8 sem dados.")
    (progn
      (setq angulos (list (* 45 (/ pi 180.0)) (* 135 (/ pi 180.0)) (* 225 (/ pi 180.0)) (* 315 (/ pi 180.0))))
      (foreach row lst_cabos
	(setq cx1 (atof (vl-string-subst "." "," (_ENEL_EV_V row 2)))
	      cy1 (atof (vl-string-subst "." "," (_ENEL_EV_V row 3)))
	      cx2 nil cy2 nil)
	(if (and row (>= (length row) 76)
		 (nth 72 row) (nth 73 row)
		 (/= (_ENEL_EV_V row 72) "") (/= (_ENEL_EV_V row 73) ""))
	  (setq cx2 (atof (vl-string-subst "." "," (_ENEL_EV_V row 72)))
		cy2 (atof (vl-string-subst "." "," (_ENEL_EV_V row 73)))))
	(if (and (null cx2) (nth 4 row) (nth 5 row)
		 (/= (_ENEL_EV_V row 4) "") (/= (_ENEL_EV_V row 5) ""))
	  (setq cx2 (atof (vl-string-subst "." "," (_ENEL_EV_V row 4)))
		cy2 (atof (vl-string-subst "." "," (_ENEL_EV_V row 5)))))
	(if (and cx2 cy2)
	  (progn
	    (setq ponto_meio_vao (list (/ (+ cx1 cx2) 2.0) (/ (+ cy1 cy2) 2.0))
		  faixa (_ENEL_EV_V row 68)
		  cort_arv (_ENEL_EV_V row 69)
		  cerca (_ENEL_EV_V row 70))
	    ;; Lista de blocos a inserir: (blocname . valor) na ordem faixa, cort_arvores, cerca
	    (setq lst_blocos nil)
	    (if (and faixa (/= faixa ""))
	      (setq lst_blocos (append lst_blocos (list (cons "ABERTURA_FAIXA" faixa)))))
	    (if (and cort_arv (/= cort_arv ""))
	      (setq lst_blocos (append lst_blocos (list (cons "CORTE_ARV_ISOLADA" cort_arv)))))
	    (if (and cerca (/= cerca ""))
	      (setq lst_blocos (append lst_blocos (list (cons "CERCA_DE_ARAME" cerca)))))
	    (if lst_blocos
	      (progn
		;; Encontrar quadrante vazio (10x10) no ponto a 15 unidades
		(setq ok nil ang (car angulos))
		(foreach a angulos
		  (if (not ok)
		    (progn
		      (setq pt_inser (polar ponto_meio_vao a 15))
		      (if (_ENEL_EV_AREA_VAZIA pt_inser 10.0)
			(setq ok T ang a)))))
		;; Inserir blocos: primeiro em 15, seguintes +9 na mesma direcao
		(if (tblsearch "LAYER" "_EVENTUAIS")
		  (setvar "clayer" "_EVENTUAIS"))
		
		(setq idx 0)
		(foreach bloc_item lst_blocos
		  (setq blocname (car bloc_item) valor (cdr bloc_item)
			dist_inser (+ 15 (* idx 9))
			pt_inser (polar ponto_meio_vao ang dist_inser))

		  (command "_.INSERT" blocname pt_inser "1" "1" "0" valor)

		  
;;;		  (_ENEL_EV_INSERE_BLOCO blocname pt_inser valor)
		  (setq idx (1+ idx))))))))))
  (princ)
)
