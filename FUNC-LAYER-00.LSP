;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>       LAYER            <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ESHOP-CRR_LAY  
;;;++ DESCRICAO: COMANDO PADRAO DE CRIAR LAYER
;;;++ ENTRADA: str1:nome layer, str2:cor; str3:expessura; str4: tipo linha
;;;++ Carrega automaticamente tipo de linha se nao estiver no desenho
(defun ESHOP-CRR_LAY (str1 str2 str3 str4 / arq_lin)

  
;;;  ;; Carregar tipo de linha se nao for continuous/BYLAYER/BYBLOCK e nao existir
;;;  (if (and str4 (/= str4 "") (/= (strcase str4) "CONTINUOUS")
;;;	   (/= (strcase str4) "BYLAYER") (/= (strcase str4) "BYBLOCK")
;;;	   (not (tblsearch "LTYPE" str4)))
;;;    (progn
;;;      (setq arq_lin (if (= (getvar "MEASUREMENT") 1) "acadiso.lin" "acad.lin")
;;;	    arq_lin (or (findfile arq_lin) arq_lin))
;;;      (vl-cmdf "_.-LINETYPE" "_load" str4 arq_lin)))


  
  (if (= (tblsearch "layer" str1) nil)
    (progn
      (command "_.layer" "_make"   str1	     "_color"  str2
	       ""	 "_lweight"	     str3      ""
	       "_ltype"	 str4	   ""	     ""
	      )
      (setvar "clayer" str1)
    )
    (setvar "clayer" str1)
  )
)