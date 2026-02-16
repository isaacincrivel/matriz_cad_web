;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>       LAYER            <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ESHOP-CRR_LAY  
;;;++ DESCRI��O: COMANDO PADR�O DE CRIAR LAYER
;;;++ ENTRADA: str1:nome layer, str2:cor; str3:expessura; str4: lipo linha
;;;++ SAIDA: lista com dia mes ano e uma string no formato ( # 17112016 - 1454 )
(defun ESHOP-CRR_LAY (str1 str2 str3 str4 /)
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