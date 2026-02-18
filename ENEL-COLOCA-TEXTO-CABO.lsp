;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_COLOCA_TEXTO_CABO >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-COLOCA-TEXTO-CABO.lsp
;;;<> ENEL_COLOCA_TEXTO_CABO
;;;++ DESCRICAO: Coloca texto em cada trecho de cabo (meio do vao), com quadrado/X/desloc conforme status
;;;++ ENTRADA: lst8 - (list lst_header lst_cabos) retorno de ENEL_CONVERT_LIST_CABO
;;;++ Regras: IMPL=quadrado, EXIST=sem contorno, RET=X, DESLOC=-desloc
;;;++ Posicao: meio do vao, distancia 4 perpendicular (lado global escolhido pelo usuario)
;;;++ Texto: h=1, middle center, espacamento 2.5, angulo do cabo
;;;++ Ordem: MT (CB_1A..CB_6B) IMPL/EXIST/RET/DESLOC, depois BT (CB_BT1..BT3)
;;;++ Quadrado/X rotacionados conforme angulo do cabo (mesma angulacao da linha)

(defun _ENEL_CABO_ROT_PT (pto pt ang / cx cy px py)
  (setq cx (car pto) cy (cadr pto) px (car pt) py (cadr pt))
  (list (+ cx (- (* (- px cx) (cos ang)) (* (- py cy) (sin ang))))
	(+ cy (+ (* (- px cx) (sin ang)) (* (- py cy) (cos ang))))))

(defun _ENEL_CABO_QUAD (pto txt ht ang / dx pad half p1 p2 p3 p4)
  ;; Middle center: quadrado centrado no ponto, fator 1.05, pad 0.5
  (setq dx (* (strlen txt) ht 1.05) pad 0.5 half (/ dx 2.0)
	p1 (list (- (car pto) half pad) (- (cadr pto) (/ ht 2.0) pad))
	p2 (list (+ (car pto) half pad) (- (cadr pto) (/ ht 2.0) pad))
	p3 (list (+ (car pto) half pad) (+ (cadr pto) (/ ht 2.0) pad))
	p4 (list (- (car pto) half pad) (+ (cadr pto) (/ ht 2.0) pad)))
  (setq p1 (_ENEL_CABO_ROT_PT pto p1 ang)
	p2 (_ENEL_CABO_ROT_PT pto p2 ang)
	p3 (_ENEL_CABO_ROT_PT pto p3 ang)
	p4 (_ENEL_CABO_ROT_PT pto p4 ang))
  (command "_.LINE" p1 p2 p3 p4 "C"))

(defun _ENEL_CABO_X (pto txt ht ang / dx pad half p1 p2 p3 p4)
  ;; Middle center: retangulo centrado no ponto, fator 1.05, pad 0.5
  (setq dx (* (strlen txt) ht 1.05) pad 0.5 half (/ dx 2.0)
	p1 (list (- (car pto) half pad) (- (cadr pto) (/ ht 2.0) pad))
	p2 (list (+ (car pto) half pad) (- (cadr pto) (/ ht 2.0) pad))
	p3 (list (+ (car pto) half pad) (+ (cadr pto) (/ ht 2.0) pad))
	p4 (list (- (car pto) half pad) (+ (cadr pto) (/ ht 2.0) pad)))
  (setq p1 (_ENEL_CABO_ROT_PT pto p1 ang)
	p2 (_ENEL_CABO_ROT_PT pto p2 ang)
	p3 (_ENEL_CABO_ROT_PT pto p3 ang)
	p4 (_ENEL_CABO_ROT_PT pto p4 ang))
  (command "_.LINE" p1 p3 "")
  (command "_.LINE" p2 p4 ""))

