;;; ENEL_CONVERTE_MATRIZ - Fun??o auxiliar de agrupamento e convers?o
;;; Agrupa linhas por sequencia (4 linhas por poste) e monta lst_cabos

(defun ENEL_AGRUPAR_POR_SEQ (lst_all / lst_seq group seq prev)
  (setq lst_seq nil group nil prev nil)
  (foreach row lst_all
    (setq seq (nth 0 row))
    (if (or (null prev) (= prev seq))
      (setq group (append group (list row)))
      (progn
	(setq lst_seq (append lst_seq (list (list prev group)))
	      group (list row))))
    (setq prev seq))
  (if group
    (setq lst_seq (append lst_seq (list (list prev group)))))
  lst_seq)
