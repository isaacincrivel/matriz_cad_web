;;; <><><><><><><><><><><><><><><><><><><><><>   < TRANSF_LST_VARIAVEL >    			<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_MODULARES     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> TRANSF_LST_VARIAVEL
;;;++ DESCRIÇÃO: TRANFORMA LISTA DE MODULAR EM VARIAVEIS GLOBAIS PARA USO EM TODO O SISTEMA
;;;++ ENTRADA: Lista de variaveis do modulo
;;;++ SAIDA: Variaveis geradas para uso no sistema

(DEFUN TRANSF_LST_VARIAVEL (lst5 / int1)  (setq int1 (length lst4))
  (prompt "\n TRANSF_LST_VARIAVEL")
  (setq gbl_erro "\n TRANSF_LST_VARIAVEL")

  
  (setq	gbl_mdl_cabo
	 (nth 0 lst5)
	gbl_mdl_tabposte
	 (nth 1 lst5)
	gbl_mdl_vaomaximo
	 (nth 2 lst5)
	gbl_mdl_tiptrafo
	 (nth 3 lst5)
	gbl_mdl_telefone
	 (nth 4 lst5)
	gbl_mdl_padmedicao
	 (nth 5 lst5)
	gbl_mdl_ssligacao
	 (nth 6 lst5)
	gbl_mdl_numprojeto
	 (nth 7 lst5)
	gbl_mdl_postintercalado
	 (nth 8 lst5)
	gbl_mdl_vaofrouxo
	 (nth 9 lst5)
	gbl_mdl_plpt
	 (nth 10 lst5)
	gbl_mdl_carga
	 (nth 11 lst5)
	gbl_mdl_tramo
	 (nth 12 lst5)
	gbl_mdl_cadunico
	 (nth 13 lst5)
	gbl_mdl_municipio
	 (nth 14 lst5)
	gbl_mdl_parcprojeto
	 (nth 15 lst5)
	gbl_mdl_parcconstrucao
	 (nth 16 lst5)
	gbl_mdl_cliente
	 (nth 17 lst5)
	gbl_mdl_mosaicogeral
	 (nth 18 lst5)
	gbl_mdl_qtdfases
	 (nth 19 lst5)
	gbl_mdl_imglocal-chk
	 (nth 20 lst5)
	gbl_mdl_qrcod-chk
	 (nth 21 lst5)
	gbl_mdl_segurança
	 (nth 22 lst5)
	gbl_mdl_carte_arvores
	 (nth 23 lst5)
	gbl_mdl_limpeza_faixa
	 (nth 24 lst5)
	gbl_mdl_area_ambiental
	 (nth 25 lst5)
	gbl_mdl_cerca
	 (nth 26 lst5)
	gbl_mdl_tipopi
	 (nth 27 lst5)

  )
)


;;; <><><><><><><><><><><><><><><><><><><><><>   < MODULAR_EQT >    				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   ENEL_MODULARES     				<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

;;;<> MODULAR_EQT
;;;++ DESCRIÇÃO: LISTA DE TODOS OS MODULARES A SEREM UTILIZADOS NO SISTEMA
;;;++ ENTRADA: 
;;;++ SAIDA: 

