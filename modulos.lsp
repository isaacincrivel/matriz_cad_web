;;; <><><><><><><><><><><><><><><><><><><><><>   < MODULOS - TABELA DE MÓDULOS E CABOS >     <><><><><><><><><><><><><><><><><><><><><>
;;; <><><><><><><><><><><><><><><><><><><><><>   SISTEMA MATRIZ - ENEL     				<><><><><><><><><><><><><><><><><><><><><>
;;;
;;; Tabela de módulos cadastrados. Quando as colunas CB_1A, CB_1B, CB_2A ... CB_BT3 contêm
;;; um código de módulo, a tensão e demais dados são obtidos desta tabela (não precisa validar).
;;;
;;; Estrutura: (codigo cabo tipo tensao local)
;;;   codigo  - Código do módulo (ex: "10103")
;;;   cabo    - Descrição do cabo (ex: "1#1/0CAA")
;;;   tipo    - Tipo: monof, trif, etc.
;;;   tensao  - Código interno: "15"=13,8kV ou "36"=34,5kV
;;;   local   - Local de instalação: rural, urbano, etc.
;;;

(defun ENEL_MODULOS_INIT ()
  (setq GLB_LST_MODULOS
    (list
      ;; Módulo 10103: cabo 1#1/0CAA, monofásico, 13,8kV, rural
      (list "10103" "1#1/0CAA" "monof" "15" "rural")
      ;; Incluir novos módulos aqui. Exemplo:
      ;; (list "10104" "2#1/0CAA" "trif" "36" "urbano")
    )
  )
)

;;;<> ENEL_MODULO_BY_CODIGO
;;;++ Retorna dados do módulo pelo código, ou nil se não encontrar
(defun ENEL_MODULO_BY_CODIGO (codigo / lst)
  (if (not (boundp 'GLB_LST_MODULOS))
    (ENEL_MODULOS_INIT))
  (car (vl-member-if
    (function (lambda (x) (equal (car x) (vl-princ-to-string codigo))))
    GLB_LST_MODULOS)))

;;;<> ENEL_MODULO_TENSAO
;;;++ Retorna código de tensão ("15" ou "36") do módulo, ou nil se não cadastrado
(defun ENEL_MODULO_TENSAO (codigo / mdl)
  (setq mdl (ENEL_MODULO_BY_CODIGO codigo))
  (if mdl (nth 3 mdl) nil))

;;;<> ENEL_MODULO_CABO
;;;++ Retorna descrição do cabo pelo código do módulo, ou o próprio código se não cadastrado
(defun ENEL_MODULO_CABO (codigo / mdl)
  (setq mdl (ENEL_MODULO_BY_CODIGO codigo))
  (if mdl (nth 1 mdl) (vl-princ-to-string codigo)))

;;;<> ENEL_TENSAO_FROM_CB
;;;++ Obtém tensão a partir das colunas CB_1A...CB_BT3 (lst_row do CSV)
;;;++ Retorna "15", "36" ou nil (usa valor padrão)
(defun ENEL_TENSAO_FROM_CB (lst_row / idx cod tensa)
  (setq tensa nil idx 3)
  ;; Índices CB_1A=3 ... CB_BT3=17
  (while (and (<= idx 17) (not tensa))
    (setq cod (nth idx lst_row))
    (if (and cod (= (type cod) 'STR) (/= cod "") (/= (strcase cod) "NIL"))
      (setq tensa (ENEL_MODULO_TENSAO cod)))
    (setq idx (1+ idx)))
  tensa)

;;;<> ENEL_STATUS_SUFIXO
;;;++ Retorna sufixo para cabo conforme status da linha CSV
(defun ENEL_STATUS_SUFIXO (status / s)
  (setq s (strcase (vl-princ-to-string status)))
  (cond ((= s "IMPLANTAR") "_IMPL")
	((= s "EXISTENTE") "_EXIST")
	((= s "RETIRAR") "_RET")
	((= s "DESLOCAR") "_DESLOC")
	(t "_IMPL")))

;; Inicializa a lista ao carregar o arquivo
(ENEL_MODULOS_INIT)

(princ "\n modulos.lsp carregado - tabela de módulos e cabos.")
