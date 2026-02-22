;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_COORDENADAS_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-INSERE-COORDENADAS-CAD.LSP
;;;<> ENEL_INSERE_COORDENADAS_CAD
;;;++ DESCRICAO: Insere texto de coordenadas (lat, long) e angulo de deflexao em cada segmento de cabo
;;;++ ENTRADA: lst8 - (list lst_header lst_cabos) retorno de ENEL_CONVERT_LIST_CABO
;;;++ Posicao: ponto sequencia (corrx_1, corry_1), distancia 18, quadrantes 45/135/225/315, ssget area vazia
;;;++ Texto: h=1, middle left, espacamento vertical 1.9, linhas: lat, long, deflex (se houver ponto posterior)
;;;++ ENEL_DEFLEX: P1=deriva, P2=sequencia, P3=posterior (vertex em P2)

(defun _ENEL_COORD_V (row idx)
  (cond ((null row) "")
	((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

(defun _ENEL_COORD_AREA_VAZIA (pto lado / c1 c2 ss)
  (setq c1 (list (- (car pto) (/ lado 2.0)) (- (cadr pto) (/ lado 2.0)))
	c2 (list (+ (car pto) (/ lado 2.0)) (+ (cadr pto) (/ lado 2.0))))
  (setq ss (ssget "_C" c1 c2))
  (null ss))

;;;++ Calcula angulo de deflexao no vertice p2 entre segmentos (p1-p2) e (p2-p3)
(defun _ENEL_COORD_DEFLEX (p1 p2 p3 / ang3 ang4 diff)
  (setq ang3 (angle p2 p1)
	ang4 (angle p2 p3)
	diff (rem (- ang4 ang3) (* 2 pi)))
  (if (> diff pi) (setq diff (- diff (* 2 pi))))
  (if (< diff (- pi)) (setq diff (+ diff (* 2 pi))))
  (abs diff))

(defun ENEL_INSERE_COORDENADAS_CAD (lst8 / lst_cabos row
				     corrx_1 corry_1 corrx_2 corry_2 corrx_3 corry_3
				     pt_seq pt_deriv pt_post lat long
				     angulos ang ok pt_inser
				     lst_textos txt deflex_rad txt_deflex
				     ht espaco ang_perp)
  (setq lst_cabos (cadr lst8)
	ht 1.0
	espaco 1.9
	angulos (list (* 45 (/ pi 180.0)) (* 135 (/ pi 180.0)) (* 225 (/ pi 180.0)) (* 315 (/ pi 180.0))))
  (if (not lst_cabos)
    (princ "\n ENEL_INSERE_COORDENADAS_CAD: lst8 sem dados.")
    (progn


      (if (tblsearch "LAYER" "_TEXTO")
	(setvar "clayer" "_TEXTO_COORDENADAS"))

      
      (foreach row lst_cabos
	(if (and row (>= (length row) 76)
		 (nth 2 row) (nth 3 row)
		 (/= (_ENEL_COORD_V row 2) "") (/= (_ENEL_COORD_V row 3) "")
		 (nth 74 row) (nth 75 row)
		 (/= (_ENEL_COORD_V row 74) "") (/= (_ENEL_COORD_V row 75) ""))
	  (progn
	    ;; Coordenadas
	    (setq corrx_1 (atof (vl-string-subst "." "," (_ENEL_COORD_V row 2)))
		  corry_1 (atof (vl-string-subst "." "," (_ENEL_COORD_V row 3)))
		  corrx_2 (atof (vl-string-subst "." "," (_ENEL_COORD_V row 4)))
		  corry_2 (atof (vl-string-subst "." "," (_ENEL_COORD_V row 5)))
		  pt_seq (list corrx_1 corry_1)
		  pt_deriv (list corrx_2 corry_2)
		  lat (_ENEL_COORD_V row 74)
		  long (_ENEL_COORD_V row 75))
	    ;; Ponto posterior (corrx_3, corry_3) - so se seq_posterior e coords preenchidos
	    (setq corrx_3 (_ENEL_COORD_V row 72)
		  corry_3 (_ENEL_COORD_V row 73)
		  pt_post nil)
	    (if (and corrx_3 corry_3 (/= corrx_3 "") (/= corry_3 ""))
	      (setq pt_post (list (atof (vl-string-subst "." "," corrx_3))
				  (atof (vl-string-subst "." "," corry_3)))))
	    ;; Montar linhas de texto: lat, long, deflex (se houver posterior)
	    (setq lst_textos (list (strcat "lat: " lat)
				  (strcat "long: " long)))
	    (if pt_post
	      (progn
		(setq deflex_rad (_ENEL_COORD_DEFLEX pt_deriv pt_seq pt_post))
		(setq txt_deflex (angtos deflex_rad 0 4))
		(setq lst_textos (append lst_textos (list txt_deflex)))))
	    ;; Escolher quadrante vazio (distancia 18, area 10)
	    (setq ok nil ang (car angulos))
	    (foreach a angulos
	      (if (not ok)
		(progn
		  (setq pt_inser (polar pt_seq a 18.0))
		  (if (_ENEL_COORD_AREA_VAZIA pt_inser 10.0)
		    (setq ok T ang a)))))
	    (if (not ok)
	      (setq ang (car angulos) pt_inser (polar pt_seq ang 18.0)))
	    ;; Inserir textos - middle left, espaco vertical 1.9 (para baixo)
	    (setq ang_perp (- (/ pi 2.0)))
	    (foreach txt lst_textos
	      (if (and txt (/= txt ""))
		(progn
		  (command "_.TEXT" "J" "ML" pt_inser ht "0" txt)
		  (setq pt_inser (polar pt_inser ang_perp espaco))))))))))
  (princ)
)
