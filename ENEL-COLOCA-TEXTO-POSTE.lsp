;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_COLOCA_TEXTO_POSTE >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-COLOCA-TEXTO-POSTE.lsp
;;;<> ENEL_COLOCA_TEXTO_POSTE
;;;++ DESCRICAO: Coloca texto de chamada (P+seq) e texto descritivo (poste, estruturas) em cada poste
;;;++ ENTRADA: lst1 - (list lst_header lst4) retorno de ENEL_CONVERT_LIST_POSTE
;;;++ Callout: circulo r=1.6 + texto P+seq h=1, polar 5.4, ssget quadrado 3.6 nos quadrantes 45/135/225/315
;;;++ Descritivo: polar 18.5, quadrado ssget 8.1 ancorado canto sup esq, middle left, esp 1.7, IMPL=quadrado, EXIST=sem, RET=X, DESLOC=-desloc
;;;++ Se nenhum quadrante estiver vazio, usa o primeiro (45 graus)

(defun _ENEL_TXT_V (row idx)
  (cond ((null row) "")
	((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

;;; DEBUG: desenhar quadrados ssget na tela (habilitado para visualizacao)
(defun _ENEL_DEBUG_QUAD (pto lado esq_sup / ladof p1 p2 p3 p4)
  ;; esq_sup=T: pto = canto superior esquerdo; nil: pto = centro
  (if (and pto (numberp (car pto)) (numberp (cadr pto)))
    (progn
      (setq ladof (float (if (numberp lado) lado 4.2)))
      (if esq_sup
	(setq p1 pto
	      p2 (list (+ (car pto) ladof) (cadr pto))
	      p3 (list (+ (car pto) ladof) (- (cadr pto) ladof))
	      p4 (list (car pto) (- (cadr pto) ladof)))
	(setq p1 (list (- (car pto) (/ ladof 2.0)) (- (cadr pto) (/ ladof 2.0)))
	      p2 (list (+ (car pto) (/ ladof 2.0)) (- (cadr pto) (/ ladof 2.0)))
	      p3 (list (+ (car pto) (/ ladof 2.0)) (+ (cadr pto) (/ ladof 2.0)))
	      p4 (list (- (car pto) (/ ladof 2.0)) (+ (cadr pto) (/ ladof 2.0)))))
      (entmake (list (cons 0 "LWPOLYLINE") (cons 8 "_TEXTO") (cons 100 "AcDbEntity") (cons 100 "AcDbPolyline")
		     (cons 90 4) (cons 70 1)
		     (cons 10 p1) (cons 10 p2) (cons 10 p3) (cons 10 p4))))))




(defun _ENEL_AREA_VAZIA (pto lado esq_sup / c1 c2 ss)
  (if esq_sup
    (setq c1 pto
	  c2 (list (+ (car pto) lado) (- (cadr pto) lado)))
    (setq c1 (list (- (car pto) (/ lado 2.0)) (- (cadr pto) (/ lado 2.0)))
	  c2 (list (+ (car pto) (/ lado 2.0)) (+ (cadr pto) (/ lado 2.0)))))

  (ESHOP-ZOM_RAI c1 20)
  (setq ss (ssget "_C" c1 c2))
  (null ss))

(defun _ENEL_DESENHA_QUAD (pto txt ht / dx pad p1 p2 p3 p4)
  (setq dx (* (strlen txt) ht 0.82) pad 0.45)
  (setq p1 (list (- (car pto) pad) (- (cadr pto) (/ ht 2.0) pad))
	p2 (list (+ (car pto) dx pad) (- (cadr pto) (/ ht 2.0) pad))
	p3 (list (+ (car pto) dx pad) (+ (cadr pto) (/ ht 2.0) pad))
	p4 (list (- (car pto) pad) (+ (cadr pto) (/ ht 2.0) pad)))
  (command "_.LINE" p1 p2 p3 p4 "C")
)

(defun _ENEL_DESENHA_X (pto txt ht / dx pad p1 p2 p3 p4)
  (setq dx (* (strlen txt) ht 0.82) pad 0.45)
  (setq p1 (list (- (car pto) pad) (- (cadr pto) (/ ht 2.0) pad))
	p2 (list (+ (car pto) dx pad) (- (cadr pto) (/ ht 2.0) pad))
	p3 (list (+ (car pto) dx pad) (+ (cadr pto) (/ ht 2.0) pad))
	p4 (list (- (car pto) pad) (+ (cadr pto) (/ ht 2.0) pad)))
  ;; X: diagonais do retangulo p1->p3 e p2->p4
  (command "_.LINE" p1 p3 "")
  (command "_.LINE" p2 p4 ""))

(defun ENEL_COLOCA_TEXTO_POSTE (lst1 / 			 lst4 row seq utmx utmy PONTO_POSTE
				 angulos ang PONTO_CHAMADA PONTO_TEXTO
				 ok i idx poste_impl poste_exist poste_ret poste_desloc num_poste
				 est_names lst_textos txt linha_y ht espaco
				 suf idx_base j val)
  (setq lst4 (cadr lst1))
  (if (not lst4)
    (princ "\n ENEL_COLOCA_TEXTO_POSTE: lst1 sem dados.")
    (progn
      (setq angulos (list (* 45 (/ pi 180.0)) (* 135 (/ pi 180.0)) (* 225 (/ pi 180.0)) (* 315 (/ pi 180.0)))
	    ht 1.0 espaco 1.9)
      (foreach row lst4
	(if (and row (>= (length row) 119))
	  (progn
	    (setq seq (_ENEL_TXT_V row 0))
	    (setq utmx (atof (vl-string-subst "." "," (_ENEL_TXT_V row 116)))
		  utmy (atof (vl-string-subst "." "," (_ENEL_TXT_V row 117)))
		  PONTO_POSTE (list utmx utmy))
	    (if (and seq (/= seq "") (numberp utmx) (numberp utmy))
	      (progn
		;; Parte 1: Ponto de chamada (P+seq) - polar 5.4, circulo 1.6, quadrado ssget 3.6
		(setq ok nil)
		(foreach ang angulos
		  (if (not ok)
		    (progn
		      (setq PONTO_CHAMADA (polar PONTO_POSTE ang 5.4))
		      (if (_ENEL_AREA_VAZIA PONTO_CHAMADA 3.6 nil)
			(progn (setq ok T)
			  (setvar "clayer" "_TEXTO_PONTO")
			  (command "_.CIRCLE" PONTO_CHAMADA 1.6)
			  (command "_.TEXT" "J" "MC" PONTO_CHAMADA ht "0" (strcat "P" seq)))))))

		
		(if (not ok)
		  (progn (setq ang (car angulos) PONTO_CHAMADA (polar PONTO_POSTE ang 5.4))
		    
		    ;(_ENEL_DEBUG_QUAD PONTO_CHAMADA 3.6 nil)
		    
		    (setvar "clayer" "_TEXTO_PONTO")
		    (command "_.CIRCLE" PONTO_CHAMADA 1.6)
		    (command "_.TEXT" "J" "MC" PONTO_CHAMADA ht "0" (strcat "P" seq))))
		;; Parte 2: Texto descritivo - polar 18.5, quadrado ssget 8.1, middle left, espaco 1.7
		(setq ok nil)
		(foreach ang angulos
		  (if (not ok)
		    (progn
		      (setq PONTO_TEXTO (polar PONTO_POSTE ang 18.5))
		      (if (_ENEL_AREA_VAZIA PONTO_TEXTO 8.1 T)
			(setq ok T)))))
		(if (not ok)
		  (setq ang (car angulos) PONTO_TEXTO (polar PONTO_POSTE ang 18.5)))
		;(_ENEL_DEBUG_QUAD PONTO_TEXTO 8.1 T)
		(setvar "clayer" "_TEXTO_PONTO")
		;; Montar lista de textos: P+seq, num_poste, IMPL(box), EXIST(sem), RET(X), DESLOC(-desloc)
		(setq lst_textos (list (list (strcat "P" seq) nil nil)))
		(setq num_poste (_ENEL_TXT_V row 66))
		(if (and num_poste (/= num_poste ""))
		  (setq lst_textos (append lst_textos (list (list num_poste nil nil)))))
			  ;; POSTE_IMPL e EST_*_IMPL
			  (setq poste_impl (_ENEL_TXT_V row 1))
			  (if (and poste_impl (/= poste_impl ""))
			    (setq lst_textos (append lst_textos (list (list poste_impl T nil)))))
			  (setq est_names '("EST_1A" "EST_1B" "EST_2A" "EST_2B" "EST_3A" "EST_3B"
					   "EST_4A" "EST_4B" "EST_5A" "EST_5B" "EST_6A" "EST_6B"
					   "EST_BT1" "EST_BT2" "EST_BT3"))
			  (setq j 0)
			  (foreach en est_names
			    (setq idx_base (+ 6 (* j 4)))
			    (setq val (_ENEL_TXT_V row idx_base))
			    (if (and val (/= val ""))
			      (setq lst_textos (append lst_textos (list (list val T nil)))))
			    (setq j (1+ j)))
			  ;; POSTE_EXIST e EST_*_EXIST
			  (setq poste_exist (_ENEL_TXT_V row 2))
			  (if (and poste_exist (/= poste_exist ""))
			    (setq lst_textos (append lst_textos (list (list poste_exist nil nil)))))
			  (setq j 0)
			  (foreach en est_names
			    (setq idx_base (+ 7 (* j 4)))
			    (setq val (_ENEL_TXT_V row idx_base))
			    (if (and val (/= val ""))
			      (setq lst_textos (append lst_textos (list (list val nil nil)))))
			    (setq j (1+ j)))
			  ;; POSTE_RET e EST_*_RET
			  (setq poste_ret (_ENEL_TXT_V row 3))
			  (if (and poste_ret (/= poste_ret ""))
			    (setq lst_textos (append lst_textos (list (list poste_ret nil T)))))
			  (setq j 0)
			  (foreach en est_names
			    (setq idx_base (+ 8 (* j 4)))
			    (setq val (_ENEL_TXT_V row idx_base))
			    (if (and val (/= val ""))
			      (setq lst_textos (append lst_textos (list (list val nil T)))))
			    (setq j (1+ j)))
			  ;; POSTE_DESLOC e EST_*_DESLOC
			  (setq poste_desloc (_ENEL_TXT_V row 4))
			  (if (and poste_desloc (/= poste_desloc ""))
			    (setq lst_textos (append lst_textos (list (list (strcat poste_desloc "-desloc") nil nil)))))
			  (setq j 0)
			  (foreach en est_names
			    (setq idx_base (+ 9 (* j 4)))
			    (setq val (_ENEL_TXT_V row idx_base))
			    (if (and val (/= val ""))
			      (setq lst_textos (append lst_textos (list (list (strcat val "-desloc") nil nil)))))
			    (setq j (1+ j)))
			  ;; Desenhar textos - middle left, espacamento 1.7
			  (setq linha_y (cadr PONTO_TEXTO))
			  (foreach item lst_textos
			    (setq txt (car item))
			    (if (and txt (/= txt ""))
			      (progn
				(command "_.TEXT" "J" "ML" (list (car PONTO_TEXTO) linha_y) ht "0" txt)
				(if (cadr item)
				  (_ENEL_DESENHA_QUAD (list (car PONTO_TEXTO) linha_y) txt ht))
				(if (caddr item)
				  (_ENEL_DESENHA_X (list (car PONTO_TEXTO) linha_y) txt ht))
				(setq linha_y (- linha_y espaco))))))))
	  ))
	))
  (princ)
)