
;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><> MANIPULAÇÃO DE PONTOS  <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


;;;<> ESHOP-EXC_DUP >>>> PONTOS_DUPLICADOS
;;;++ DESCRIÇÃO: EXCLUI PONTOS DUPLICADOS DE UMA LISTA
;;;++ ENTRADA: LST1:LISTA
;;;++ SAIDA: LISTA SEM DUPLICADOS
(defun ESHOP-EXC_DUP (lst1 / lst2)
  (while lst1
    (setq lst2 (cons (nth 0 lst1) lst2)
	  lst1 (vl-remove (nth 0 lst1) lst1)
    )
  )
  (reverse lst2)
)

;;;<> ESHOP-MIN_MAX_LST   >>>>>>>>> MIN_MAX_LISTA
;;;++ DESCRIÇÃO: RETORNA PONTO MINIMO E PONTO MAXIMO DE UMA LISTA DE PONTOS
;;;++ ENTRADA: LST:LISTA DE PONTOS
;;;++ SAIDA: LISTA COM DOIS PONTOS (MAX E MIM)
(defun ESHOP-MIN_MAX_LST (lst1 / pto1 pto2)
  (setq	pto1 (car lst1)
	pto2 pto1
  )
  (foreach x lst1
    (setq pto1 (mapcar 'min pto1 x)
	  pto2 (mapcar 'max pto2 x)
    )
  )
  (list pto1 pto2)
)

;;;<> ESHOP-CRR_CIR_FRC   
;;;++ DESCRIÇÃO: CRIA UM CIRCULO DEFININDO O RAIO E AS FRAÇÕES (DIVISÕES, LINHAS)
;;;++ ENTRADA: INT1:RAIO DO CIRCULO; INT2:QDADE DE FRAÇÕES; PTO:PONTO INICIAL
;;;++ SAIDA: LISTA COM OS PONTOS
(defun ESHOP-CRR_CIR_FRC (int1 int2 pto1 / ang1 ang2 lst1)
  (setq	ang1 0 )
  (setq ang2 (/ (* 2 pi) int2))
  (repeat int2
    (setq lst1 (append lst1 (list (polar pto1 ang1 int1))))
    (setq ang1 (+ ang1 ang2))
  )
  lst1
)