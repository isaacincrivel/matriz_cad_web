;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_COORDENADAS_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-INSERE-COORDENADAS-CAD.LSP
;;;<> ENEL_INSERE_COORDENADAS_CAD
;;;++ DESCRICAO: Insere texto de coordenadas (lat, long) e angulo de deflexao em cada segmento de cabo
;;;++ ENTRADA: lst8 - (list lst_header lst_cabos) retorno de ENEL_CONVERT_LIST_CABO
;;;++ Posicao: ponto sequencia (corrx_1, corry_1), distancia 18, quadrantes 45/135/225/315, ssget area vazia
;;;++ Texto: h=1, middle left, espacamento vertical 1.9, linhas: lat, long, deflex (se houver ponto posterior)
;;;++ ENEL_DEFLEX: P1=anterior, P2=sequencia (vertex), P3=posterior. Requer anterior E posterior.

(defun _ENEL_COORD_V (row idx)
  (cond ((null row) "")
	((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

(defun _ENEL_COORD_AREA_VAZIA (pto lado / c1 c2 ss)
  (setq c1 (list (- (car pto) (/ lado 2.0)) (- (cadr pto) (/ lado 2.0)))
	c2 (list (+ (car pto) (/ lado 2.0)) (+ (cadr pto) (/ lado 2.0))))
  (ESHOP-ZOM_RAI c1 20)
  (setq ss (ssget "_C" c1 c2))  
  (null ss))







;;;++ Retorna primeiro quadrante vazio (45/135/225/315 graus) ou nil. Saida: (ang . pt_inser)
(defun _ENEL_COORD_QUADRANTE_VAZIO (pto dist lado / angulos a pt_teste resultado)
  (setq angulos (list (* 45 (/ pi 180.0)) (* 135 (/ pi 180.0)) (* 225 (/ pi 180.0)) (* 315 (/ pi 180.0)))
	resultado nil)
  (foreach a angulos
    (if (not resultado)
      (progn
	(setq pt_teste (polar pto a dist))
	(if (_ENEL_COORD_AREA_VAZIA pt_teste lado)
	  (setq resultado (cons a pt_teste))))))
  resultado)

;;;++ Calcula angulo de deflexao (abertura) no vertice p2 entre segmentos (p1-p2) e (p2-p3)
;;;++ Deflexao = angulo de giro de P1->P2 para P2->P3. E o suplementar do angulo interno (142+38=180).
(defun _ENEL_COORD_DEFLEX (p1 p2 p3 / ang3 ang4 diff interno)
  (setq ang3 (angle p2 p1)
	ang4 (angle p2 p3)
	diff (rem (- ang4 ang3) (* 2 pi)))
  (if (> diff pi) (setq diff (- diff (* 2 pi))))
  (if (< diff (- pi)) (setq diff (+ diff (* 2 pi))))
  (setq interno (abs diff))
  ;; Deflexao = min(interno, pi-interno) = angulo de abertura (38 na imagem, nao 142)
  (min interno (- pi interno)))


(defun ENEL_INSERE_COORDENADAS_CAD (lst8 / lst_cabos row
				     corrx_1 corry_1 corrx_3 corry_3
				     v_ant_x v_ant_y pt_seq pt_ant pt_post lat long
				     quadrante pt_inser
				     lst_textos txt deflex_rad txt_deflex
				     ht espaco ang_perp)
  (setq lst_cabos (cadr lst8)
	ht 1.0
	espaco 1.9)
  (if (not lst_cabos)
    (princ "\n ENEL_INSERE_COORDENADAS_CAD: lst8 sem dados.")
    (progn
  
	(setvar "clayer" "_TEXTO_COORDENADAS")
      
      (foreach row lst_cabos
	(if (and row (>= (length row) 76)
		 (nth 2 row) (nth 3 row)
		 (/= (_ENEL_COORD_V row 2) "") (/= (_ENEL_COORD_V row 3) "")
		 (nth 74 row) (nth 75 row)
		 (/= (_ENEL_COORD_V row 74) "") (/= (_ENEL_COORD_V row 75) ""))
	  (progn
	    ;; Coordenadas (corrx_2/corry_2=vazio quando sem anterior, ex: primeiro poste ou deriva nova)
	    (setq corrx_1 (atof (vl-string-subst "." "," (_ENEL_COORD_V row 2)))
		  corry_1 (atof (vl-string-subst "." "," (_ENEL_COORD_V row 3)))
		  pt_seq (list corrx_1 corry_1)
		  v_ant_x (_ENEL_COORD_V row 4)
		  v_ant_y (_ENEL_COORD_V row 5)
		  pt_ant (if (and v_ant_x v_ant_y (/= (vl-princ-to-string v_ant_x) "") (/= (vl-princ-to-string v_ant_y) ""))
			     (list (atof (vl-string-subst "." "," (vl-princ-to-string v_ant_x)))
				   (atof (vl-string-subst "." "," (vl-princ-to-string v_ant_y))))
			     nil)
		  lat (_ENEL_COORD_V row 74)
		  long (_ENEL_COORD_V row 75))
	    ;; Ponto posterior (corrx_3, corry_3) - vazio no ultimo poste ou quando deriva preenchida (nova rede)
	    (setq corrx_3 (_ENEL_COORD_V row 72)
		  corry_3 (_ENEL_COORD_V row 73)
		  pt_post nil)
	    (if (and corrx_3 corry_3 (/= corrx_3 "") (/= corry_3 ""))
	      (setq pt_post (list (atof (vl-string-subst "." "," corrx_3))
				  (atof (vl-string-subst "." "," corry_3)))))
	    ;; Montar linhas de texto: lat, long, deflex (se houver anterior E posterior e deflex >= 1 grau)
	    (setq lst_textos (list (strcat "lat: " lat)
				  (strcat "long: " long)))
	    (if (and pt_ant pt_post)
	      (progn
		(setq deflex_rad (_ENEL_COORD_DEFLEX pt_ant pt_seq pt_post))
		(if (>= deflex_rad (* 1 (/ pi 180.0)))
		  (setq lst_textos (append lst_textos (list (strcat "Ang:" (angtos deflex_rad 0 0) "°")))))))


	    
	    ;; Escolher quadrante vazio (distancia 18, area 10) - verifica os 4 quadrantes
	    (setq quadrante (_ENEL_COORD_QUADRANTE_VAZIO pt_seq 11.0 10.0))
	    (if quadrante
	      (setq pt_inser (cdr quadrante))
	      (setq pt_inser (polar pt_seq (* 45 (/ pi 180.0)) 18.0)))
	    ;; Inserir textos - middle left, espaco vertical 1.9 (para baixo)
	    (setq ang_perp (- (/ pi 2.0)))
	    (foreach txt lst_textos
	      (if (and txt (/= txt ""))
		(progn
		  (command "_.TEXT" "J" "ML" pt_inser ht "0" txt)
		  (setq pt_inser (polar pt_inser ang_perp espaco))))))))))
  (princ)
)
