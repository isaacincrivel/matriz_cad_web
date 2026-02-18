;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_CNV_STR_LST >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; Arquivo: ENEL-CRIAR-LISTA-POSTE.lsp
;;;<> ENEL_CNV_STR_LST
;;;++ DESCRICAO: Converte string CSV (delimitador ;) em lista de strings
;;;++ ENTRADA: str1 - texto "A;B;C;D"
;;;++ SAIDA: ("A" "B" "C" "D")
(defun ENEL_CNV_STR_LST (str1 / int1 int2 str2 crt1 lst1)
  (setq int1 (strlen str1) int2 1 str2 "" lst1 nil)
  (while (<= int2 int1)
    (setq crt1 (substr str1 int2 1))
    (if (= crt1 ";")
      (setq lst1 (cons str2 lst1) str2 "")
      (progn (setq str2 (strcat str2 crt1))
	     (if (= int2 int1) (setq lst1 (cons str2 lst1)))))
    (setq int2 (1+ int2)))
  (reverse lst1)
)



;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_CONVERT_LIST_POSTE >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;;<> ENEL_CONVERT_LIST_POSTE
;;;++ DESCRICAO: Transforma MATRIZ_NOVA (4 linhas/poste) em lista consolidada (1 linha/poste)
;;;++ ENTRADA: str1 - caminho do CSV (ex: "C:/MATRIZ/MATRIZ_NOVA.csv")
;;;++ SAIDA: (list lst_header lst_postes) - lst_header=titulos, lst_postes=lista completa de postes
;;;++ Usa ENEL_CNV_STR_LST de ENEL-CRIAR-LISTA-POSTE.lsp
(defun _ENEL_V (row idx)
  (cond ((null row) "") ((null (nth idx row)) "")
	((= (type (nth idx row)) 'STR) (nth idx row))
	(t (vl-princ-to-string (nth idx row)))))

(defun ENEL_CONVERT_LIST_POSTE (str1 / arq1 str_line lst_all lst_row rows r
				linha_impl linha_exist linha_ret linha_desloc linha_ref
				seq poste_impl poste_exist poste_ret poste_desloc poste_final
				lst_header lst_postes lst_row_out
				est_names est_idx suf sufixos val idx i)
  
  (setq lst_postes nil lst_all nil
	est_names '("EST_1A" "EST_1B" "EST_2A" "EST_2B" "EST_3A" "EST_3B" "EST_4A" "EST_4B"
		    "EST_5A" "EST_5B" "EST_6A" "EST_6B" "EST_BT1" "EST_BT2" "EST_BT3")
	est_idx '(22 23 24 25 26 27 28 29 30 31 32 33 34 35 36)
	sufixos '("_IMPL" "_EXIST" "_RET" "_DESLOC"))
  ;; Header = formato definido em ENEL_LISTA_POSTE
  (setq lst_header (ENEL_LISTA_POSTE))
  
  ;; Ler CSV (parser AutoLISP puro)
  
  (setq arq1 (open str1 "r"))
  (if arq1
    (progn
      (read-line arq1)
      (while (setq str_line (read-line arq1))
	(setq lst_row (ENEL_CNV_STR_LST str_line))
	(if (>= (length lst_row) 20)
	  (setq lst_all (append lst_all (list lst_row)))))
      (close arq1)
      ;; Agrupar e processar (1 a 4 linhas por poste; se sobrar, processa com padding)
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
	      (if (and (>= (length r) 66) (nth 64 r) (nth 65 r)
		       (/= (cond ((null (nth 64 r)) "") (t (vl-princ-to-string (nth 64 r)))) "")
		       (/= (cond ((null (nth 65 r)) "") (t (vl-princ-to-string (nth 65 r)))) ""))
		(setq linha_ref r)))))
	(if (not linha_ref) (setq linha_ref (car rows)))
	;; sequencia
	(setq seq (_ENEL_V (car rows) 0))
	
	;; POSTE_* = tipo_poste (indice 21); adicionar P se comeca com DT
	(setq poste_impl (_ENEL_V linha_impl 21) poste_exist (_ENEL_V linha_exist 21)
	      poste_ret (_ENEL_V linha_ret 21) poste_desloc (_ENEL_V linha_desloc 21))
	(if (and poste_impl (/= poste_impl "") (>= (strlen poste_impl) 2) (= (strcase (substr poste_impl 1 2)) "DT"))
	  (setq poste_impl (strcat "P" poste_impl)))
	(if (and poste_exist (/= poste_exist "") (>= (strlen poste_exist) 2) (= (strcase (substr poste_exist 1 2)) "DT"))
	  (setq poste_exist (strcat "P" poste_exist)))
	(if (and poste_ret (/= poste_ret "") (>= (strlen poste_ret) 2) (= (strcase (substr poste_ret 1 2)) "DT"))
	  (setq poste_ret (strcat "P" poste_ret)))
	(if (and poste_desloc (/= poste_desloc "") (>= (strlen poste_desloc) 2) (= (strcase (substr poste_desloc 1 2)) "DT"))
	  (setq poste_desloc (strcat "P" poste_desloc)))
	
	(setq poste_final
	  (cond ((and poste_impl (/= poste_impl "") poste_ret (/= poste_ret "")) "PDT_RET_IMPL")
		((and poste_impl (/= poste_impl "")) "PDT_IMPL")
		((and poste_ret (/= poste_ret "")) "PDT_RET")
		((and poste_exist (/= poste_exist "")) "PDT_EXIST")
		((and poste_desloc (/= poste_desloc "")) "PDT_DESLOC")
		(t "")))
	;; Lista saida: seq, 5x POSTE
	(setq lst_row_out (list seq poste_impl poste_exist poste_ret poste_desloc poste_final))
	;; 60 colunas EST_*_IMPL/EXIST/RET/DESLOC
	(foreach idx est_idx
	  (foreach suf sufixos
	    (setq r (cond ((= suf "_IMPL") linha_impl) ((= suf "_EXIST") linha_exist)
			  ((= suf "_RET") linha_ret) ((= suf "_DESLOC") linha_desloc)))
	    (setq lst_row_out (append lst_row_out (list (if r (_ENEL_V r idx) ""))))))
	;; num_poste, estai_ancora, base_reforcada, base_concreto, aterr_neutro, chave, trafo, equipamento
	;; rotacao_poste, utm_x, utm_y, azimute, deriva
	(setq lst_row_out (append lst_row_out
	  (list (_ENEL_V linha_ref 20) (_ENEL_V linha_ref 37) (_ENEL_V linha_ref 38) (_ENEL_V linha_ref 39)
		(_ENEL_V linha_ref 40) (_ENEL_V linha_ref 41) (_ENEL_V linha_ref 42) (_ENEL_V linha_ref 43)
		(_ENEL_V linha_ref 61) (_ENEL_V linha_ref 64) (_ENEL_V linha_ref 65) (_ENEL_V linha_ref 66)
		(_ENEL_V linha_ref 1))))
	;; faixa, cort_arvores_isol, cerca, municipio, fuso
	(setq lst_row_out (append lst_row_out
	  (list (_ENEL_V linha_ref 44) (_ENEL_V linha_ref 45) (_ENEL_V linha_ref 46) (_ENEL_V linha_ref 62) (_ENEL_V linha_ref 63))))
	;; CB_1A..CB_BT3 (indices 3-17) - usar linha IMPL ou ref
	(setq r (if linha_impl linha_impl linha_ref))
	(setq i 3)
	(repeat 15
	  (setq lst_row_out (append lst_row_out (list (_ENEL_V r i))) i (1+ i)))
	;; adiconal_1..7, qdt_adic_1..7 (indices 47-60)
	(setq r (if linha_ref linha_ref (car rows)))
	(setq i 47)
	(repeat 14
	  (setq lst_row_out (append lst_row_out (list (_ENEL_V r i))) i (1+ i)))
	(setq lst_postes (append lst_postes (list lst_row_out))))))
  (list lst_header lst_postes))
