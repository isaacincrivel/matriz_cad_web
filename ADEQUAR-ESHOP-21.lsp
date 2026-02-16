;;; ##########################################      ELETRICASHOP      ##########################################
;;; ##########################################      ELETRICASHOP      ##########################################



;;/// DESCRIÇÃO: COMANDO DE INICIALIZAÇÃO - VERIFICA INSTALAÇÃO - SETA VALOR PARA VARIAVEIS CAD
;;/// ENTRADA: 
;;/// SAIDA:
(DEFUN RDINICIO	(/	  FilSys   DrvObj   serialx  1x	      2x
		 3x	  4X	   arqserial	     arquivo2 serialx
		 DAT-VAL
		)
  (SETQ INICIO 0)
  (setq FilSys (vlax-create-object "Scripting.FileSystemObject"))
  (setq DrvObj (vlax-invoke FilSys "GetDrive" "c:"))
  (setq serialx (vlax-get DrvObj "SerialNumber"))
  (setq serialx (itoa serialx))
  (setq	1x (substr serialx 5 1)
	2x (substr serialx 2 1)
	3x (substr serialx 3 1)
	4x (substr serialx 1 1)
  )
  (setq	arqserial (strcat "98734985984357938457934587897987"
			  1x
			  2x
			  3x
			  4x
			  "54987654987654987888"
			 )
  )
  (setq
    arquivo2 (strcat "C:\\ACADELETRIZ\\" arqserial ".TXT")
  )
  (IF
    (AND
      (>
	(LOAD_DIALOG
	  "C:\\ACADELETRIZ\\98237984IUK093409234OKIJOIUOI8973987429834UOIJLKAWOIAS.TXT"
	)
	0
      )
      (> (LOAD_DIALOG arquivo2) 0)
    )
     (SETQ INICIO 1)
     (SETQ INICIO 0)
  )
  (setq DAT-VAL (substr (rtos (getvar "CDATE") 2 0) 1 6))
  (setq DAT-VAL (atoi DAT-VAL))
  (if (> DAT-VAL 201809)
    (progn
      (SETQ INICIO 0)
      (alert "Erro 15")
    )
    (SETQ INICIO 1)
  )
  (IF (= INICIO 1)
    (PROGN
      (gc)				;(command "-view" "save" "ZZ" "")
      (SETVAR "SAVETIME" 10)
      (COMMAND "_UNDO" "_BEGIN")
      (SETQ
	cmdecho	      (GETVAR "CMDECHO")
	blipmode      (GETVAR "BLIPMODE")
	CLAYER	      (GETVAR "CLAYER")
	osmodeXX      (GETVAR "OSMODE")
	osnapcoord    (GETVAR "OSNAPCOORD")
	cecolor	      (GETVAR "CECOLOR")
					;savetime      (GETVAR "SAVETIME")
	erro-original *error*
	*error*	      erro
      )
      (SETVAR "SAVETIME" 10)
    )
  )
)

;;/// DESCRIÇÃO: MENSAGEM E RECUPERAÇÃO DE DADOS QUANDO HOUVER ERROS
;;/// ENTRADA: 
;;/// SAIDA:
(DEFUN erro (msg)
  (alert msg)
					;(Alert "\nO Comando foi Cancelado...")
					;(PROMPT "\nO Comando foi Cancelado...")
  (IF (/= VARSELECETG NIL)
    (PROGN
      (command "chprop" VARSELECETG2 "" "C" "BYLAYER" "")
      (command "chprop" VARSELECETG2 "" "LW" "BYLAYER" "")
      (SETQ VARSELECETG NIL)
    )
  )
  (SETVAR "CMDECHO" cmdecho)
  (SETVAR "BLIPMODE" blipmode)
  (SETVAR "CLAYER" clayer)
  (SETVAR "OSMODE" osmodeXX)
  (SETVAR "OSNAPCOORD" osnapcoord)
  (SETVAR "CECOLOR" cecolor)
					;(SETVAR "SAVETIME" savetime)


  (if eshop_dcl
    (UNLOAD_DIALOG eshop_dcl)
  )


  (SETQ *error* erro-original)
  (PRINC "\nFim")
  (PRINC)
)


;;;(DEFUN meu_error (msg)
;;;    (PRINC  "\n-> Erro : ")
;;;    (PRINC  msg)
;;;    (PRINC )
;;;    (IF	expert
;;;      (SETVAR "EXPERT" expert)
;;;    )
;;;    (IF	estilo
;;;      (SETVAR "TEXTSTYLE" estilo)
;;;    )
;;;    (IF	dh
;;;      (UNLOAD_DIALOG dh)
;;;    )
;;;    (PRINC )
;;;  )
;;;  (SETQ	old-error *error*
;;;	*error*	meu_error
;;;  )




;;/// DESCRIÇÃO: VOLTA AS VARIAVEIS PARA O ESTADO QUE ESTAVA ANTES DE INICIAR A ROTINA
;;/// ENTRADA: 
;;/// SAIDA:
(DEFUN RDFINAL ()
  (gc)
  (princ)
					;(command "regen")
  (SETVAR "CMDECHO" cmdecho)
  (SETVAR "BLIPMODE" blipmode)
  (SETVAR "CLAYER" clayer)
  (SETVAR "OSMODE" osmodeXX)
  (SETVAR "OSNAPCOORD" osnapcoord)
  (SETVAR "CECOLOR" cecolor)
  (SETQ *error* ERRO_ORIGINAL)
  ;; COMANDO PARA HABILITAR A CHAVE DE EXPLOSÃO DE BLOCOS
  (und-explodir)
  ;; FIM UND
					;(command "-view" "restore" "ZZ")
  (COMMAND "_UNDO" "_END")
)


;;/// DESCRIÇÃO: CRIA VALORES DE VARIAVEIS DO AUTOCAD PARA FACILITAR O USO DO COMANDO
;;/// ENTRADA: CLASE DE COMANDO A SER UTILIZADO
;;/// SAIDA: MUDA AS VARIAVEIS DO AUTOCAD
(DEFUN CONF_INICIAL (INICIAL_NOME /)
  (COND
    ((OR (= INICIAL_NOME "CLIENTE") (= INICIAL_NOME "MCPT"))
     (PROGN
       (SETVAR "CMDECHO" 0)
       (SETVAR "BLIPMODE" 0)
       (SETVAR "OSNAPCOORD" 1)
       (SETVAR "OSMODE" 0)
       (SETVAR "PDMODE" 0)
       (SETVAR "CECOLOR" "BYLAYER")
     )
    )
    ((OR (= INICIAL_NOME "TRAFO")
	 (= INICIAL_NOME "CABO")
	 (= INICIAL_NOME "PTENTREGA")
	 (= INICIAL_NOME "LUMINARIA")
	 (= INICIAL_NOME "ATERRAMENTO")
	 (= INICIAL_NOME "PARA-RAIO")
	 (= INICIAL_NOME "CHAVE")
	 (= INICIAL_NOME "CHAVEFACA")
	 (= INICIAL_NOME "GLV")
	 (= INICIAL_NOME "CHAVEFUSIVEL")
	 (= INICIAL_NOME "MARCADOR")
	 (= INICIAL_NOME "DISTANCIA")
	 (= INICIAL_NOME "ESTAI")
	 (= INICIAL_NOME "PADRAO-01")
     )
     (PROGN
       (SETVAR "CMDECHO" 0)
       (SETVAR "BLIPMODE" 0)
       (SETVAR "OSNAPCOORD" 0)
       (SETVAR "OSMODE" 8)
     )
    )
    ((= INICIAL_NOME "TEXTO")
     (PROGN
       (SETVAR "CMDECHO" 0)
       (SETVAR "BLIPMODE" 0)
       (SETVAR "OSNAPCOORD" 1)
       (setvar "textsize" 7.0)
       (SETVAR "ATTREQ" 1)
       (SETVAR "CECOLOR" "BYLAYER")
       (setvar "osmode" 512)
       (command "STYLE" "Standard" "ROMANS" "" "" "" "" "" "")
     )
    )
    ((= INICIAL_NOME "AVULSO")
     (PROGN
       (SETVAR "CMDECHO" 0)
       (SETVAR "BLIPMODE" 0)
       (SETVAR "OSNAPCOORD" 1)
       (SETVAR "CECOLOR" "BYLAYER")
       (setvar "osmode" 523)
     )
    )
    ((= INICIAL_NOME "GERAL")
     (PROGN
       (SETVAR "CMDECHO" 0)
       (SETVAR "BLIPMODE" 0)
       (SETVAR "OSNAPCOORD" 1)
       (SETVAR "OSMODE" 0)
					;(SETVAR "PDMODE" 0)
       (SETVAR "CECOLOR" "BYLAYER")
     )
    )
  )
)

