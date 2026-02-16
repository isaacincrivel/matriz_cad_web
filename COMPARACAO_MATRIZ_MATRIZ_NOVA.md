# Comparação MATRIZ.csv (antigo) x MATRIZ_NOVA.csv

## Diferenças de Estrutura

| Aspecto | MATRIZ.csv (antigo) | MATRIZ_NOVA.csv |
|---------|---------------------|-----------------|
| **Delimitador** | Ponto e vírgula (;) | Ponto e vírgula (;) |
| **Separador decimal** | Ponto (.) | Vírgula (,) |
| **Linhas por poste** | 1 linha por poste | 4 linhas por poste (implantar, existente, retirar, deslocar) |
| **Coordenadas** | COORD_X, COORD_Y (inteiros, UTM) | utm_x, utm_y (decimais, UTM) + lat, long (graus decimais) |
| **Dados gerais** | Linha 0 com metadados (CLIENTE, PROJETO, etc.) | Ausentes ou em colunas por linha |
| **Coluna adicional** | — | **azimute** (graus) - orientação do poste |

---

## Correlações Diretas (MATRIZ.csv → MATRIZ_NOVA.csv)

| MATRIZ.csv (antigo) | MATRIZ_NOVA.csv | Observação |
|--------------------|-----------------|------------|
| **SEQ** | **sequencia** | Identificação do poste (1, 2, 3...) |
| **NM_POSTE** | **num_poste** | Número/identificação do poste |
| **POSTE** | **tipo_poste** | Tipo: PDT10/300, EXIST, etc. *(MATRIZ_NOVA: DT10/300)* |
| **ESTRUTURA** | **estru_mt_nv1** / estru_mt_nv2 / estru_mt_nv3 | Estrutura MT - usar primeira não vazia |
| — | **est_bt_nv1** / est_bt_nv2 | Estrutura BT (novo no MATRIZ_NOVA) |
| **ESTAI_ANCORA** | **estai_ancora** | Ex: 1ED, 1ES, 2ED |
| **BASE_REFORCADA** | **base_reforcada** | 1 ou vazio |
| **BASE_CONCRETO** | **base_concreto** | 1 ou vazio |
| **ATERR_NEUTRO** | **aterr_neutro** | 1 ou vazio |
| **CHAVE** | **chave** | Tipo de chave |
| **RAMAL_CASA** | — | Não existe em MATRIZ_NOVA |
| **COORD_X** | **utm_x** | Coordenada UTM X *(formato: "194859,57")* |
| **COORD_Y** | **utm_y** | Coordenada UTM Y *(formato: "8250757,85")* |
| — | **lat** | Latitude (graus decimais) - apenas em MATRIZ_NOVA |
| — | **long** | Longitude (graus decimais) - apenas em MATRIZ_NOVA |
| **FAIXA** | **faixa** | Faixa de segurança (ex: 23) |
| **CORTE_ARVORE** | **cort_arvores_isol** | Corte de árvores isoladas |
| **CAVA_ROCHA** | — | Não encontrado em MATRIZ_NOVA |
| **CT_TRAFO** | **trafo** | Transformador |
| **RESISTENCIA_OHM** | — | Não encontrado em MATRIZ_NOVA |
| **MEDIDOR** | — | Não encontrado em MATRIZ_NOVA |
| **VAO_FROUXO** | — | Não encontrado em MATRIZ_NOVA |
| **MODULO_PROJETO** | — | Não existe; usar valor fixo (ex: MT7) |
| **CLIENTE** | — | Não existe em MATRIZ_NOVA |
| **INSCRICAO** | — | Não existe em MATRIZ_NOVA |
| **PROJETO** | — | Não existe em MATRIZ_NOVA |
| **PARCEIRA_PROJETO** | — | Não existe em MATRIZ_NOVA |
| **PARCEIRA_CONSTRUCAO** | — | Não existe em MATRIZ_NOVA |
| **MUNICIPIO** | **municipio** | Nome do município |
| **TENSAO** | — | Não existe; usar valor fixo (ex: 15) |
| **FUSO** | **fuso** | Fuso UTM (ex: 23) |
| **KIT_INTERNO** | — | Não encontrado em MATRIZ_NOVA |
| **TIPO** | — | Não existe; usar "ASBUILT" |
| **CLT_TELEFONE** | — | Não existe em MATRIZ_NOVA |
| **UC_SENSIVEL** | — | Não existe em MATRIZ_NOVA |
| **SUPRESSAO_VEGETAL** | — | Não existe em MATRIZ_NOVA |
| **CAD_UNICO** | — | Não existe em MATRIZ_NOVA |
| **FINAN_PAD** | — | Não existe em MATRIZ_NOVA |
| **DISTRIBUIDORA** | — | Não existe em MATRIZ_NOVA |
| **LINHA_VIVA** | — | Não existe em MATRIZ_NOVA |
| **ACESSO_LOCAL** | — | Não existe em MATRIZ_NOVA |
| **CARGA_INSTALADA** | — | Não existe em MATRIZ_NOVA |
| **TIPO_PI** | — | Não existe em MATRIZ_NOVA |
| **CERCA_01/02/03** | — | Não encontrado em MATRIZ_NOVA |

---

## Colunas Exclusivas do MATRIZ_NOVA.csv

| Coluna | Descrição | Uso |
|--------|-----------|-----|
| **deriva** | Identificador de derivação | Vazio nas linhas analisadas |
| **status** | implantar / existente / retirar / deslocar | Usar para filtrar linhas desenhadas |
| **CB_1A ... CB_BT3** | Condutores/bitolas (ex: 10103) | Detalhamento de cabos |
| **equipamento** | TOPO1, TOPO2, BISS1, etc. | Tipo de equipamento no poste |
| **rotacao_poste** | — | Campo presente mas sem valores na amostra |
| **azimute** | Ângulo em graus (ex: 161,4) | Orientação do poste para desenho |
| **adiconal_1 a 7** / **qdt_adic_1 a 7** | Itens adicionais e quantidades | Detalhamento orçamentário |

---

## Resumo das Principais Diferenças

1. **Formato decimal**: MATRIZ antigo usa ponto (707642), MATRIZ_NOVA usa vírgula (194859,57).

2. **Estrutura de linhas**: MATRIZ antigo usa 1 linha por poste; MATRIZ_NOVA usa 4 linhas por poste (implantar, existente, retirar, deslocar), com dados de desenho apenas na linha `implantar`.

3. **Tipo de poste**: MATRIZ antigo usa PDT10/300; MATRIZ_NOVA pode usar DT10/300 (precisa adicionar “P”).

4. **Metadados do projeto**: MATRIZ antigo concentra CLIENTE, PROJETO, INSCRICAO etc. na linha 0; MATRIZ_NOVA não possui essas colunas.

5. **Orientação do poste**: MATRIZ antigo não tem ângulo; MATRIZ_NOVA traz `azimute` para rotação do poste.

6. **Coordenadas**: MATRIZ antigo traz só UTM; MATRIZ_NOVA traz UTM (utm_x, utm_y) e lat/long.

7. **Estrutura MT/BT**: MATRIZ antigo tem apenas ESTRUTURA; MATRIZ_NOVA separa estru_mt_nv1/2/3 e est_bt_nv1/2.
