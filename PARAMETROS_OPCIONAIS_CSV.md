# Parâmetros opcionais para preencher no CSV (MATRIZ_NOVA)

A validação de "dados gerais" foi **desativada** para o fluxo ASBUILT/MATRIZ_NOVA, pois essas colunas não existem no formato atual.

Caso deseje preencher manualmente no CSV para uso futuro ou compatibilidade, estes são os parâmetros que eram solicitados:

---

## Parâmetros que eram validados (não exigidos no MATRIZ_NOVA)

| Parâmetro | Coluna no CSV antigo | Valor sugerido | Descrição |
|-----------|----------------------|----------------|-----------|
| **TIPO** | TIPO | ASBUILT | Tipo: "projeto" ou "ASBUILT" |
| **Número do Projeto** | PROJETO | 1 (ou número desejado) | Número do projeto |
| **Nome do cliente** | CLIENTE | (texto) | Nome do cliente |
| **CAD único** | CAD_UNICO | SIM ou NÃO | Se o projeto é CAD único |
| **Município** | MUNICIPIO | (já existe em MATRIZ_NOVA) | Nome do município - **municipio** no MATRIZ_NOVA |
| **Telefone do cliente** | CLT_TELEFONE | (número) | Telefone do cliente |

---

## Outros parâmetros (conforme módulo)

| Parâmetro | Coluna | Quando solicitado |
|-----------|--------|-------------------|
| **Inscrição / Solicitação** | INSCRICAO | SS ligação nova |
| **Parceira projeto** | PARCEIRA_PROJETO | Se módulo exige |
| **Parceira construção** | PARCEIRA_CONSTRUCAO | Se módulo exige |
| **UC Sensível** | UC_SENSIVEL | SIM ou NÃO (área ambiental) |

---

## Observação

O MATRIZ_NOVA **já possui** a coluna `municipio`, que é utilizada na conversão. Os demais parâmetros não existem no formato MATRIZ_NOVA e a validação foi desativada para permitir o fluxo de desenho sem essas informações.