;;;;;*********************************** (NOVO_ARQUIVO) ***************************************************
;;/// DESCRIÇÃO: ABRE UM NOVO ARQUIVO ESPECIFICANDO O ENDEREÇO PARA ABRIR - ENDEREÇO COM O ARQUIVO DWG
;;/// ENTRADA: ENDEREÇO ARQUIVO DWG
;;/// SAIDA: ABERTURA DE ARQUIVO

(DEFUN NOVO_ARQUIVO (ARQUIVO / V1 V2 V3 newDrawing)
  (vl-load-com)
  (setq V1 (vlax-get-acad-object))
  (setq V3 (vla-get-ActiveDocument V1))
  (setq V2 (vla-get-documents V1))
  (setq newDrawing ARQUIVO)
  (if
    (= 0 (getvar "SDI"))
     (vla-activate (vla-open V2 newDrawing))
     (vla-sendcommand
       V3
       (
	strcat "(command \"_open\")\n"
	       newDrawing
	       "\n"
       )
     )
  )
  (print "this part is not reached")
)






;;;*************************************** PONTO_NO_PONTO **************************************
;;;/// DESCRIÇÃO: BUSCA O PONTO (POSTE) QUE ESTA NUMA COORDENADA - COM TRES TENTATIVAS DE DISTANCIAS
;;;/// ENTRADA: A COORDENADA (PONTO)
;;;/// SAIDA: NUMERO (SEQ) DO PONTO
(DEFUN PONTO_NO_PONTO (PONTO / SEL1 SEL2 SEL3)
  (SETQ VAR 0)

  ;; SE NO PONTO SOLICITADO NÃO EXISTIR NENHUM PONTO(POSTE)
  ;; DA UMA MENSAGEM DE ERRO
  (IF (= (SELECAO_PONTO PONTO 1.5) NIL)
    (PROGN
      (ALERT "NÃO FOI LOCALIZADO NENHUM ELEMENTO NO PONTO")
      (COMMAND "LINE" "0,0,0" PONTO "")
      (EXIT)
    )
  )

  (SETQ SEL1 (SOMENTE_XDATA (SELECAO_PONTO PONTO 1.5) "PONTO"))

  (IF (/= SEL1 NIL)
    (IF	(= (SSLENGTH SEL1) 1)
      (PROGN
	(SETQ PTO (BUSC_COLUN_ELM (SSNAME SEL1 0) 0 "PONTO"))
	(SETQ VAR 1)
      )
    )
  )
  (IF (= VAR 0)
    (PROGN
      (SETQ SEL2 (SOMENTE_XDATA (SELECAO_PONTO PONTO 0.5) "PONTO"))
      (IF (/= SEL2 NIL)
	(IF (= (SSLENGTH SEL2) 1)
	  (PROGN
	    (SETQ PTO (BUSC_COLUN_ELM (SSNAME SEL2 0) 0 "PONTO"))
	    (SETQ VAR 1)
	  )
	)
      )
    )
  )
  (IF (= VAR 0)
    (PROGN
      (SETQ SEL3 (SOMENTE_XDATA (SELECAO_PONTO PONTO 0.2) "PONTO"))
      (IF (/= SEL3 NIL)
	(IF (= (SSLENGTH SEL3) 1)
	  (PROGN
	    (SETQ PTO (BUSC_COLUN_ELM (SSNAME SEL3 0) 0 "PONTO"))
	    (SETQ VAR 1)
	  )
	)
      )
    )
  )
  (IF (= VAR 0)
    (PROGN

      (COMMAND "LINE" "0,0,0" PONTO "")

      (ALERT
	"ERRO, EXISTE MAIS DE UM PONTO NA EXTREMIDADE DO CABO, OU NENHUM PONTO - ATENÇÃO - VERIFIQUE."
      )
      (EXIT)
    )
  )
  (SETQ PTO PTO)
)





;;;*************************************** LC-PT **************************************************
;;;/// DESCRIÇÃO: LOCALIZA AS COORDENADAS DO PONTO SOLICITADO
;;;/// ENTRADA: TIPO OBJETO E A SEQUENCIA QUE QUER BUSCAR
;;;/// SAIDA: LISTA COM A COORDENADA DESTE PONTO

(DEFUN LC-PT (TIPOOBJETO  PONTO-LOC   /		  RED04
	      RED05	  RED8	      NUM-PONTO	  VAR-PONTO
	      QDDEOBJETO  LISTAPT
	     )
  (SETQ SEL_XDATA_LISTA (SELEC_ALL TIPOOBJETO))
  (IF (/= SEL_XDATA_LISTA NIL)
    (PROGN
      (setq RED04 0)
      (SETQ RED05 (SSLENGTH SEL_XDATA_LISTA))
      (while (> RED05 RED04)
	(setq RED8 (ssname SEL_XDATA_LISTA RED04))
	(DADOS_ELEM RED8 TIPOOBJETO)
	(COND
	  ((= TIPOOBJETO "PONTO") (SETQ NUM-PONTO VAR-NUM-PONTO))
	  ((= TIPOOBJETO "CABOBT") (SETQ NUM-PONTO VAR-NUM-CABO))
	  ((= TIPOOBJETO "TRAFO") (SETQ NUM-PONTO VAR-NUM-TRAFO))
	  ((= TIPOOBJETO "CLIENTE") (SETQ NUM-PONTO VAR-NUM-CLIENTE))
	)
	(IF (= NUM-PONTO PONTO-LOC)
	  (PROGN
	    (SETQ LISTAPT (APPEND LISTAPT (LIST VAR-PONTO)))
	  )
	)
	(SETQ RED04 (+ RED04 1))
      )
    )
    (ALERT "=> O PROJETO NÃO POSSUI NENHUM PONTO.")
  )					;IF
  (SETQ LISTAPT LISTAPT)
)




;;/// DESCRIÇÃO: CONVERTE ARQUIVO CSV EM LISTA
;;/// ENTRADA: ENDEREÇO COMPLETO DO ARQUIVO
;;/// SAIDA: LISTA COM ELEMENTOS - VARIAVEL 
(DEFUN CSV->LISTATXT (NOMEARQUIVO / L1 TXT ARQ)
  (SETQ arq (OPEN NOMEARQUIVO "r"))
  (while (setq TXT (read-line arq))
    (progn
      (if L1
	(setq L1 (append L1 (list TXT)))
	(SETQ L1 (list TXT))
      )
    )
  )
  (close arq)
  (SETQ L1 L1)
)

