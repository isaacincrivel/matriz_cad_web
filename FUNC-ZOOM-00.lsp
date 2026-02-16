;;; <><><><><><><><><><><><><><><><><><><><><>      < FUNCX >         <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>    CONTROLE ZOOM       <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> ESHOP-ZOM_RAI  >>>>>>>ZOOM-RAIO
;;;++ DESCRIÇÃO: ZOOM A PATIR DE UM PONTO COM UM RAIO SOLICITADO
;;;++ ENTRADA: PONTO E PARAMETRO (RAIO)
;;;++ SAIDA: ZOOM
(defun ESHOP-ZOM_RAI (pto1 prr1 / intx inty)
  (setq	intx (nth 0 pto1)
	inty (nth 1 pto1)
  )
  (command "ZOOM"
	   (list (- intx prr1) (- inty prr1))
	   (list (+ intx prr1) (+ inty prr1))
  )
)

;;;<> ESHOP-ZOM_TLA  >>>>>>>ZOOM_TELA
;;;++ DESCRIÇÃO: ZOOM ENTRE VARIOS PONTOS DE UMA LISTA AUMENTANDO A ÁREA EM FUNÇÃO DE PREC
;;;++ ENTRADA: LISTA COM OS PONTOS E A PRECISÃO
;;;++ SAIDA: ZOOM NA TELA
(defun ESHOP-ZOM_TLA (lst1 int1 / lst2 int1 pto1 pto2)
  (setq lst2 (ESHOP-MIN_MAX_LST lst1))
  (setq	pto1 (car lst2)
	pto2 (cadr lst2)
  )
  (command "zoom"
	   (polar pto1 (angle pto2 pto1) int1)
	   (polar pto2 (angle pto1 pto2) int1)
  )
)

;;;<> ESHOP-GRDRAW_LST   
;;;++ DESCRIÇÃO: CRIA GRDRAW TELA A PARTIR DE LISTA DE PONTOS
;;;++ ENTRADA: LST1:LISTA COM OS PONTOS; INT1:COR A UTILIZAR; INT2:TIPO DE DESTAQUE GRDRAW
;;;++ SAIDA: MOSTRA OS DESENHOS NA TELA GRDRAW
(defun ESHOP-GRDRAW_LST	(lst1 int1 int2 / int3 pto1 pto2 pto3)
  (setq int3 0)
  (setq pto1 nil)
  (setq pto1 (nth 0 lst1))
  (repeat (1- (length lst1))
    (setq pto2 (nth int3 lst1)
	  pto3 (nth (1+ int3) lst1)
    )
    (grdraw pto2 pto3 int1 int2)
    (setq int3 (1+ int3))
  )
  (grdraw pto3 pto1 int1 int2)
)
