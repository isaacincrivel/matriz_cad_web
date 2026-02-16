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
	      (if (and (>= (length r) 65) (nth 63 r) (nth 64 r)
		       (/= (cond ((null (nth 63 r)) "") (t (vl-princ-to-string (nth 63 r)))) "")
		       (/= (cond ((null (nth 64 r)) "") (t (vl-princ-to-string (nth 64 r)))) ""))
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
		(_ENEL_V linha_ref 60) (_ENEL_V linha_ref 63) (_ENEL_V linha_ref 64) (_ENEL_V linha_ref 65)
		(_ENEL_V linha_ref 1))))
	;; faixa, cort_arvores_isol, municipio, fuso
	(setq lst_row_out (append lst_row_out
	  (list (_ENEL_V linha_ref 44) (_ENEL_V linha_ref 45) (_ENEL_V linha_ref 61) (_ENEL_V linha_ref 62))))
	;; CB_1A..CB_BT3 (indices 3-17) - usar linha IMPL ou ref
	(setq r (if linha_impl linha_impl linha_ref))
	(setq i 3)
	(repeat 15
	  (setq lst_row_out (append lst_row_out (list (_ENEL_V r i))) i (1+ i)))
	;; adiconal_1..7, qdt_adic_1..7 (indices 46-59)
	(setq r (if linha_ref linha_ref (car rows)))
	(setq i 46)
	(repeat 14
	  (setq lst_row_out (append lst_row_out (list (_ENEL_V r i))) i (1+ i)))
	(setq lst_postes (append lst_postes (list lst_row_out))))))
  (list lst_header lst_postes))

;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_INSERE_POSTES_CAD >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;;<> ENEL_INSERE_POSTES_CAD em ENEL-INSERE-POSTES.lsp

;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_CONVERTE_MATRIZ_NOVA >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_CONVERTE_MATRIZ_NOVA
;;;++ DESCRICAO: Le MATRIZ_NOVA.csv e converte para formato interno (lst2 lst4)
;;;++ ENTRADA: str1 - caminho do arquivo (ex: "C:/MATRIZ/MATRIZ_NOVA.csv")
;;;++ SAIDA: (list lst2 lst4) - lst2=titulo, lst4=dados no formato interno

(defun ENEL_CONVERTE_MATRIZ_NOVA (str1 / arq1 lst2 lst4 lst_row str_line lst_all
				   coord_x coord_y seq status tipo_poste estru
				   nm_poste estai base_ref base_conc aterr chave
				  
				   faixa cort_arv azimute tensa deriva lst_cabos
				   rows linha_ref st suf cod cabo_str idx r)
  (if (not (boundp 'GLB_LST_MODULOS))
    (or (load (findfile "modulos.lsp") nil)
	(load "C:/MATRIZ_DESENVOLVIMENTO/LISP/modulos.lsp" nil)))

 
  
)
;;; <><><><><><><><><><><><><><><><><><><><><>   < ENEL_ASBUILT >    				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_MODULARES     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ENEL_ASBUILT
;;;++ DESCRICAO: Pega a lista de dados que esta no arquivo csv e cria baremos e desenha
;;;++ ENTRADA: Lista de variaveis do modulo
;;;++ SAIDA: Variaveis geradas para uso no sistema


(defun ENEL_ASBUILT (/ lst1 lst2 lst3 x glb_tipo
		     GLB_SENSIVEL
		     GLB_FAIXA
		     GLB_ARVORE
		     GLB_DIRETORIO)




  (prompt "\n ENEL_ASBUILT")
  (setq gbl_erro "\n ENEL_ASBUILT")

  (setq	GLB_LST_POSTE  nil
	GLB_LST_OBJETO nil	
	GLB_LST_CABO nil
	num_errox 0
  )
  
;;;  (if (= (STRCASE gbl_tipo_projeto) "ASBUILT")
;;;    (ENEL_INICIO)
;;;  )

  (ENEL_INICIO)

  ;; Busca os dados do arquivo MATRIZ_NOVA.csv e converte para formato interno
  
  (setq lst1 (ENEL_CONVERT_LIST_POSTE "C:/MATRIZ/MATRIZ_NOVA.csv"))
  (setq lst8 (ENEL_CONVERT_LIST_CABO "C:/MATRIZ/MATRIZ_NOVA.csv"))
  (setq GLB_LST_CABO lst8)

  ;; Insercao de postes (bloco POSTE_FINAL + textos EST_*) - em ENEL-INSERE-POSTES.lsp
  (ENEL_INSERE_POSTES_CAD lst1)

  ;; lst1 = (lst2 lst4) onde lst2 = titulo, lst4 = dados
  (setq lst2 (car lst1))		; TITULO MATRIZ (formato interno)
  (setq lst4 (cadr lst1))		; Matriz sem titulo

  ;; Validacao removida - CSV considerado correto. Inicializa GLB_FAIXA, GLB_ARVORE, GLB_SENSIVEL
  ;; para uso no carimbo ambiental (ENEL_CARIMBO / NOTA_AMBIENTAL)
  (setq GLB_FAIXA 0 GLB_ARVORE 0 GLB_SENSIVEL "")
  (foreach row lst4
    (setq GLB_FAIXA (+ GLB_FAIXA (atoi (if (nth 79 row) (nth 79 row) "0"))))
    (setq GLB_ARVORE (+ GLB_ARVORE (atoi (if (nth 80 row) (nth 80 row) "0")))))

  (setq str1 (substr (rtos (getvar "cdate") 2 5) 1 14))
  (setq	GLB_DATA (strcat (substr str1 7 2)
			 "-"
			 (substr str1 5 2)
			 "-"
			 (substr str1 1 4)
			 
		 )
  )

  (setq	GLB_HORA (strcat (substr str1 10 2)
			 "-"
			 (substr str1 12 2)
			
			 
		 )
  )
  

  (GERAR_DADOS_PROJ+ lst2 lst4)

  (CRIA_PROJETO_CAD lst2 lst4)

  ;; KML removido - aplicacao somente para gerar CAD
  ;; (GERAR_KML_PRINCIPAL)
  ;;  (ALERT
  ;;    "ORDENAR MANUALMENTE: \n
  ;; DERIVACOES \n
  ;; 01 - CON001 (FASE)  \n
  ;; 01 - CON097 (FASE) \n
  ;; 01 - CON048 (NEUTRO) \n
  ;; \n"
  ;;  )


  (ENEL_FIM)
)