;;;*************************************** TITULO_TABELAS **************************************
;;;/// DESCRIÇÃO: ESCREVE AS TABELAS NO CSV CONFORME DADOS DE ENTRADA, ESTA PASTA É CRIADA NO LOCAL ONDE ESTA O ARQUIVO UTILIZADO
;;;/// ENTRADA: STRING COM OS NOMES PARA TABELA E O NOME DA TABELA - SE É MARCADOR OU PONTO...
;;;/// SAIDA: A TABELA.CSV CRIADA NO ENDEREÇO PADRÃO E COM O CABEÇALHO
(DEFUN TITULO_TABELAS (ARG446	LISTA446 /	  LOCALNOME
		       DATACTRL	ANO	 MES	  DIA	   DATAX
		       ARQ
		      )
  ;; VERIFICA SE NO LOCAL DO ARQUIVO EXISTE UMA PASTA TABELAS, SE SIM ESCREVE DENTRO DELA SE NÃO, CRIA E  ESCREVE DENTRO DELA
  (IF (VL-FILE-DIRECTORY-P
	(STRCAT (GETVAR "DWGPREFIX") "TABELAS")
      )
    (setq localnome (STRCAT (STRCAT (GETVAR "DWGPREFIX") "TABELAS\\")
			    ARG446
			    ".CSV"
		    )
    )
    (PROGN
      (VL-MKDIR (STRCAT (GETVAR "DWGPREFIX") "TABELAS"))
      (setq
	localnome (STRCAT (STRCAT (GETVAR "DWGPREFIX") "TABELAS\\")
			  ARG446
			  ".CSV"
		  )
      )
    )
  )
  (SETQ DATACTRL (substr (rtos (getvar "cdate") 2 1) 1 8))
  (SETQ	ANO (SUBSTR DATACTRL 1 4)
	MES (SUBSTR DATACTRL 5 2)
	DIA (SUBSTR DATACTRL 7 2)
  )
  (SETQ DATAX (STRCAT DIA "-" MES "-" ANO))
  (if (= (SETQ arq (OPEN localnome "w")) nil)
    (PROGN
      (ALERT (STRCAT "ARQUIVO \n"
		     localnome
		     "
		  ABERTO, FECHE-O PARA PROSSEGUIR"
	     )
      )
      (ALERT (STRCAT "ARQUIVO \n"
		     localnome
		     "  ABERTO, FECHE-O PARA PROSSEGUIR \n"
	     )
      )
    )
  )
  (PRINC LISTA446
	 arq
  )
  (CLOSE arq)
)


;;;*************************************** IMPRIMIR-LISTA-CSV *************************************
;;;/// DESCRIÇÃO: ESCREVE UMA LISTA COM VARIAS LISTAS CONTENDO STRING EM UM ARQUIVO CSV
;;;/// ENTRADA: O ENDERECO DO ARQUIVO, E (("AA" "BBB")("AA" "CC")("RR" "TT"))
;;;/// SAIDA: CADA LISTA EM UMA LINHA DO ARQUIVO CSV

;;;/// VERIFICAR QUANDO A LISTA TIVER SOMENTE UM ELEMENTO 

(DEFUN IMPRIMIR-LISTA-CSV
       (ENDERECO LISTA-ESCREVER / ARQ Y X VL-PRINT ARQ)
  (SETQ	ARQ (OPEN ENDERECO
		  "a"
	    )
  )
  (SETQ VL-PRINT "")
  (FOREACH X LISTA-ESCREVER
    (FOREACH Y X
      (IF (= VL-PRINT "")
	(SETQ VL-PRINT (STRCAT Y ";"))
	(SETQ VL-PRINT (STRCAT VL-PRINT Y ";"))
      )
    )					;FOREACHY
    (PRINC (STRCAT VL-PRINT "\n") ARQ)
    (SETQ VL-PRINT "")
  )
  ;;FOREACHX  
  (CLOSE ARQ)
)



;;;*************************************** CONVERSOR-DADOSXPONTO-FUNC *****************************
;;;/// DESCRIÇÃO: BUSCA OS DADOS DE UM ARQUIVO CSV QUE POSSUI A PRIMEIRA LINHA COMO INDICE, COLOCA TODOS
;;;// OS DADOS EM VARIAVEIS CONFORME ESSES INDICES, A FUNÇÃO DE ENTRADA EXECUTARA PARA CADA LINHA 
;;;/// ENTRADA: FUNCAO-ENTRADA - SEMPRE LE O ARQUIVO DADOSXPONTO
;;;/// SAIDA: A FUNCAO DE ENTRADA EXECUTADA PARA CADA LINHA.

(DEFUN CONVERSOR-DADOSXPONTO-FUNC (FUNCAO-ENTRADA   ENDERECO
				   /		    LISTA-DADOSXPONTO
				   LISTA-DADOSXPONTO
				   VR1X		    LISTANIL
				   LST-DDXPT-TIT    LINHA
				  )

  ;; ABRE UM ENDEREÇO CSV - LÊ O ARQUIVO E CRIA DUAS LISTAS, UMA LISTA COM O TITULO DO ARQUIVO
					;"LST-DDXPT-TIT" E OUTRA COM TODAS AS OUTRAS LINHAS DO ARQUIVO "LISTA-DADOSXPONTO"
  (SETQ	LISTA-DADOSXPONTO
	 (CSV->LISTATXT
	   ;;
	   ENDERECO
;;;	   (STRCAT (GETVAR "DWGPREFIX")
;;;		   "TABELAS\\DADOSXPONTO.CSV"
;;;		   
;;;	   )
	 )
  )
  (SETQ LST-DDXPT-TIT (STRING->LISTA (CAR LISTA-DADOSXPONTO)))
  (SETQ LISTA-DADOSXPONTO (CDR LISTA-DADOSXPONTO))

  ;; PARA CADA LINHA DO TITULO A FUNCÃO ABAIXO LE AS OUTRAS LINHAS E DECLARAM AS VARIAVIES PERTINENTES,
  ;; DENTRO DA FUNÇÃO, O COMANDO (CONDIÇÕES CONVERTER) É A FUNÇÃO QUE VAI FAZER CONDICIOAIS COM ESTAS VARIAVEIS.
  (SETQ VR1X 0)
  (REPEAT (LENGTH LISTA-DADOSXPONTO)
    (SETQ LINHA (STRING->LISTA (NTH VR1X LISTA-DADOSXPONTO)))
    (LSTTEXTO_PARA_VAR LST-DDXPT-TIT LINHA)

;;; ROTINA CENTRAL PARA DEFINIR AÇÕES
    (EVAL (READ FUNCAO-ENTRADA))

    (SETQ VR1X (1+ VR1X))

    ;; ZERANDO TODAS AS VARIAVEIS
    (SETQ LISTANIL (LIST NIL))
    (REPEAT (1- (LENGTH LST-DDXPT-TIT))
      (SETQ LISTANIL (APPEND LISTANIL (LIST NIL)))
    )
    (LSTTEXTO_PARA_VAR LST-DDXPT-TIT LISTANIL)
  )
)