(DEFUN MODULAR_EQT ( gbl_entrada /)
  
  (setq GLB_LST_EST_ENCAB (list "UP4" "N4" "U3" "N3" "TE4" "HTE" "P4" "TE"))
  
  (prompt "\n MODULAR_EQT")

;; ZERANDO TODAS AS VARIAVEIS
(setq gbl_mdl_cabo
       nil
      gbl_mdl_tabposte
       nil
      gbl_mdl_vaomaximo
       nil
      gbl_mdl_tiptrafo
       nil
      gbl_mdl_telefone
       nil
      gbl_mdl_padmedicao
       nil
      gbl_mdl_ssligacao
       nil
      gbl_mdl_numprojeto
       nil
      gbl_mdl_postintercalado
       nil
      gbl_mdl_vaofrouxo
       nil
      gbl_mdl_plpt
       nil
      gbl_mdl_carga
       nil
      gbl_mdl_tramo
       nil
      gbl_mdl_cadunico
       nil
      gbl_mdl_municipio
       nil
      gbl_mdl_parcprojeto
       nil
      gbl_mdl_parcconstrucao
       nil
      gbl_mdl_cliente
       nil
      gbl_mdl_mosaicogeral
       nil
      gbl_mdl_qtdfases
       nil
      gbl_mdl_kml-chk
       nil
      gbl_mdl_imglocal-chk
       nil
      gbl_mdl_qrcod-chk
       nil
      gbl_mdl_segurança
       nil
      gbl_mdl_carte_arvores
       nil
      gbl_mdl_limpeza_faixa
       nil
      gbl_mdl_area_ambiental nil
      gbl_mdl_cerca nil
      	gbl_mdl_tipopi
	 nil
)

  ; MONOFASICO AGRICULTURA 1#4CAA
  (if (= gbl_entrada "MT7")
    (setq
      gbl_mdl_cabo
       "1#1/0CAA"
      gbl_mdl_tabposte
       "tabela1"	
      gbl_mdl_vaomaximo
       90
      gbl_mdl_tiptrafo
       "NÃO"
      gbl_mdl_telefone
       "SIM"
      gbl_mdl_padmedicao
       "NÃO"
      gbl_mdl_ssligacao
       "SIM"
      gbl_mdl_numprojeto
       "SIM"
      gbl_mdl_postintercalado
       "SIM"
      gbl_mdl_vaofrouxo
       "SIM"
      gbl_mdl_plpt
       "NÃO"
      gbl_mdl_carga
       "NÃO"
      gbl_mdl_tramo
       550
      gbl_mdl_cadunico
       "SIM"
      gbl_mdl_municipio
       "SIM"
      gbl_mdl_parcprojeto
       "SIM"
      gbl_mdl_parcconstrucao
       "NÃO"
      gbl_mdl_cliente
       "SIM"
      gbl_mdl_mosaicogeral
       "MOSAICOMT7"
      gbl_mdl_qtdfases
       1
    )
  )
  
  ;; MT8 MONOFASICO 1/0 PECUARIA
(if (= gbl_entrada "MT8")
  (setq
    gbl_mdl_cabo
     "1#1/0CAA"
    gbl_mdl_tabposte
     "tabela1"
    gbl_mdl_vaomaximo
     90
    gbl_mdl_tiptrafo
     "SIM"
    gbl_mdl_telefone
     "SIM"
    gbl_mdl_padmedicao
     "NÃO"
    gbl_mdl_ssligacao
     "SIM"
    gbl_mdl_numprojeto
     "SIM"
    gbl_mdl_postintercalado
     "SIM"
    gbl_mdl_vaofrouxo
     "SIM"
    gbl_mdl_plpt
     "SIM"
    gbl_mdl_carga
     "SIM"
    gbl_mdl_tramo
     800
    gbl_mdl_cadunico
     "NÃO"
    gbl_mdl_municipio
     "SIM"
    gbl_mdl_parcprojeto
     "SIM"
    gbl_mdl_parcconstrucao
     "SIM"
    gbl_mdl_cliente
     "SIM"
    gbl_mdl_mosaicogeral
     "MOSAICO4"
    gbl_mdl_qtdfases
     1
  )
)

  (if (= gbl_entrada "MT9")
  (setq
    gbl_mdl_cabo
     "3#1/0CAA"
    gbl_mdl_tabposte
     "tabela1"
    gbl_mdl_vaomaximo
     80
;;;   gbl_mdl_telefone
;;;     "SIM"
;;;     gbl_mdl_ssligacao
;;;     "SIM"
    gbl_mdl_numprojeto
     "SIM"
    gbl_mdl_postintercalado
     "SIM"
    gbl_mdl_vaofrouxo
     "SIM"
    gbl_mdl_tramo
     500
;;;    gbl_mdl_municipio
;;;     "SIM"
;;;    gbl_mdl_parcprojeto
;;;     "SIM"
;;;    gbl_mdl_parcconstrucao
;;;     "SIM"
;;;    gbl_mdl_cliente
;;;     "SIM"
    gbl_mdl_mosaicogeral
     "MOSAICO5"
    gbl_mdl_qtdfases
     3
  )
)



   ; MT10 - TRIFASICO 1/0
  (if (= gbl_entrada "MT10")
    (setq
      gbl_mdl_cabo
       "3#1/0CAA"
      gbl_mdl_tabposte
       "tabela1"
      gbl_mdl_vaomaximo
       90
      gbl_mdl_tiptrafo
       "SIM"
      gbl_mdl_telefone
       "SIM"
      gbl_mdl_padmedicao
       "NÃO"
      gbl_mdl_ssligacao
       "SIM"
      gbl_mdl_numprojeto
       "SIM"
      gbl_mdl_postintercalado
       "SIM"
      gbl_mdl_vaofrouxo
       "SIM"
      gbl_mdl_plpt
       "SIM"
      gbl_mdl_carga
       "SIM"
      gbl_mdl_tramo
       600
      gbl_mdl_cadunico
       "NÃO"
      gbl_mdl_municipio
       "SIM"
      gbl_mdl_parcprojeto
       "SIM"
      gbl_mdl_parcconstrucao
       "SIM"
      gbl_mdl_cliente
       "SIM"
      gbl_mdl_mosaicogeral
       "MOSAICO6"
      gbl_mdl_qtdfases
       1
      gbl_mdl_carte_arvores
      "SIM"
    gbl_mdl_limpeza_faixa
     "SIM"
   gbl_mdl_area_ambiental
     "SIM"
;;;    	gbl_mdl_tipopi
;;;	 "NÃO"
    )
  )


   ;; 3#4/0 AGRICULTURA
(if (= gbl_entrada "MT11")
  (setq
    gbl_mdl_cabo
     "3#4/0CAA"
    gbl_mdl_tabposte
     "tabela1"
    gbl_mdl_vaomaximo
     80
    gbl_mdl_tiptrafo
     "SIM"
    gbl_mdl_telefone
     "SIM"
    gbl_mdl_padmedicao
     "NÃO"
    gbl_mdl_ssligacao
     "SIM"
    gbl_mdl_numprojeto
     "SIM"
    gbl_mdl_postintercalado
     "SIM"
    gbl_mdl_vaofrouxo
     "SIM"
    gbl_mdl_plpt
     "SIM"
    gbl_mdl_carga
     "SIM"
    gbl_mdl_tramo
     600
;;;    gbl_mdl_cadunico
;;;     "SIM"
;;;    gbl_mdl_municipio
;;;     "SIM"
;;;    gbl_mdl_parcprojeto
;;;     "SIM"
;;;    gbl_mdl_parcconstrucao
;;;     "SIM"
    gbl_mdl_cliente
     "SIM"
    gbl_mdl_mosaicogeral
     "MOSAICO7"
    gbl_mdl_qtdfases
     1 
    gbl_mdl_carte_arvores
      "SIM"
    gbl_mdl_limpeza_faixa
     "SIM"
;;;    gbl_mdl_cerca
;;;     "NÃO"
    gbl_mdl_area_ambiental
     "SIM"
;;;    	gbl_mdl_tipopi
;;;	 "NÃO"
  )
)

;;MODULO MT13 3#4/0 CIDADE
  (if (= gbl_entrada "MT13")
  (setq
    gbl_mdl_cabo
     "3#4/0CAA"
    gbl_mdl_tabposte
     "tabela1"
    gbl_mdl_vaomaximo
     40
    gbl_mdl_tiptrafo
     "SIM"
    gbl_mdl_telefone
     "SIM"
    gbl_mdl_padmedicao
     "NÃO"
    gbl_mdl_ssligacao
     "SIM"
    gbl_mdl_numprojeto
     "SIM"
    gbl_mdl_postintercalado
     "SIM"
    gbl_mdl_vaofrouxo
     "SIM"
    gbl_mdl_plpt
     "SIM"
    gbl_mdl_carga
     "SIM"
    gbl_mdl_tramo
     400
;;;    gbl_mdl_cadunico
;;;     "SIM"
;;;    gbl_mdl_municipio
;;;     "SIM"
;;;    gbl_mdl_parcprojeto
;;;     "SIM"
;;;    gbl_mdl_parcconstrucao
;;;     "SIM"
    gbl_mdl_cliente
     "SIM"
    gbl_mdl_mosaicogeral
     "MOSAICO7"
    gbl_mdl_qtdfases
     1 
    gbl_mdl_carte_arvores
      "SIM"
    gbl_mdl_limpeza_faixa
     "SIM"
;;;    gbl_mdl_cerca
;;;     "NÃO"
    gbl_mdl_area_ambiental
     "SIM"
;;;    	gbl_mdl_tipopi
;;;	 "NÃO"
  )
)

)








	     