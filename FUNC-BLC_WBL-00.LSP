;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>    BLOCOS, WBLOCOS     <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ESHOP-INS_BLC
;;;++ DESCRIÇÃO: ROTINA PARA INSERIR BLOCOS
;;;++ ENTRADA: str1:NOME BLOCO <> pto1:PONTO <> ang1:ANGULO (SE COLOCAR "pause" ESCOLHE MANUAL <> str2:LAYER
;;;++ SAIDA: BLOCO INSERIDO
(defun ESHOP-INS_BLC (str1 pto1 ang1 str2 /)
  (setvar "osmode" 0)
  (ESHOP_LAYER str2)
  (if (/= ang1 "pause")
    (command "-insert"
	     str1
	     "_non"
	     pto1
	     "1"
	     "1"
	     (angtos ang1)
	     ""
    )
    (command "-insert" str1 "_non" pto1 "1" "1" pause)
  )
  (entlast)
)