;;;; sustituida
;;;;<> ESHOP-JNT-LST-LST
;;;;++ DESCRIÇÃO: CRIA UMA NOVA LISTA COM PARES DE DUAS LISTAS
;;;;++ ENTRADA:  LST1:LISTA 1 ; LST2:LISTA 2 (EX: ("AA" "BB" "CC") E ("1" "2" "3"), A NOVA LISTA (("AA" "1") ("BB" "2") ("CC" "3"))
;;;;;;;++ SAIDA: LISTA CRIADA COM PARES
;;;(defun ESHOP-JNT-LST-LST (lst1 lst2 / int1 x lst3)
;;;  (setq int1 0)
;;;  (foreach x lst1
;;;    (setq lst3 (append lst3 (list (list x (nth int1 lst2)))))
;;;    (setq int1 (1+ int1))
;;;  )
;;;  lst3
;;;)









;;;<> DESCRIÇÃO: COMANDOS GERAISPARA BUSCAR DADOS DXF
;;;++ ENTRADA: 
;;;++ SAIDA:

(DEFUN DXF (cod ety1) (cdr (assoc cod ety1)))
(DEFUN DXF10 (ety1) (cdr (assoc 10 ety1)))
(DEFUN DXF11 (ety1) (cdr (assoc 11 ety1)))
(DEFUN DXF12 (ety1) (cdr (assoc 12 ety1)))
(DEFUN DXF50 (ety1) (cdr (assoc 50 ety1)))

;;/// DESCRIÇÃO: CONSULA GERAL TELA - APOIO PROGRAMAÇÃO
;;/// ENTRADA: 
;;/// SAIDA:
(DEFUN C:EEE ()
  (ENTGET (CAR (ENTSEL)) '("*"))
)






;;;;;*********************************** (SUBST_NA_SEQUENCIA) *************************************
;;/// DESCRIÇÃO: SUBSTITUI OS VALORES DE UMA LISTA EM OUTRA INICIANDO EM UM INDICE (N)
;;/// ENTRADA: L1=( 1 2 3 4 5 6 7) n=3 L2=(X Y Z)
;;/// SAIDA: LISTA (1 2 X Y Z 6 7)
;;/// OBS: CERTIFICAR QUE SUBSTITUIR AO COLOCAR L2, NÃO PASSE O TAMANHO DA LISTA L1
(DEFUN SUBST_NA_SEQUENCIA (L1 N L2 / X1 CTRL LST)
  (SETQ	V1 0
	CTRL 0
  )
  (FOREACH X1 L1
    (IF	(= V1 N)
      (SETQ CTRL 1)
    )
    (IF	(= CTRL 1)
      (PROGN
	(FOREACH X2 L2
	  (SETQ L1 (SUBST-ELEM-LISTA X2 V1 L1))
	  (SETQ V1 (1+ V1))
	)
	(SETQ CTRL 0)
      )
    )
    (SETQ V1 (1+ V1))
  )
  (SETQ L1 L1)
)


;;;;;*********************************** remove-n-LIST ********************************************
;;/// DESCRIÇÃO - COMANDO APOIO
;;(remove-n '(2 3 4) '("a" "b" "c" "d" "e" "f"))
;;retorna : ("a" "b" "f")
;;/// ENTRADA: LISTA COM A SEQUENCIA QUE SERA REMOVIDA (list 
;;/// SAIDA:  LISTA COM O ELEMENTO REMOVIDO
(defun remove-n-list (n lst / new nl)
  (setq	new nil
	nl  0
	n   (if	(listp n)
	      n
	      (list n)
	    )
	n   (vl-sort n '<)
  )
  (repeat (length lst)
    (if	(/= nl (car n))
      (setq new (append new (list (car lst))))
      (setq n (cdr n))
    )
    (setq lst (cdr lst)
	  nl  (1+ nl)
    )
  )
  new
)

;;;;;;*************************************** ADIC-ELM-LISTA ***********************************
;;/// DESCRIÇÃO: ADICIONA ELMENTO EM UMA LISTA
;;/// ENTRADA: O NOVO ELEMENTO A SER ADICIONADO; A SEQUENCIA; E A LISTA
;;/// SAIDA: LISTA COM O ELMENTO ADICIONADO
(DEFUN ADIC-ELM-LISTA (NEW N LST /)
  (SETQ	C  (LENGTH LST)
	l1 (list (car lst))
	vl 1
  )
  (while (< vl n)
    (setq l1 (append l1 (list (nth vl lst))))
    (setq vl (1+ vl))
  )
  (setq l1 (append l1 (list new)))
  (while (< vl c)
					;(while (<= vl c)
    (setq l1 (append l1 (list (nth vl lst))))
    (setq vl (1+ vl))
  )
  (setq l1 l1)
)


;;;;;;*************************************** LSTTEXTO_PARA_VAR **************************************
;;/// DESCRIÇÃO: TEMOS DUAS LISTAS, UMA COM STRING (QUE TRANFORMARA EM VARIAVEIS) E OUTRA COM VALORES, CRIA A 
;;    VARIAVEL COM O NOME STRING POREM COM O VALOR DA OUTRA LISTA
;;/// ENTRADA: LISTA COM VARIAVEL EM TXT, E LISTA COM VALORES
;;/// SAIDA: AS VARIAVEIS DEFINIDAS COM SEUS RESPECTIVOS VALORES



;;;;;;*************************************** QDADENUM_LSTSTRING **************************************
;;/// DESCRIÇÃO: CRIA UMA LISTA SEQUENCIAL, COM A QUANTIDADE DE NUMEROS SOLICITADOS NA ENTRADA
;;/// ENTRADA: O NUMERO DE ELEMENTOS DA LISTA - EX:8
;;/// SAIDA: A LISTA COM A SEQUENCIA DE O AO FINAL - EX: ("0" "1" "2" "3" "4" "5" "6" "7")
(DEFUN QDADENUM_LSTSTRING (NUMERO / LISTA-COLUNA VR1)
  (SETQ VR1 1)
  (SETQ LISTA-COLUNA (LIST "0"))
  (REPEAT (1- NUMERO)
    (SETQ LISTA-COLUNA (APPEND LISTA-COLUNA (LIST (RTOS VR1))))
    (SETQ VR1 (1+ VR1))
  )
  (SETQ LISTA-COLUNA LISTA-COLUNA)
)


;;;; ********************************* (LST_TAB->FILTRO_COLUNA)  **********************************
;;;; AO XDATACONTROL SOLICITADO
;;;; ENTRADA: (LISTA NOS PARAMENTRO (("XXXXXX" "YYYYYY" "ATERRAMENTO")("AAAAA" "BBBB" "ATERRAMENTO")
;;;; ("AAAAA" "BBBB" "CABOAT")) CONTROLE="ATERRAMENTO" INDICE(QUAL COLUNA)
;;;; SAIDA: SAIDA LISTA COM ELMENTOS QUE POSSUI UMA DETERMINADA COLUNA COM PARAMENTRO "ATERRAMENTO"
;;;;  -  (("XXXXXX" "YYYYYY" "ATERRAMENTO")("AAAAA" "BBBB" "ATERRAMENTO")) O INDICE SIGNIFICA A QUANTIDADE DE ELEMNTOS RETORNADA

(DEFUN LST_TAB->FILTRO_COLUNA (CONTROLE L1 INDICE / V1)
  (SETQ V1 (LENGTH L1))
  (WHILE (> V1 0)
    (PROGN
      (IF (/= (NTH INDICE (NTH (- V1 1) L1)) CONTROLE)
	(PROGN
	  (setq
	    L1
	     (REMOVE-ELEM-LISTA (- V1 1) L1)
	  )
	  (SETQ V1 (- V1 1))
	)
	(SETQ V1 (- V1 1))
      )
    )
  )
  (setq L1 L1)
)


;;;;;;*************************************** SUB-LIST ********************************************
;;;; DESCRIÇÃO: RETORNA UMA LISTA FRACIONADA
;;Se alguem já usou o CAR, CADR, CAADR, etc, deve ter sentido falta de recuparar uma lista de elementos
;;no meio da lista, exemplo: ( 1 2 3 4 5 6 ) se eu querer pegar os elementos do 2º ao 4º, temos (3 4 5), mas como fazê-lo?
;;pode ser assim
(defun sub-list	(lst a b / tmp n)
  (setq	tmp nil
	n   a
  )
  (while (>= b n)
    (setq tmp (append tmp (list (nth n lst)))
	  n   (1+ n)
    )
  )
  tmp
)


;;;;;;*************************************** SUB-LIST-FINAL ********************************************
;;;; DESCRIÇÃO: RETORNA UMA LISTA FRACIONADA
;;Se alguem já usou o CAR, CADR, CAADR, etc, deve ter sentido falta de recuparar uma lista de elementos
;;no meio da lista, exemplo: ( 1 2 3 4 5 6 ) se eu querer pegar os elementos do 2º ate o final, temos (3 4 5 6), mas como fazê-lo?
(defun sub-list-fim (lst a / tmp n b)
  (setq b (1- (length lst)))
  (setq	tmp nil
	n   a
  )
  (while (>= b n)
    (setq tmp (append tmp (list (nth n lst)))
	  n   (1+ n)
    )
  )
  tmp
)


;;;;;;*************************************** VER-INDICE-IGUAL-LISTA ********************************************
;;;; DESCRIÇÃO: COMPARA OS INDICES DE TODAS AS LISTAS SE FOREM IGUAIS RETORNA TRUE E NÃO RETORNA NIL
;;;; ENTRADA: LISTAS E O INDICE A SER COMPARADO
;;;; SAIDA: VERDADEIRO (T) OU FALSO (NIL)
(DEFUN VER-INDICE-IGUAL-LISTA (LISTA INDICE / V1 V2)
  (SETQ V1 (NTH INDICE (NTH 0 LISTA)))
  (FOREACH X LISTA
    (IF	(= V2 NIL)
      (IF (/= (NTH INDICE X) V1)
	(SETQ V2 "ERRO")
      )
    )
  )
  (IF (= V2 "ERRO")
    (SETQ V2 NIL)
    (SETQ V2 T)
  )
)


;;;;;*********************************** (COMPARAR-LISTA-COM-RETORNO) *****************************
;;/// DESCRIÇÃO: COMPARA AS COLUNAS DE UMA LISTA COM AS COLUNAS DE VARIAS LISTAS SE DER IGUAL
;;///            RETORNA UMA LISTA (LSTRETORNO)
;;/// ENTRADA: LT1(A B C D E F G) PRM1 (1 3 4) -> LTS2 ((A B E D E F G) (E B F D E J 8) (A B F D E E 8) (A B F D E J 8))
;;///          PRM2 - ( 1 2 5) -> NO RETORNO TEMO A LISTA (1 4 5)
;;/// SAIDA: O SISTEMA VAI VERIFICAR NA LISTA 2 QUEM SE ENCAIXA IGUAL NO PARAMENTRO PRM1 E PRM2, E RETORNAR.
;;///        A LISTA QUE ATENDE É (A B F D E E 8) - PORTANTO SEU RETORNO É = (B E E)
;;/// OBS: EXISTE A LIMITAÇÃO DE 4 ELEMENTOS DE COMPARAÇÃO

(DEFUN COMPARAR-LISTA-COM-RETORNO
       (LT1 PR1 LTS2 PR2 IRET / V1 V2 V3 V4 X2 VRX LSTRET CTRL LST)
  (SETQ	V1 (NTH (CAR PR1) LT1)
	V2 (NTH (CADR PR1) LT1)
	V3 (NTH (CADDR PR1) LT1)
	V4 (NTH (CADDDR PR1) LT1)
  )
  (SETQ CTRL 1)
  (FOREACH X2 LTS2
    (IF	CTRL
      (PROGN
	(IF (AND
	      (= V1 (NTH (CAR PR2) X2))
	      (= V2 (NTH (CADR PR2) X2))
	      (= V3 (NTH (CADDR PR2) X2))
	      (= V4 (NTH (CADDDR PR2) X2))
	    )
	  (SETQ LST (SUB-LIST-FIM X2 IRET))
	)
      )
    )
  )
  (SETQ LST LST)
)









;;/// DESCRIÇÃO: SELECIONA TODOS OS ELEMENTOS DE UMA CATEGORIA SOLICITADA
;;/// ENTRADA: CATEGORIA
;;/// SAIDA: SELEÇÃO COM ELEMENTOS
(DEFUN SELEC_ALL (ARG340 / SELECAO_340)

					;(SSGET "x" '((-3 ("cabobt"))))

  (COND

    ((= ARG340 "CABOBT") (SSGET "x" '((-3 ("cabobt")))))
    ((= ARG340 "CABOAT") (SSGET "x" '((-3 ("caboat")))))
    ((= ARG340 "CABO")
     (ssget "x"
	    '((-4 . "<OR") (-3 ("cabobt")) (-3 ("caboat")) (-4 . "OR>"))
     )
    )
    ((= ARG340 "CLIENTE") (SSGET "x" '((-3 ("cliente")))))
    ((= ARG340 "POLYLINE") (SSGET "x" '((0 . "LWPOLYLINE"))))
    ((= ARG340 "TEXTOPONTO") (SSGET "x" '((-3 ("textoponto")))))
    ((= ARG340 "PONTO") (SSGET "x" '((-3 ("ponto")))))
    ((= ARG340 "ATERRAMENTO")
     (SSGET "x" '((-3 ("aterramento"))))
    )
    ((= ARG340 "CHAVEFUSIVEL")
     (SSGET "x" '((-3 ("chavefusivel"))))
    )
    ((= ARG340 "CHAVEFACA") (SSGET "x" '((-3 ("chavefaca")))))
    ((= ARG340 "LUMINARIA") (SSGET "x" '((-3 ("luminaria")))))
    ((= ARG340 "ESTAI") (SSGET "x" '((-3 ("estai")))))
    ((= ARG340 "PARA-RAIO") (SSGET "x" '((-3 ("para-raio")))))
    ((= ARG340 "AVULSO") (SSGET "x" '((-3 ("avulso")))))
    ((= ARG340 "SECC-ANEL") (SSGET "x" '((-3 ("secc-anel")))))
    ((= ARG340 "MARCADOR") (SSGET "x" '((-3 ("marcador")))))
    ((= ARG340 "TRAFO") (SSGET "x" '((-3 ("trafo")))))
    ((= ARG340 "GLV") (SSGET "x" '((-3 ("glv")))))
    ((= ARG340 "ELO") (SSGET "x" '((-3 ("elo")))))
    ((= ARG340 "ENCABECAMENTO")
     (SSGET "x" '((-3 ("encabecamento"))))
    )
    ((= ARG340 "SECCIONAMENTO")
     (SSGET "x" '((-3 ("seccionamento"))))
    )
    ((= 1 1) (alert "VER ROTINA SELEC_ALL"))
  )

)


;;;;;;*************************************** SOMENTE_OBJETO ***************************************
;;/// DESCRIÇÃO: SELECIONA SOMENTE O OBJETO - ASSOCIAÇÃO DXF O
;;/// ENTRADA: TIPO DO OBJETO - OU SEJA DO ELEMENTO SE É UM BLOCO, OU UM TEXTO, 
;;/// SAIDA: CONJUNTO DE SELEÇÃO COM SOMENTE ESSE TIPO DE OBEJETO.
(DEFUN SOMENTE_OBJETO
		      (ARG111	   TIPOOBJETO  /	   VAR01
		       VAR02	   VAR03       VAR04	   VAR05
		       VARTIPO	   SEL_OBJETO_LISTA
		      )
  (SETQ VAR01 0)
  (SETQ VAR02 (SSLENGTH ARG111))
  (while (> VAR02 VAR01)
    (SETQ VAR03	  (ssname ARG111 VAR01)
	  VAR04	  (entget VAR03)
	  VARTIPO (DXF 0 VAR04)
    )
    (IF	(/= VARTIPO TIPOOBJETO)
      (SSDEL VAR03 ARG111)
      (SETQ VAR01 (+ VAR01 1))
    )
    (SETQ VAR02 (SSLENGTH ARG111))
  )
  (IF (= (SSLENGTH ARG111) 0)
    (SETQ ARG111 NIL)
  )
  (SETQ SEL_OBJETO_LISTA ARG111)
)






;;;;;;*************************************** LISTA_ELM-COLUNA ************************************
;;/// DESCRIÇÃO: COLOCA EM UMA LISTA TODOS OS DADOS DE UMA COLUNA DE UM TIPO DE OBJETO
;; de todo o desenho - (PONTO, ATERRAMENTO,TRAFO...)
;;/// ENTRADA: O XDATA DO ELMENTO E A COLUNA ("TRAFO" 2)
;;/// SAIDA: LISTA COM OS ELMENTOS EM FORMA DE STRNG
(DEFUN LISTA_ELM_COLUNA	(TIPOXDATA COLUNA SELECAO /)
  (SETQ	L1  NIL
	VL2 NIL
  )
  (SETQ	SEL_XDATA_LISTA
	 (SOMENTE_XDATA
	   SELECAO
	   TIPOXDATA
	 )
  )
  (if SEL_XDATA_LISTA
    (progn
      (SETQ VL (1- (SSLENGTH SEL_XDATA_LISTA)))
      (WHILE (>= VL 0)
	(SETQ VAR04 (entget (SSNAME SEL_XDATA_LISTA VL)
			    (LIST (STRCASE TIPOXDATA 1))
		    )
	      DADOS (DXF (STRCASE TIPOXDATA 1) (DXF -3 VAR04))
	      VL2   (CDR (NTH COLUNA DADOS))
	)
	(IF (= L1 NIL)
	  (SETQ L1 (LIST VL2))
	  (SETQ L1 (APPEND L1 (LIST VL2)))
	)
	(SETQ VL (1- VL))
      )
    )
  )
  (SETQ L1 L1)
)



;;;;;;*************************************** ELM_COLUNA_DADO ************************************
;;/// DESCRIÇÃO: FILTRA A TABELA COLUNA DO ELEMENTO.
;;/// ENTRADA: O XDATA DO ELMENTO E A COLUNA ("TRAFO" 2)
;;/// SAIDA: LISTA COM OS ELMENTOS EM FORMA DE STRNG
(DEFUN ELM_COLUNA_DADO (XDATA ELM COLUNA / VAR04 DADOS VAR09 DADOS)
  (SETQ	VAR04 (entget ELM (LIST (STRCASE XDATA 1)))
	VAR09 (CAR (CAR (DXF -3 VAR04)))
	DADOS (DXF VAR09 (DXF -3 VAR04))
	VL2   (CDR (NTH COLUNA DADOS))
  )
  (SETQ VL2 VL2)
)


;;;;;;*************************************** ESCREV_ELM_COLUNA ***********************************
;;/// DESCRIÇÃO: ALTERA A COLUNA DO ELEMENTEO (XDATA) INSERINDO UM NOVO ELEMENTO NO LUGAR
;;/// ENTRADA: ELEMENTO A SER MODIFICADO; NOVO ELEMENTO A SER INSERIDO; POSIÇÃO DO ELMENTO NA TABELA.
;;/// SAIDA: ELEMENTO MODIFICADO
(DEFUN ESCREV_ELM_COLUNA
       (ELM NEW COLUNA XDATA / LISTANOVA CONTROLE VALORX EED)
  (SETQ	VAR04 (entget ELM (LIST (STRCASE XDATA 1)))
	VAR09 (CAR (CAR (DXF -3 VAR04)))
	DADOS (DXF VAR09 (DXF -3 VAR04))
  )
  (SETQ XDATA (STRCASE VAR09 1))
  (regapp XDATA)
  (setq listanova nil)
  (setq controle 0)
  (foreach valorx DADOS
    (progn
      (if (= controle COLUNA)
	(setq valorx (cons 1000 NEW))
      )

      (if (= listanova nil)
	(setq listanova (list valorx))
	(setq listanova (append listanova (list valorx)))
      )
      (setq controle (+ controle 1))
    )
  )
  (setq DADOS listanova)
  (setq	eed
	 (cons XDATA
	       DADOS
	 )
  )
  (setq
    ELM	(append	(entget ELM)
		(list (cons -3 (list eed)))
	)
  )
  (entmod ELM)
  (setq ELM nil)
)

;;;;;;*************************************** XTADA_TIPO_ELM *******************************************
;;/// DESCRIÇÃO: RETORNA O XDATA DO ELEMENTO
;;/// ENTRADA: ELEMETO
;;/// SAIDA: XTADA
(DEFUN XTADA_TIPO_ELM (ELM / VAR04 LST09 VLR1 XDATA XDATAESCOLHIDO)
  (SETQ	VAR04 (entget ELM '("*"))
	LST09 (DXF -3 VAR04)
  )
  (SETQ VLR1 0)
  (REPEAT (LENGTH LST09)
    (SETQ XDATA (STRCASE (CAR (NTH VLR1 LST09))))
    (IF	(MEMBER	XDATA
		(LIST "PONTO"	     "CABOBT"	    "CABOAT"
		      "MARCADOR"     "CLIENTE"	    "TRAFO"
		      "LUMINARIA"    "ATERRAMENTO"  "PARA-RAIO"
		      "ESTAI"	     "CHAVEFUSIVEL" "CHAVEFACA"
		      "AVULSO"	     "SECCIONAMENTO"
		      "GLV"	     "ELO"
		     )
	)
      (SETQ XDATAESCOLHIDO XDATA)
    )
    (SETQ VLR1 (1+ VLR1))
  )
  (SETQ XDATAESCOLHIDO XDATAESCOLHIDO)
)




;;;;;;*************************************** BUSC_DADOS_ELM_XDATA *************************************
;;/// DESCRIÇÃO: COLOCA EM UMA LISTA TODOS OS DADOS DO ELEMENTO
;;/// ENTRADA: ELEMENTO
;;/// SAIDA: LISTA COM OS DADOS, E VARIAVEIS UTEIS COMO VAR-PONTO, VAR-TIPO, VAR-NOME
(DEFUN BUSC_DADOS_ELM_XDATA (ELM XDATA / VAR04 VAR09 VL1 VL2 VLX LST)
  (SETQ	VAR04	   (entget ELM (LIST XDATA))
	DADOS	   (DXF (CAR (CAR (DXF -3 VAR04))) (DXF -3 VAR04))
	VAR-PONTO  (DXF 10 VAR04)
	VAR-PONTO2 (DXF 11 VAR04)
	VAR-TIPO   (DXF 0 VAR04)
	VAR-NOME   (DXF 2 VAR04)
	VAR-ANG	   (DXF 50 VAR04)
  )
  (SETQ LST NIL)
  (SETQ VL1 0)
  (REPEAT (LENGTH DADOS)
    (SETQ VLX (CDR (NTH VL1 DADOS)))
    (IF	(= LST NIL)
      (SETQ LST (LIST VLX))
      (SETQ LST (APPEND LST (LIST VLX)))
    )
    (SETQ VL1 (1+ VL1))
  )
  (SETQ LST LST)
)

;;;;;;*************************************** BUSC_LSTCOLUN_ELM *************************************
;;/// DESCRIÇÃO: BUSCA VARIAS DADOS (COLUNAS) DE UM MESMO DETERMINADO ELEMENTO SEGUINDO UMA ORDEM
;;/// ENTRADA: ELEMENTO A SER EXTRAIDO O DADO; LISTA COM COLUNAS  A SEREM EXTRAIDAS
;;/// SAIDA: O DADO REQUERIDO
(DEFUN BUSC_LSTCOLUN_ELM (ELM LST-ORDEM / VAR04 VAR09 DADOS VL2)
  (SETQ VLX NIL)

  (XTADA_TIPO_ELM ELM)
  (FOREACH X LST-ORDEM
    (SETQ VAR04	(entget ELM (LIST (XTADA_TIPO_ELM ELM)))
	  VAR09	(CAR (CAR (DXF -3 VAR04)))
	  DADOS	(DXF VAR09 (DXF -3 VAR04))
	  VL2	(CDR (NTH X DADOS))
    )
    (IF	(/= VLX NIL)
      (SETQ VLX (LIST VL2))
      (SETQ VLX (APPEND VL2 (LIST VL2)))
    )
  )
  (SETQ VLX VLX)
)



;;;;;;*************************************** DADOS_ELEM ******************************************
;;/// DESCRIÇÃO: EXTRAI TODOS OS DADOS DO ELEMENTO 
;;/// ENTRADA: TIPO XDATA E O ELEMENTO
;;/// SAIDA: VARIAVEIS COM OS VALORES DAS CARACTERISTICA DOS ELEMENTOS - EX SE TIPO XDATA = TRAFO - PREENCHE VARIAVIS REFERENTE A TRAFO
(DEFUN DADOS_ELEM (ELM TIPOXDATA /)
  (SETQ TIPOXDATA (STRCASE TIPOXDATA))
  (SETQ LSTVL (BUSC_DADOS_ELM_XDATA ELM TIPOXDATA))
					;(SETQ DADOS LSTVL)
;;;  (SETQ	VAR04 (entget ARG701 (LIST (STRCASE TIPOXDATA 1)))
;;;	DADOS (DXF (STRCASE TIPOXDATA 1) (DXF -3 VAR04))
;;;  )
  (COND	((= TIPOXDATA "PONTO")
	 (PROGN
	   (SETQ VAR-DADOS-PONTO DADOS
		 VAR-NUM-PONTO	 (NTH 0 LSTVL)
	   )
	 )
	)
	((= TIPOXDATA "TRAFO")
	 (PROGN	(SETQ
		  VAR-NUM-TRAFO	     (NTH 0 LSTVL)
		  VAR-NOME-TRAFO     (NTH 1 LSTVL)
		  VAR-TIPO-TRAFO     (NTH 2 LSTVL)
		  VAR-CIRCUITO-TRAFO (NTH 3 LSTVL)
		  VAR-CHAVE-TRAFO    (NTH 4 LSTVL)
		  VAR-CT-TRAFO	     (NTH 5 LSTVL)
		  VAR-PTATEND-TRAFO  (NTH 6 LSTVL)
		  VAR-CBATENDE-TRAFO (NTH 7 LSTVL)
		)
	 )
	)
	((= TIPOXDATA "CHAVEFUSIVEL")
	 (PROGN	(SETQ
		  VAR-CHAVEFUSIVEL-SEQ
		   (NTH 0 LSTVL)
		  VAR-CHAVEFUSIVEL-NOME
		   (NTH 1 LSTVL)
		  VAR-CHAVEFUSIVEL-TIPO
		   (NTH 2 LSTVL)
		  VAR-CHAVEFUSIVEL-PONTO
		   (NTH 3 LSTVL)
		  VAR-CHAVEFUSIVEL-CABOENT
		   (NTH 4 LSTVL)
		  VAR-CHAVEFUSIVEL-CABOSAIDA
		   (NTH 5 LSTVL)
		  VAR-CHAVEFUSIVEL-GRADE
		   (NTH 6 LSTVL)
		)
	 )
	)
	((= TIPOXDATA "CHAVEFACA")
	 (PROGN	(SETQ
		  VAR-CHAVEFACA-SEQ
		   (NTH 0 LSTVL)
		  VAR-CHAVEFACA-NOME
		   (NTH 1 LSTVL)
		  VAR-CHAVEFACA-TIPO
		   (NTH 2 LSTVL)
		  VAR-CHAVEFACA-PONTO
		   (NTH 3 LSTVL)
		  VAR-CHAVEFACA-CABOENT
		   (NTH 4 LSTVL)
		  VAR-CHAVEFACA-CABOSAIDA
		   (NTH 5 LSTVL)
		  VAR-CHAVEFACA-GRADE
		   (NTH 6 LSTVL)
		)
	 )
	)


	((= TIPOXDATA "GLV")
	 (PROGN	(SETQ
		  VAR-GLV-SEQ
				    (NTH 0 LSTVL)
		  VAR-GLV-NOME
				    (NTH 1 LSTVL)
		  VAR-GLV-TIPO
				    (NTH 2 LSTVL)
		  VAR-GLV-PONTO
				    (NTH 3 LSTVL)
		  VAR-GLV-CABOENT
				    (NTH 4 LSTVL)
		  VAR-GLV-CABOSAIDA
				    (NTH 5 LSTVL)
		  VAR-GLV-GRADE
				    (NTH 6 LSTVL)
		)
	 )
	)

	((= TIPOXDATA "TEXTOPONTO")
	 (PROGN	(SETQ
		  VAR-PT-TEXTOPONTO
		   (NTH 0 LSTVL)
		)
	 )
	)
	((= TIPOXDATA "CLIENTE")
	 (PROGN	(SETQ
		  VAR-NUM-CLIENTE
		   (NTH 0 LSTVL)
		  VAR-CARGA-CLT
		   (NTH 1 LSTVL)
		  VAR-QUADRA-CLT
		   (NTH 2 LSTVL)
		  VAR-LOTE-CLT
		   (NTH 3 LSTVL)
		  VAR-PTENTREGA-CLT
		   (NTH 4 LSTVL)
		  VAR-PTATENDIMENTO-CLT
		   (NTH 9 LSTVL)
		  VAR-CBATENDIMENTO-CLT
		   (NTH 10 LSTVL)
		  VAR-DEF-CIRCUITO
		   (NTH 11 LSTVL)
		)
	 )
	)
	((OR (= TIPOXDATA "CABOAT") (= TIPOXDATA "CABOBT"))
	 (PROGN	(SETQ
		  VAR-NUM-CABO
		   (NTH 0 LSTVL)
		  VAR-TENSAO-CABO
		   (NTH 1 LSTVL)
		  VAR-TIPO-CABO
		   (NTH 2 LSTVL)
		  VAR-NOME-CABO
		   (NTH 3 LSTVL)
		  VAR-CB-NIVELPONTOP10
		   (NTH 4 LSTVL)
		  VAR-CB-NIVELPONTOP11
		   (NTH 5 LSTVL)
		  VAR-CIRCUITO-CABO
		   (NTH 6 LSTVL)
		  SENTIDO-DE
		   (NTH 7 LSTVL)
		  SENTIDO-PARA
		   (NTH 8 LSTVL)
		  VAR-CB-PONTOP10
		   (NTH 9 LSTVL)
		  VAR-CB-PONTOP11
		   (NTH 10 LSTVL)
		)
		(SETQ LISTA-PONTOS-CABO (PONTOS_POLYLINE2 ELM))
	 )
	)
  )
)

;;;; ***************************************** INS_ELM_NO_PTO ********************************
;;;; DESCRIÇÃO: INSERE ELEMENTO NO PROJETO ESCREVENDO SUAS E TABELAS XDATAS
;;;; ENTRADA: PRR1:SELEÇÃO DE PTS PRR2: XDATA PRR3: LST EM QUADRO PRR4:LISTA A SER ACRESCENTADA
;;;; PRR5: NOME DO BLOCO UNICO OU NIL PARA VARIOS BLOCOS PRR6:PAUSAR A INSERIR BLOCO (1(SIM) OU 2)
;;;; SAIDA: INSERE O BLOC COM OS DADOS CADASTRADOS
(DEFUN INS_ELM_NO_PTO
		      (SEL	XDATACTRL	  LST-1	   LST-2
		       NM-BLC	PAUSE-BLC	  /	   V-NM
		       V-TP	QD-PT	 V-SEQ	  V-TP	   ELM
		       NM-PT	L1	 VAR-PONTO	   VAR-ANG
		       BL1	LST-ESCR
		      )
  (setq	V-NM  (CAR LST-1)
	V-TP  (CADR LST-1)
	QD-PT (SSLENGTH SEL)
  )
  (WHILE (> QD-PT 0)
    (SETQ V-SEQ	    (LOCALIZAR_SEQ XDATACTRL)
	  ELM	    (SSNAME SEL (- QD-PT 1))
	  NM-PT	    (BUSC_COLUN_ELM ELM 0 "PONTO")
	  L1	    (BUSC_DADOS_BLOCO ELM)
	  VAR-PONTO (CAR L1)
	  VAR-ANG   (CADDR L1)
    )

    (IF	LST-2
      (SETQ LST-ESCR (APPEND (LIST V-SEQ) LST-1 (LIST NM-PT) LST-2))
      (SETQ LST-ESCR (APPEND (LIST V-SEQ) LST-1 (LIST NM-PT)))
    )
    (IF	(= NM-BLC NIL)
      (SETQ BL1 V-NM)
      (SETQ BL1 NM-BLC)
    )
    (INSERE_BLOCO
      V-TP
      ;;tipo bloco
      BL1
      ;; nome bloco
      XDATACTRL
      ;;xdata
      VAR-PONTO
      ;; ponto a inserir
      PAUSE-BLC
      ;; utilizar o pause ao inserir
      VAR-ANG
      ;; angulo a inserir
      LST-ESCR
      ;; lista para escrever
)
    (SETQ QD-PT (- QD-PT 1))
  )
)




;;;;;;*************************************** BUSC_DADOS_BLOCO **************************************
;;/// DESCRIÇÃO: RETORNA DADOS DE UM BLOCO
;;/// ENTRADA: ELEMENTO
;;/// SAIDA: LISTA COM PONTO, NOME, E ANGULO DO BLOCO
(DEFUN BUSC_DADOS_BLOCO	(ELM / L1 V1)
  (SETQ V1 (entget ELM))
  (SETQ L1 (LIST (DXF 10 V1) (DXF 2 V1) (DXF 50 V1)))
)




;;;;;*********************************** ANG_TRES_PONTOS ******************************************
;;/// DESCRIÇÃO: RETORNA ANGULO ENTRE TRES PONTOS
;;/// ENTRADA: PT1 PT2 PT3
;;/// SAIDA: ANGULO
(defun ANG_TRES_PONTOS (p1 p2 p3)
  ((lambda (a) (min a (- (+ pi pi) a)))
    (rem (+ pi pi (- (angle p2 p1) (angle p2 p3))) (+ pi pi))
  )
)

;; ESHOP*ANG_INTERS_3
;; DESCRIÇÃO: ANGULO INTERSECÇÃO TRES PONTOS
;; ENTRADA: ENTRADA PONTOS P1 E P2 (LINHA), E UM PONTO P3 QUALQUER,
;; SAIDA: ANGULO PX3 E INTERSECÇÃO PX1 E PX2
(defun ESHOP-ANG_INTERS_3 (px1 px2 px3 / px4)
  (setq	px4 (inters px1
		    px2
		    px3
		    (polar px3 (+ (angle px1 px2) (/ pi 2)) 50)
		    nil
	    )
  )
  (list px4 (+ (angle px3 px4) (/ PI 2)))
)


;;;XXX VER NECESSIDADE DESTA ROTINA - VER COMANDO PC (MC)
;;;<> ESHOP-VER_ELM_DUP_PTO
;;;++ DESCRIÇÃO: VERIFICA SE NO PONTO EXISTE ELEMENTO (XDATA) DUPLICADO
;;;++ ENTRADA: xdt1:XDATA ;  pto1:ponto a ser verificado
;;;++ SAIDA: se existir duplicados retorna 1 se não nil
(defun ESHOP-VER_ELM_DUP_PTO (xdt1 pto1 rai1 /)
  (setvar "OSMODE" 0)
  (if (/= (ESHOP-RTN_ELM_XDT_SEL
	    (ESHOP-RTN_SEL_PTO pto1 rai1 nil)
	    xdt1
	  )
	  nil
      )
    1
    nil
  )
)

;;;;;selecionar xdata
;;;;(setq sel1 (ssget (list (list -3 (list "marcador")))))




(defun criapasta (NOMEPASTA LOCAL /)
  ;; VERIFICA SE NO LOCAL DO ARQUIVO EXISTE UMA PASTA TABELAS, SE SIM ESCREVE DENTRO DELA SE NÃO, CRIA E  ESCREVE DENTRO DELA
  (IF (VL-FILE-DIRECTORY-P LOCAL)
    (setq localnome LOCAL)
    (VL-MKDIR (STRCAT (GETVAR "DWGPREFIX") NOMEPASTA))

  )
)






;;/// DESCRIÇÃO: SELEÇÃO DE BLOCOS POR CATEGORIA - FACILITANDO NA ROTINA
;;/// ENTRADA: TIPO DE CATEGORIA EX: PONTO, POLYLINE...
;;/// SAIDA: GRUPO DE SELEÇÃO
(DEFUN SELEC_TIPO (ARG339 / SEL_PT_TIPO)

  (SETQ ARG339 (STRCASE ARG339))
  (IF (= ARG339 "PONTO")
    (SETQ SEL_PT_TIPO
	   (ssget '((-4 . "<and")
		    (-3 ("ponto"))
		    (-4 . "<not")
		    (2 . "FLYTAP")
		    (-4 . "not>")
		    (-4 . "and>")
		   )
	   )
    )
  )
  (IF (= ARG339 "PONTO-CABO")
    (SETQ SEL_PT_TIPO
	   (ssget '((-4 . "<and")
		    (-3 ("ponto"))

		    (-4 . "<not")
		    (2 . "DTRET")
		    (-4 . "not>")

		    (-4 . "<not")
		    (2 . "CCRET")
		    (-4 . "not>")

		    (-4 . "<not")
		    (2 . "MRET")
		    (-4 . "not>")

		    (-4 . "<not")
		    (2 . "2XDTRET")
		    (-4 . "not>")

		    (-4 . "<not")
		    (2 . "2XCCRET")
		    (-4 . "not>")
		    (-4 . "and>")
		   )
	   )
    )
  )
  (IF (= ARG339 "MARCADOR")
    (SETQ SEL_PT_TIPO
	   (SSGET '((-3 ("marcador"))))
    )
  )
  (IF (= ARG339 "CABOBT")
    (SETQ SEL_PT_TIPO
	   (SSGET '((-3 ("cabobt"))))
    )
  )
  (IF (= ARG339 "CABOAT")
    (SETQ SEL_PT_TIPO
	   (SSGET '((-3 ("caboat"))))
    )
  )

  (IF (= ARG339 "CABO")
    (SETQ SEL_PT_TIPO
	   (SSGET
	     '((-4 . "<OR") (-3 ("cabobt")) (-3 ("caboat")) (-4 . "OR>"))
	   )
    )
  )
  (IF (= ARG339 "LUMINARIA")
    (SETQ SEL_PT_TIPO
	   (SSGET '((-3 ("luminaria"))))
    )
  )

  (IF (= ARG339 "CLIENTE")
    (SETQ SEL_PT_TIPO
	   (SSGET '((-3 ("cliente"))))
    )
  )
  (IF (OR (= ARG339 "POLYLINE"))
    (SETQ SEL_PT_TIPO
	   (SSGET '((-4 . "<OR")
		    (0 . "LWPOLYLINE")
		    (-4 . "OR>")
		   )
	   )
    )
  )
  (IF (= ARG339 "TRAFO")
    (SETQ SEL_PT_TIPO
	   (SSGET '((-3 ("trafo"))))
    )
  )
  (SETQ SEL_PT_TIPO SEL_PT_TIPO)
)



(defun apagar-txelm-igual (pt xdata txnum / sel1 q elm)
					;(eshop-zom_rai pt 200)
  (setq sel1 (somente_xdata (selecao_ponto pt 200) xdata))
  (if (/= sel1 nil)
    (progn
      (setq q (sslength sel1))
      (while (> q 0)
	(setq elm (ssname sel1 (- q 1)))
	(if (= (busc_colun_elm elm 0 xdata) txnum)
	  (entdel elm)
	)
	(setq q (- q 1))
      )
    )
  )
  (command "zoom" "p")
)

;; VERIFICA SE ESTA IGUAL AS LISTAS DE DADOS E O TITULO.
(defun VERIFICAPADRAO (lstx lsty titulo /)
  (setq int1 0)
  (foreach y lsty
    (setq int2 0)
    (FOREACH W Y
      (if (/= (vl-position W titulo) int2)
	(progn

	  (ALERT
	    (STRCAT
	      "APARECEU ORDEM DE DADOS DIRERENTES DAS TABELAS INICIAIS DO ELEMENTO: "
	      x
	    )
	  )
	)
      )
      (setq int2 (1+ int2))
    )
    (setq int1 (1+ int1))
  )
)


;;;;;;;;;*************************************** SUBST-ELEM-LISTA ************************************
;;;;;/// DESCRIÇÃO: SUBSTITUIR ELENTO EM UMA LISTA
;;;;;/// ENTRADA: O NOVO ELEMENTO DA LISTA; A SEQUENCIA QUE E PARA ALTERAR; E A LISTA
;;;;;/// SAIDA: LISTA COM O ELEMENTO ALTERADO
;;;(DEFUN SUBST-ELEM-LISTA	(new N lst / result)
;;;  (cond	((or (< N 0) (>= N (length lst))) lst)
;;;	((< N (/ (length lst) 2))
;;;	 (repeat n
;;;	   (setq result	(cons (car lst) result)
;;;		 lst	(cdr lst)
;;;	   )
;;;	 )
;;;	 (append (reverse result) (list new) (cdr lst))
;;;	)
;;;	(t
;;;	 (setq lst (reverse lst))
;;;	 (repeat (- (length lst) n)
;;;	   (setq result	(cons (car lst) result)
;;;		 lst	(cdr lst)
;;;	   )
;;;	 )
;;;	 (append (reverse lst) (list new) (cdr result))
;;;	)
;;;  )
;;;					;(SETQ LST LST)
;;;)