;;; LOAD_TODOS.lsp - Carrega arquivos LISP um a um para identificar qual causa "malformed list"
;;; Execute: (load "C:/MATRIZ_DESENVOLVIMENTO/LISP/LOAD_TODOS.lsp")
(defun C:LOAD_TODOS (/ lst ordem f)
  (setq lst (list
    "ADEQUAR-ESHOP-21.lsp"
    "ENEL-ABACO-02.lsp"
    "ENEL-APOIO-02.lsp"
    "ENEL-CRIAR-LISTA-POSTE.lsp"
    "ENEL-CRIAR-LISTA-CABO.lsp"
    "ENEL-INSERE-POSTES.lsp"
    "ENEL-INSERE-CABOS-CAD.lsp"
    "ENEL-COLOCA-TEXTO-POSTE.lsp"
    "ENEL-COLOCA-TEXTO-CABO.lsp"
    "ENEL-INSERE-EVENTUAIS.lsp"
    "ENEL-ASBUILT-01.lsp"
    "ENEL-CARIMBO-01.LSP"
    "ENEL-COMPR-REV01.lsp"
    "ENEL-CONVERTE-MATRIZ.lsp"
    "ENEL-DADOS PROJ-08.lsp"
    "ENEL-DADOS PROJ-11.lsp"
    "ENEL-MATRIZ-01.lsp"
    "ENEL-MODULARES-01.lsp"
    "ENEL-SISTEMA-01.lsp"
    "ENEL-VALIDACAO-02.lsp"
    "ESHOP-SISTEMA-00.lsp"
    "FUNC-BLC_WBL-00.LSP"
    "FUNC-CSV_TXT-REV00.lsp"
    "FUNC-EX1-00.lsp"
    "FUNC-LAYER-00.LSP"
    "FUNC-LISTAS-00.lsp"
    "FUNC-MAT_DAT-00.lsp"
    "FUNC-PLINE_LINE-00.lsp"
    "FUNC-PONTOS-00.lsp"
    "FUNC-SELEC-01.lsp"
    "FUNC-XDAT_DDOS_ELEM-01.lsp"
    "FUNC-ZOOM-00.lsp"
    "modulos.lsp"))
  (setq ordem 0)
  (foreach f lst
    (setq ordem (1+ ordem))
    (if (findfile (strcat "C:/MATRIZ_DESENVOLVIMENTO/LISP/" f))
      (progn
	(princ (strcat "\n[" (itoa ordem) "] Carregando " f "... "))
	(if (vl-catch-all-error-p
	      (vl-catch-all-apply 'load (list (strcat "C:/MATRIZ_DESENVOLVIMENTO/LISP/" f) nil)))
	  (progn
	    (alert (strcat "ERRO ao carregar: " f "\n\nEste e o arquivo com problema."))
	    (exit))
	  (princ "OK"))))
      (princ (strcat "\n[" (itoa ordem) "] NAO ENCONTRADO: " f))))
  (princ "\nTodos carregados com sucesso.")
  (princ))
