

;;;<> EEE
;;;++ DESCRIÇÃO: RETORNA DADOS NO PROMPT DO ELEMENTO INCLUSIVE XDATAS
;;;++ ENTRADA: ELEMENTO SELECIONADO
;;;++ SAIDA: DADOS NA TELA APOIO PROGRAMAÇÃO
(DEFUN C:EEE ()
  (ENTGET (CAR (ENTSEL)) '("*"))
)

(defun ESHOP-ATTDEF_TXT (SS / olderr a2t_var a2t_rst st tc ss en ed i)
  (SETQ TC 2) ;; BUSCA O TAG

  
;;;  (while (not ss)
;;;         (setq ss (ssget '((0 . "ATTDEF")))))

  (setq i (sslength ss))
					;(princ (strcat "\nChanging " (rtos i 2 0) " ATTDEFs to TEXT\n"))

  (while (not (minusp (setq i (1- i))))
    (princ (strcat "\r" (rtos i 2 0) "         "))
    (setq en (ssname ss i)
	  ed (entget en)
    )
    (entdel en)
    (entmake (list (cons 0 "TEXT")
		   (cons 1 (cdr (assoc tc ed)))
		   (assoc 7 ed)
		   (assoc 8 ed)
		   (assoc 10 ed)
		   (assoc 11 ed)
		   (if (assoc 39 ed)
		     (assoc 39 ed)
		     (cons 39 0.0)
		   )
		   (assoc 40 ed)
		   (assoc 41 ed)
		   (assoc 50 ed)
		   (assoc 51 ed)
		   (if (assoc 62 ed)
		     (assoc 62 ed)
		     (cons 62 256)
		   )
		   (assoc 71 ed)
		   (assoc 72 ed)
		   (cons 73 (cdr (assoc 74 ed)))
		   (assoc 210 ed)
	     )
    )
  )
  ;(a2t_rmd)
)


(defun cria_script (lst / x arq1)
  (SETQ ARQ (strcat caminho-tabela "\\script.scr"))
  (setq arq1 (open (strcat caminho-tabela "\\script.scr") "w"))
  (foreach x lst
    (princ x arq1)
  )
  (close arq1)
  (command "script" arq)
)



  (DEFUN C:PURGAR ()
   (COMMAND "PURGE" "A" "*" "N")
   (Princ)
 )



(DEFUN PT_TXT (PT / )
(STRCAT (RTOS (CAR PT) 2 2) "," (RTOS (CADR PT) 2 2))
  )




(defun tempini (/)  
  (if (/= glb_tmp "sim")
    (setq glb_tmp (getvar "cdate"))    
  )
)


(defun tempfin (/ int1)
  (if (/= glb_tmp "sim")
    (progn
  (setq int1 (* 1000000 (- (getvar "cdate") glb_tmp)))
  (princ (strcat "Tempo" " " (rtos int1 2 10)))
  (setq glb_tmp "sim")))
)