(defun _ENEL_CABO_NOME_TENSAO (cod / cabo tensa)
  (setq cabo (if (boundp 'ENEL_MODULO_CABO) (ENEL_MODULO_CABO cod) (vl-princ-to-string cod))
	tensa (if (boundp 'ENEL_MODULO_TENSAO) (ENEL_MODULO_TENSAO cod) nil))
  (cond ((and tensa (/= tensa ""))
	 (cond ((= tensa "15") (strcat cabo " - 13,8kV"))
	       ((= tensa "36") (strcat cabo " - 34,5kV"))
	       (t (strcat cabo " - " tensa))))
	(t cabo)))

(defun _ENEL_CABO_TXT_V (row idx)
  (cond ((null row) "")
	((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

(defun ENEL_COLOCA_TEXTO_CABO (lst8 / lst_cabos row cx1 cy1 cy2 pt1 pt2
				ponto_meio ang_cabo ang_perp lado_sign
				pt_base i idx_base lst_textos txt item
				ht espaco pt_txt
				cb_names_mt cb_names_bt echook dist_pt)
  
  (setq lst_cabos (cadr lst8)
	ht 1.0 espaco 2.5
	cb_names_mt '("CB_1A" "CB_1B" "CB_2A" "CB_2B" "CB_3A" "CB_3B" "CB_4A" "CB_4B" "CB_5A" "CB_5B" "CB_6A" "CB_6B")
	cb_names_bt '("CB_BT1" "CB_BT2" "CB_BT3"))
  (if (not lst_cabos)
    (princ "\n ENEL_COLOCA_TEXTO_CABO: lst8 sem dados.")
    (progn
      ;; Encontrar primeiro segmento valido (com pt2) para zoom e escolha do lado
      (setq row nil)
      (foreach r lst_cabos
	(if (and (not row) r (>= (length r) 68)
		 (nth 4 r) (nth 5 r)
		 (/= (_ENEL_CABO_TXT_V r 4) "") (/= (_ENEL_CABO_TXT_V r 5) ""))
	  (setq row r)))))

  (if (not row)
    (princ "\n ENEL_COLOCA_TEXTO_CABO: nenhum segmento valido para escolher lado.")
    (progn
      ;; Coordenadas primeiro segmento
      (setq cx1 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 2)))
	    cy1 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 3)))
	    cx2 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 4)))
	    cy2 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 5)))
	    pt1 (list cx1 cy1) pt2 (list cx2 cy2))
      ;; Zoom nos pontos
      (setq echook (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.ZOOM" "_W" (list (min cx1 cx2) (min cy1 cy2)) (list (max cx1 cx2) (max cy1 cy2)))
      (command "_.ZOOM" "0.8X")
      ;; Perguntar lado (global para todos os trechos)
      (initget 1)
      (setq pt_base (getpoint pt1 "\n Clique no lado onde colocar os textos dos cabos: "))
      (if pt_base
	(progn
	  ;; Calcular angulo cabo e perpendicular que aponta para o lado do clique
	  (setq ponto_meio (list (/ (+ cx1 cx2) 2.0) (/ (+ cy1 cy2) 2.0))
		dist_pt (distance pt1 pt2)
		ang_cabo (if (and (numberp dist_pt) (>= dist_pt 1e-6))
			    (angle pt1 pt2) 0.0))
	  ;; Perpendiculares: +90 ou -90. Escolher a que aponta para pt_base. Guardar sinal (global)
	  (if (> (sin (- (angle ponto_meio pt_base) ang_cabo)) 0)
	    (setq lado_sign 1)
	    (setq lado_sign -1))
	  ;; Percorrer todos os segmentos e colocar textos
	  (foreach row lst_cabos
	    (if (and row (>= (length row) 68)
		     (nth 4 row) (nth 5 row)
		     (/= (_ENEL_CABO_TXT_V row 4) "") (/= (_ENEL_CABO_TXT_V row 5) ""))
	      (progn
		(setq cx1 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 2)))
		      cy1 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 3)))
		      cx2 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 4)))
		      cy2 (atof (vl-string-subst "." "," (_ENEL_CABO_TXT_V row 5)))
		      pt1 (list cx1 cy1) pt2 (list cx2 cy2)
		      dist_pt (distance pt1 pt2)
		      ponto_meio (list (/ (+ cx1 cx2) 2.0) (/ (+ cy1 cy2) 2.0))
		      ang_cabo (if (and (numberp dist_pt) (>= dist_pt 1e-6))
				(angle pt1 pt2) 0.0))
		;; Pular segmento degenerado (pt1=pt2)
		(if (and (numberp dist_pt) (>= dist_pt 1e-6))
		  (progn
		;; Ponto base: meio + 4 na perpendicular (lado global = ang_cabo + lado_sign*90)
		(setq ang_perp (+ ang_cabo (* lado_sign (/ pi 2.0)))
		      pt_base (list (car (polar ponto_meio ang_perp 4.0))
				  (cadr (polar ponto_meio ang_perp 4.0))))
		(if (tblsearch "LAYER" "_TEXTO") (setvar "clayer" "_TEXTO"))
		;; Montar lista de textos: MT primeiro (IMPL, EXIST, RET, DESLOC), depois BT
		(setq lst_textos nil)
		;; MT: CB_1A..CB_6B - indices 6,10,14,...,50
		(setq i 0)
		(while (< i 12)
		  (setq idx_base (+ 6 (* i 4)))
		  (foreach suf '(0 1 2 3)
		    (setq txt (cond ((= suf 0) (_ENEL_CABO_TXT_V row idx_base))
				   ((= suf 1) (_ENEL_CABO_TXT_V row (1+ idx_base)))
				   ((= suf 2) (_ENEL_CABO_TXT_V row (+ idx_base 2)))
				   ((= suf 3) (_ENEL_CABO_TXT_V row (+ idx_base 3)))))
		    (if (and txt (/= txt ""))
		      (setq lst_textos (append lst_textos
			    (list (list (if (= suf 3)
				    (strcat (_ENEL_CABO_NOME_TENSAO txt) "-desloc")
				    (_ENEL_CABO_NOME_TENSAO txt))
					(= suf 0) (= suf 2)))))))
		  (setq i (1+ i)))
		;; BT: CB_BT1, CB_BT2, CB_BT3 - indices 54,58,62
		(setq i 12)
		(while (< i 15)
		  (setq idx_base (+ 6 (* i 4)))
		  (foreach suf '(0 1 2 3)
		    (setq txt (cond ((= suf 0) (_ENEL_CABO_TXT_V row idx_base))
				   ((= suf 1) (_ENEL_CABO_TXT_V row (1+ idx_base)))
				   ((= suf 2) (_ENEL_CABO_TXT_V row (+ idx_base 2)))
				   ((= suf 3) (_ENEL_CABO_TXT_V row (+ idx_base 3)))))
		    (if (and txt (/= txt ""))
		      (setq lst_textos (append lst_textos
			    (list (list (if (= suf 3)
				    (strcat (_ENEL_CABO_NOME_TENSAO txt) "-desloc")
				    (_ENEL_CABO_NOME_TENSAO txt))
					(= suf 0) (= suf 2)))))))
		  (setq i (1+ i)))
		;; Desenhar textos - middle center, espaco 2.5 na perpendicular, angulo cabo
		(setq pt_txt pt_base)
		(foreach item lst_textos
		  (setq txt (car item))
		  (if (and txt (/= txt ""))
		    (progn
		      (command "_.TEXT" "J" "MC" pt_txt ht (angtos ang_cabo 0 4) txt)
		      (if (cadr item)
			(vl-catch-all-apply '_ENEL_CABO_QUAD
			  (list (list (car pt_txt) (cadr pt_txt)) txt ht ang_cabo)))
		      (if (caddr item)
			(vl-catch-all-apply '_ENEL_CABO_X
			  (list (list (car pt_txt) (cadr pt_txt)) txt ht ang_cabo)))
		      (setq pt_txt (polar pt_txt ang_perp espaco))
		    )
		  )
		)
		  ))
	    )
	  )
	  )
	  (princ "\n ENEL_COLOCA_TEXTO_CABO: cancelado - lado nao escolhido.")
	)
      )
      (if (numberp echook) (setvar "CMDECHO" echook))
    )
  )
  (princ))
