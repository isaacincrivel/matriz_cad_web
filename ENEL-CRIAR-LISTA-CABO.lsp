;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_CONVERT_LIST_CABO >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-CRIAR-LISTA-CABO.lsp
;;;<> ENEL_CONVERT_LIST_CABO
;;;++ DESCRICAO: Converte MATRIZ_NOVA.csv em lista de segmentos de cabo (1 linha por segmento)
;;;++ ENTRADA: str1 - caminho do CSV (ex: "C:/MATRIZ/MATRIZ_NOVA.csv")
;;;++ SAIDA: (list lst_header lst_cabos) - lst_header=titulos, lst_cabos=lista de segmentos
;;;++ Regra: deriva vazia -> segundo ponto = proximo poste (N+1); deriva preenchida -> segundo ponto = poste com sequencia D
;;;++ Coordenadas: corrx_1,corry_1=ponto sequencia; corrx_2,corry_2=ponto deriva (ou proximo)
;;;++ Formato numerico: virgula como separador decimal (ex: 194859,6)
;;;++ Usa ENEL_CNV_STR_LST de ENEL-CRIAR-LISTA-POSTE.lsp

(defun _ENEL_CABO_V (row idx)
  (cond ((null row) "")
	((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

;;;++ Cabeçalhos: sequencia, deriva, corrx_1, corry_1, corrx_2, corry_2, CB_*..., azimute_1, azimute_2, faixa..., seq_posterior, corrx_3, corry_3
(defun ENEL_LISTA_CABO (/ cb_names sufixos lst_header c s)
  (setq cb_names '("CB_1A" "CB_1B" "CB_2A" "CB_2B" "CB_3A" "CB_3B" "CB_4A" "CB_4B"
		   "CB_5A" "CB_5B" "CB_6A" "CB_6B" "CB_BT1" "CB_BT2" "CB_BT3")
	sufixos '("_IMPL" "_EXIST" "_RET" "_DESLOC")
	lst_header (list "sequencia" "deriva" "corrx_1" "corry_1" "corrx_2" "corry_2"))
  (foreach c cb_names
    (foreach s sufixos
      (setq lst_header (append lst_header (list (strcat c s))))))
  (setq lst_header (append lst_header
    (list "azimute_1" "azimute_2" "faixa" "cort_arvores_isol" "cerca"
	  "seq_posterior" "corrx_3" "corry_3" "lat" "long")))
  lst_header
)

(defun ENEL_CONVERT_LIST_CABO (str1 / arq1 str_line lst_all lst_row rows r
				linha_impl linha_exist linha_ret linha_desloc linha_ref
				lst_header lst_cabos lst_postes_raw lst_header_csv idx_lat idx_long
				seq deriva utm_x utm_y cb_impl cb_exist cb_ret cb_desloc
				map_coords seq_next i j seg
				corrx_1 corry_1 corrx_2 corry_2 deriva_out val
				azimute_1 azimute_2 azimute
				seq_posterior corrx_3 corry_3 p_next deriva_next
				lat long)
  
  (setq lst_cabos nil lst_all nil lst_postes_raw nil)
  ;; Ler CSV: primeira linha = cabecalho para achar indices de lat e long
  (setq arq1 (open str1 "r"))
  (if arq1
    (progn
      (setq lst_header_csv (ENEL_CNV_STR_LST (read-line arq1))
	    idx_lat (vl-position "LAT" (mapcar 'strcase (mapcar 'vl-princ-to-string lst_header_csv)))
	    idx_long (vl-position "LONG" (mapcar 'strcase (mapcar 'vl-princ-to-string lst_header_csv))))
      (if (not idx_lat) (setq idx_lat -1))
      (if (not idx_long) (setq idx_long -1))
      (while (setq str_line (read-line arq1))
	(setq lst_row (ENEL_CNV_STR_LST str_line))
	(if (>= (length lst_row) 20)
	  (setq lst_all (append lst_all (list lst_row)))))
      (close arq1)
      ;; Agrupar 4 linhas por poste e extrair dados
      (while lst_all
	(setq rows (list (car lst_all)))
	(setq lst_all (cdr lst_all))
	(if lst_all (setq rows (append rows (list (car lst_all))) lst_all (cdr lst_all)))
	(if lst_all (setq rows (append rows (list (car lst_all))) lst_all (cdr lst_all)))
	(if lst_all (setq rows (append rows (list (car lst_all))) lst_all (cdr lst_all)))
	(while (< (length rows) 4) (setq rows (append rows (list nil))))
	;; Identificar linhas por status
	(setq linha_impl nil linha_exist nil linha_ret nil linha_desloc nil linha_ref nil)
	(foreach r rows
	  (if r
	    (progn
	      (setq val (strcase (cond ((null (nth 2 r)) "") ((= (type (nth 2 r)) 'STR) (nth 2 r)) (t (vl-princ-to-string (nth 2 r))))))
	      (cond ((= val "IMPLANTAR") (setq linha_impl r))
		    ((= val "EXISTENTE") (setq linha_exist r))
		    ((= val "RETIRAR") (setq linha_ret r))
		    ((= val "DESLOCAR") (setq linha_desloc r)))
	      (if (and (>= (length r) 72) (nth 69 r) (nth 70 r)
		       (/= (cond ((null (nth 69 r)) "") (t (vl-princ-to-string (nth 69 r)))) "")
		       (/= (cond ((null (nth 70 r)) "") (t (vl-princ-to-string (nth 70 r)))) ""))
		(setq linha_ref r)))))
	(if (not linha_ref) (setq linha_ref (car rows)))
	(setq seq (_ENEL_CABO_V (car rows) 0))
	(setq deriva (_ENEL_CABO_V (car rows) 1))
	(setq utm_x (_ENEL_CABO_V linha_ref 69))
	(setq utm_y (_ENEL_CABO_V linha_ref 70))
	(setq azimute (_ENEL_CABO_V linha_ref 71))
	;; CB por status (indices 3-17)
	(setq cb_impl nil cb_exist nil cb_ret nil cb_desloc nil)
	(setq i 3)
	(repeat 15
	  (setq cb_impl (append cb_impl (list (_ENEL_CABO_V linha_impl i))))
	  (setq cb_exist (append cb_exist (list (_ENEL_CABO_V linha_exist i))))
	  (setq cb_ret (append cb_ret (list (_ENEL_CABO_V linha_ret i))))
	  (setq cb_desloc (append cb_desloc (list (_ENEL_CABO_V linha_desloc i))))
	  (setq i (1+ i)))
	;; faixa, cort_arvores_isol, cerca: somente da linha IMPLANTAR (poste origem). lat, long: ponto sequencia (linha_ref)
	(setq lst_postes_raw (append lst_postes_raw
	  (list (list seq deriva utm_x utm_y azimute cb_impl cb_exist cb_ret cb_desloc
		(_ENEL_CABO_V linha_impl 49) (_ENEL_CABO_V linha_impl 50) (_ENEL_CABO_V linha_impl 51)
		(if (>= idx_lat 0) (_ENEL_CABO_V linha_ref idx_lat) "")
		(if (>= idx_long 0) (_ENEL_CABO_V linha_ref idx_long) "")))))
	)
      ;; Montar mapa sequencia -> (utm_x utm_y azimute lat long)
      (setq map_coords nil)
      (foreach p lst_postes_raw
	(setq seq (car p) utm_x (nth 2 p) utm_y (nth 3 p) azimute (nth 4 p)
	      lat (nth 12 p) long (nth 13 p))
	(if (and seq (/= seq ""))
	  (setq map_coords (append map_coords (list (list seq utm_x utm_y azimute lat long))))))
      ;; Gerar segmentos
      (setq i 0)
      (foreach p lst_postes_raw
	(setq seq (car p) deriva (cadr p))
	(setq corrx_1 "") (setq corry_1 "") (setq corrx_2 "") (setq corry_2 "")
	(setq azimute_1 "") (setq azimute_2 "")
	;; Coords, azimute, lat, long ponto 1 (sequencia)
	(setq lat "" long "")
	(foreach m map_coords
	  (if (equal (car m) seq)
	    (setq corrx_1 (cadr m) corry_1 (caddr m) azimute_1 (nth 3 m)
		  lat (nth 4 m) long (nth 5 m))))
	;; Coords e azimute ponto 2 (deriva ou proximo)
	(cond
	  ((and deriva (/= deriva ""))
	   (foreach m map_coords
	     (if (equal (car m) deriva)
	       (setq corrx_2 (cadr m) corry_2 (caddr m) azimute_2 (nth 3 m)))))
	  ((< (1+ i) (length lst_postes_raw))
	   (setq seq_next (car (nth (1+ i) lst_postes_raw)))
	   (foreach m map_coords
	     (if (equal (car m) seq_next)
	       (setq corrx_2 (cadr m) corry_2 (caddr m) azimute_2 (nth 3 m))))))
	;; Manter virgula como separador decimal (ja vem do CSV ou como string)
	(if (and corrx_1 (= (vl-string-search "," corrx_1) nil) (vl-string-search "." corrx_1))
	  (setq corrx_1 (vl-string-subst "," "." corrx_1)))
	(if (and corry_1 (= (vl-string-search "," corry_1) nil) (vl-string-search "." corry_1))
	  (setq corry_1 (vl-string-subst "," "." corry_1)))
	(if (and corrx_2 (= (vl-string-search "," corrx_2) nil) (vl-string-search "." corrx_2))
	  (setq corrx_2 (vl-string-subst "," "." corrx_2)))
	(if (and corry_2 (= (vl-string-search "," corry_2) nil) (vl-string-search "." corry_2))
	  (setq corry_2 (vl-string-subst "," "." corry_2)))
	;; deriva: preenchida usa valor; vazia usa sequencia do proximo poste (segundo ponto = N+1)
	(setq deriva_out deriva)
	(if (and (or (not deriva) (= deriva "")) (< (1+ i) (length lst_postes_raw)))
	  (setq deriva_out (car (nth (1+ i) lst_postes_raw))))
	;; seq_posterior, corrx_3, corry_3: ponto posterior so se proximo tem deriva="" ou deriva=seq
	(setq seq_posterior "" corrx_3 "" corry_3 "")
	(if (< (1+ i) (length lst_postes_raw))
	  (progn
	    (setq p_next (nth (1+ i) lst_postes_raw)
		  deriva_next (cadr p_next))
	    (if (or (not deriva_next) (= (vl-princ-to-string deriva_next) "")
		    (equal (vl-princ-to-string deriva_next) (vl-princ-to-string seq)))
	      (progn
		(setq seq_posterior (car p_next))
		(foreach m map_coords
		  (if (equal (car m) seq_posterior)
		    (setq corrx_3 (cadr m) corry_3 (caddr m))))))))
	(if (and corrx_3 (= (vl-string-search "," corrx_3) nil) (vl-string-search "." corrx_3))
	  (setq corrx_3 (vl-string-subst "," "." corrx_3)))
	(if (and corry_3 (= (vl-string-search "," corry_3) nil) (vl-string-search "." corry_3))
	  (setq corry_3 (vl-string-subst "," "." corry_3)))
	;; Montar linha saida: sequencia, deriva, corrx_1, corry_1, corrx_2, corry_2, CB_*_IMPL..., azimute_1, azimute_2, faixa..., seq_posterior, corrx_3, corry_3
	(setq seg (list seq deriva_out corrx_1 corry_1 corrx_2 corry_2))
	(setq cb_impl (nth 5 p) cb_exist (nth 6 p) cb_ret (nth 7 p) cb_desloc (nth 8 p))
	(setq j 0)
	(repeat 15
	  (setq seg (append seg (list (nth j cb_impl))))
	  (setq seg (append seg (list (nth j cb_exist))))
	  (setq seg (append seg (list (nth j cb_ret))))
	  (setq seg (append seg (list (nth j cb_desloc))))
	  (setq j (1+ j)))
	(setq seg (append seg (list azimute_1 azimute_2 (nth 9 p) (nth 10 p) (nth 11 p)
				   seq_posterior corrx_3 corry_3 lat long)))
	(setq lst_cabos (append lst_cabos (list seg)))
	(setq i (1+ i))))
    )
  (list (ENEL_LISTA_CABO) lst_cabos)
)
