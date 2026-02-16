
;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><> NUMEROS, DATAS, TEMPO  <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


;;;<> ESHOP-ALR
;;;++ DESCRIÇÃO: RETORNA NUMERO ALEATORIO
;;;++ ENTRADA: int1:numero aleatorio entre 0 e int1
;;;++ SAIDA: NUMERO ALEATORIO
(defun ESHOP-ALR (/ int1 int2 int3 int4)
  (if (not seed)
    (setq seed (getvar "DATE"))
  )
  (setq	int1 65536
	int2 25173
	int3 13849
	seed (rem (+ (* int2 seed) int3) int1)
	int4 (/ seed int1)
  )
  int4
)

;;;<> ESHOP-DATA  
;;;++ DESCRIÇÃO: RETORNA DATA ATUAL - DIA MES ANO HORA 
;;;++ ENTRADA: sem entrada
;;;++ SAIDA: lista com dia mes ano e uma string no formato ( # 17112016 - 1454 )
(defun ESHOP-DATA (/ str1 str2 str3 str4 str5)
  (setq	str1 (substr (rtos (getvar "cdate") 2 5) 1 13)
	str2 (substr str1 1 4)
	str3 (substr str1 5 2)
	str4 (substr str1 7 2)
	str5 (substr str1 10 4)
  )
  (list	str4
	str3
	str2
	str5
	(STRCAT " # " str4 str3 str2 "-" str5)
  )
)

;;;;<> ESHOP-ORD_INT
;;;;++ DESCRIÇÃO: ORDENA LISTA DE NUMEROS INTEIROS
;;;;++ ENTRADA:  lst1:LISTA COM NUMEROS INTEIROS
;;;;++ SAIDA: LISTA ORDENADA
(defun ESHOP-ORD_INT (lst / sortedlist)
  (while lst
    (setq sortedList (cons (apply 'max lst) sortedList))
    (setq lst (vl-remove (car sortedList) lst))
  )
  sortedList
)

;;;<> ELTRZ-MC-NUM-VAL
;;;++ DESCRIÇÃO: RETORNA NUMERO VALIDO, SE NÃO EXISTIR DEFINE VALOR PADRÃO
;;;++ ENTRADA: str1:variavel (numero texto) a ser verificada var1:valor padrão caso não exista
;;;++ SAIDA: STRING DO NUMERO NO FORMADO "2.5"
(defun ELTRZ-MC-NUM-VAL	(str1 var1 /)
  (if (or (= str1 NIL) (= str1 ""))
    (progn
      (setq str1 var1)
      (setq str1 (VL-STRING-SUBST "." "," str1))
    )
  )
  (if (/= str1 nil)
    (setq str1 (VL-STRING-SUBST "." "," str1))
  )
  str1
)



;;;<> TAN
;;;++ DESCRIÇÃO: TANGENTE DO ANGULO
;;;++ ENTRADA: ANG1:ANGULO RAD
;;;++ SAIDA: LISTA COM DAD
(defun TAN (ang1 / )
  (/ (sin ang1) (cos ang1))
)


