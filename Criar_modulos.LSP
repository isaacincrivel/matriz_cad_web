(defun c:mscriar2 (/ ss ent p e1 e2 bt1 bt2 poste estai base xdata inspt)

  (princ "\nSelecione UMA polilinha:\n")
  (setq ss (ssget '((0 . "LWPOLYLINE,POLYLINE"))))

  (if (and ss (= (sslength ss) 1))
    (progn
      (setq ent (ssname ss 0))

      ;; Entrada de dados
      (setq e1   (getstring T "\nestru_mt_nv1: "))
      (setq e2   (getstring T "\nestru_mt_nv2: "))
      (setq bt1  (getstring T "\nestru_bt_nv1: "))
      (setq bt2  (getstring T "\nestru_bt_nv2: "))
      (setq poste (getstring T "\ntipo_poste: "))
      (setq estai (getstring T "\nestai_ancora: "))
      (setq base  (getstring T "\nbase_concreto: "))
      (setq rotacao (getstring T "\nrotacao_poste: "))
      (setq tang_ou_enc (getstring T "\ntang_ou_enc: "))


   

      ;; Montagem do XDATA
      (regapp "MOSAICO")

   (setq xdata
  (list
    (list
      -3
      (append
        (list "MOSAICO")
        (list
          (cons 1000 (strcat "estru_mt_nv1=" e1))
          (cons 1000 (strcat "estru_mt_nv2=" e2))
          (cons 1000 (strcat "estru_bt_nv1=" bt1))
          (cons 1000 (strcat "estru_bt_nv2=" bt2))
          (cons 1000 (strcat "tipo_poste=" poste))
          (cons 1000 (strcat "estai_ancora=" estai))
          (cons 1000 (strcat "base_concreto=" base))
          (cons 1000 (strcat "rotacao_poste=" rotacao))
          (cons 1000 (strcat "tang_ou_enc=" tang_ou_enc))
        )
      )
    )
  )
)

      (entmod (append (entget ent) xdata))

      ;; Ponto para plotar texto
      (setq inspt (cdr (assoc 10 (entget ent))))

      (command "_.TEXT"
        inspt
        2.5
        0
        (strcat
          "N1:" e1
          " N2:" e2
          " BT1:" bt1
          " BT2:" bt2
          " P:" poste
        )
      )

      (princ "\nXDATA gravado com sucesso.")
    )
    (princ "\nSelecione apenas UMA polilinha v�lida.")
  )
  (princ)
)



(defun ms-format-point (pt / x y)
  (setq x (rtos (car pt) 2 6))
  (setq y (rtos (cadr pt) 2 6))
  (strcat "(" x ", " y ")")
)

(defun ms-format-polygon (poly / result first pt)
  (setq result "[")
  (setq first T)
  (foreach pt poly
    (if (not first)
      (setq result (strcat result ", "))
    )
    (setq result (strcat result (ms-format-point pt)))
    (setq first nil)
  )
  (setq result (strcat result "]"))
  result
)

(defun ms-format-json (xdata poly id / result first key value)
  (setq result "{")
  (setq first T)
  
  ;; Adiciona campos do XDATA
  (foreach item xdata
    (setq key (car item))
    (setq value (cdr item))
    (if (not first)
      (setq result (strcat result ", "))
    )
    (setq result (strcat result "\"" key "\": \"" value "\""))
    (setq first nil)
  )
  
  ;; Adiciona polygon
  (if (not first)
    (setq result (strcat result ", "))
  )
  (setq result (strcat result "\"polygon\": " (ms-format-polygon poly)))
  (setq first nil)
  
  ;; Adiciona id
  (if (not first)
    (setq result (strcat result ", "))
  )
  (setq result (strcat result "\"id\": \"" id "\""))
  
  (setq result (strcat result "}"))
  result
)

(defun c:msvalor (/ ss i ent xdata poly json)

  (princ "\nSelecione as polilinhas do mosaico:\n")
  (setq ss (ssget '((0 . "LWPOLYLINE,POLYLINE"))))

  (if ss
    (progn
      (setq i 1)
      (repeat (sslength ss)
        (setq ent (ssname ss (1- i)))

        (setq xdata (ms-get-xdata-mosaico ent))
        (setq poly  (ms-get-poly-points ent))
        (setq json  (ms-format-json xdata poly (strcat "ms" (itoa i))))

        (princ "\n")
        (princ json)

        (setq i (1+ i))
            (princ
              (strcat
                "\n  "
                (car d)
                " = "
                (cdr d)
              )
            )
          )
          (princ "\n  (XDATA n�o encontrado)")
        )

        (princ "\n  polygon: ")
        (princ (vl-princ-to-string poly))

        (setq i (1+ i))
      )
    )
    (princ "\nNada selecionado.")
  )
  (princ)
)



(defun ms-get-xdata-mosaico (ent / all xd applist app res str pos)
  (setq res '())
  (setq all (entget ent '("*")))

  ;; procura grupo -3
  (foreach xd all
    (if (= (car xd) -3)
      (progn
        (setq applist (cdr xd))
        ;; Normaliza: se primeiro elemento é string, é aplicativo único
        (if (eq (type (car applist)) 'STR)
          (setq applist (list applist))
        )
        ;; Procura "MOSAICO" na lista de aplicativos
        (foreach app applist
          (if (and (listp app)
                   (eq (car app) "MOSAICO"))
            (foreach x (cdr app)
              (if (= (car x) 1000)
                (progn
                  (setq str (cdr x))
                  (setq pos (vl-string-search "=" str))
                  (if pos
                    (setq res
                      (cons
                        (cons
                          (substr str 1 pos)
                          (substr str (+ pos 2))
                        )
                        res
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
  (reverse res)
)




(defun ms-get-poly-points (ent / elst pts)
  (setq elst (entget ent))
  (setq pts '())
  (foreach x elst
    (if (= (car x) 10)
      (setq pts (append pts (list (cdr x))))
    )
  )
  ;; fecha o pol�gono
  (if (and pts (/= (car pts) (last pts)))
    (setq pts (append pts (list (car pts))))
  )
  pts
)





(defun c:verxdata ()
  (setq e (car (entsel "\nSelecione a entidade: ")))
  (princ "\nXDATA COMPLETO:\n")
  (princ (vl-princ-to-string (entget e '("*"))))
  (princ)
)