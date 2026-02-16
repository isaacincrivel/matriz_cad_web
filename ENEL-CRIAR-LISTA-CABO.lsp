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

;;;++ Cabeçalhos: sequencia, deriva, corrx_1, corry_1, corrx_2, corry_2, CB_1A_IMPL..CB_BT3_DESLOC
(defun ENEL_LISTA_CABO (/ cb_names sufixos lst_header c s)
  (setq cb_names '("CB_1A" "CB_1B" "CB_2A" "CB_2B" "CB_3A" "CB_3B" "CB_4A" "CB_4B"
		   "CB_5A" "CB_5B" "CB_6A" "CB_6B" "CB_BT1" "CB_BT2" "CB_BT3")
	sufixos '("_IMPL" "_EXIST" "_RET" "_DESLOC")
	lst_header (list "sequencia" "deriva" "corrx_1" "corry_1" "corrx_2" "corry_2"))
  (foreach c cb_names
    (foreach s sufixos
      (setq lst_header (append lst_header (list (strcat c s))))))
  lst_header
)

(defun ENEL_CONVERT_LIST_CABO (str1 / arq1 str_line lst_all lst_row rows r
				linha_impl linha_exist linha_ret linha_desloc linha_ref
				lst_header lst_cabos lst_postes_raw
				seq deriva utm_x utm_y cb_impl cb_exist cb_ret cb_desloc
				map_coords seq_next i j seg
				corrx_1 corry_1 corrx_2 corry_2 deriva_out val)
  
  (setq lst_cabos nil lst_all nil lst_postes_raw nil)
  ;; Ler CSV
  (setq arq1 (open str1 "r"))
  (if arq1
    (progn
      (read-line arq1)
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
	      (if (and (>= (length r) 65) (nth 63 r) (nth 64 r)
		       (/= (cond ((null (nth 63 r)) "") (t (vl-princ-to-string (nth 63 r)))) "")
		       (/= (cond ((null (nth 64 r)) "") (t (vl-princ-to-string (nth 64 r)))) ""))
		(setq linha_ref r)))))
	(if (not linha_ref) (setq linha_ref (car rows)))
	(setq seq (_ENEL_CABO_V (car rows) 0))
	(setq deriva (_ENEL_CABO_V (car rows) 1))
	(setq utm_x (_ENEL_CABO_V linha_ref 63))
	(setq utm_y (_ENEL_CABO_V linha_ref 64))
	;; CB por status (indices 3-17)
	(setq cb_impl nil cb_exist nil cb_ret nil cb_desloc nil)
	(setq i 3)
	(repeat 15
	  (setq cb_impl (append cb_impl (list (_ENEL_CABO_V linha_impl i))))
	  (setq cb_exist (append cb_exist (list (_ENEL_CABO_V linha_exist i))))
	  (setq cb_ret (append cb_ret (list (_ENEL_CABO_V linha_ret i))))
	  (setq cb_desloc (append cb_desloc (list (_ENEL_CABO_V linha_desloc i))))
	  (setq i (1+ i)))
	(setq lst_postes_raw (append lst_postes_raw
	  (list (list seq deriva utm_x utm_y cb_impl cb_exist cb_ret cb_desloc))))
	)
      ;; Montar mapa sequencia -> (utm_x utm_y) e lista ordenada de sequencias
      (setq map_coords nil)
      (foreach p lst_postes_raw
	(setq seq (car p) utm_x (nth 2 p) utm_y (nth 3 p))
	(if (and seq (/= seq ""))
	  (setq map_coords (append map_coords (list (list seq utm_x utm_y))))))
      ;; Gerar segmentos
      (setq i 0)
      (foreach p lst_postes_raw
	(setq seq (car p) deriva (cadr p))
	(setq corrx_1 "") (setq corry_1 "") (setq corrx_2 "") (setq corry_2 "")
	;; Coords ponto 1 (sequencia)
	(foreach m map_coords
	  (if (equal (car m) seq)
	    (setq corrx_1 (cadr m) corry_1 (caddr m))))
	;; Coords ponto 2 (deriva ou proximo)
	(cond
	  ((and deriva (/= deriva ""))
	   (foreach m map_coords
	     (if (equal (car m) deriva)
	       (setq corrx_2 (cadr m) corry_2 (caddr m)))))
	  ((< (1+ i) (length lst_postes_raw))
	   (setq seq_next (car (nth (1+ i) lst_postes_raw)))
	   (foreach m map_coords
	     (if (equal (car m) seq_next)
	       (setq corrx_2 (cadr m) corry_2 (caddr m))))))
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
	;; Montar linha saida: sequencia, deriva, corrx_1, corry_1, corrx_2, corry_2, CB_*_IMPL...
	(setq seg (list seq deriva_out corrx_1 corry_1 corrx_2 corry_2))
	(setq cb_impl (nth 4 p) cb_exist (nth 5 p) cb_ret (nth 6 p) cb_desloc (nth 7 p))
	(setq j 0)
	(repeat 15
	  (setq seg (append seg (list (nth j cb_impl))))
	  (setq seg (append seg (list (nth j cb_exist))))
	  (setq seg (append seg (list (nth j cb_ret))))
	  (setq seg (append seg (list (nth j cb_desloc))))
	  (setq j (1+ j)))
	(setq lst_cabos (append lst_cabos (list seg)))
	(setq i (1+ i))))
    )
  (list (ENEL_LISTA_CABO) lst_cabos)
)
