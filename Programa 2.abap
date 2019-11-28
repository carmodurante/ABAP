**Programa 2** TABLES
*&---------------------------------------------------------------------*
*& Report ZC00103 *
*& *
*&---------------------------------------------------------------------*
*& *    TABLES SELECT DATA REFRESH CLEAR LOOP LINE-SIZE LINE-COUNT PARAMETERS
*SORT READ TABLE
*& *
*&---------------------------------------------------------------------*
REPORT ZC00103 LINE-SIZE 130 LINE-COUNT 65.
* LINE-SIZE = COLUNAS
* LINE-COUNT = LINHAS POR PAGINA
TABLES : MARC, T001W.
DATA : BEGIN OF T_MARC OCCURS 0,
MATNR LIKE MARC-MATNR,
WERKS LIKE MARC-WERKS,
NAME1 LIKE T001W-NAME1,
MAKTX LIKE MAKT-MAKTX,
END OF T_MARC.
DATA : BEGIN OF T_001W OCCURS 0,
WERKS LIKE T001W-WERKS,
NAME1 LIKE T001W-NAME1,
END OF T_001W.
DATA : BEGIN OF T_MAKT OCCURS 0,
MATNR LIKE MAKT-MATNR,
MAKTX LIKE MAKT-MAKTX,
END OF T_MAKT.
DATA wcor TYPE C.
* O COMANDO PARAMETERS serve para colocar um parametro de seleção PARAMETERS
nome_do_parametro LIKE tabela_interna.
* PARAMETERS P_WERKS LIKE T_001W-WERKS.
* O comando SELECT-OPTIONS funciona como o comando PARAMETERS SELECT-OPTIONS variável FOR
campo da tabela DEFAULT valor_inicial
SELECT-OPTIONS P_WERKS FOR T_001W-WERKS DEFAULT '0050'.
REFRESH T_MARC.
CLEAR T_MARC.
* SELECIONAR material e centro PARA PARAMETERS podemos usar o sinal de =
* SELECT matnr werks INTO TABLE t_marc FROM MARC WHERE werks = P_WERKS.
* SELECIONAR material e centro PARA SELECT-OPTIONS usar IN
SELECT matnr werks INTO TABLE t_marc FROM MARC WHERE werks IN P_WERKS.
* ORDENAR PRIMEIRO A TABELA PARA PODER USAR [BINARY SEARCH] EM READ TABLE
SORT t_marc BY werks.
* SELECIONAR material e a descrição
SELECT matnr maktx INTO TABLE t_makt FROM MAKT WHERE SPRAS = 'PT'.
* ORDENAR PRIMEIRO A TABELA PARA PODER USAR [BINARY SEARCH] EM READ TABLE
SORT t_makt BY matnr.
* SELECIONAR centro e nome centro
SELECT werks name1 INTO TABLE t_001w FROM T001W.
LOOP AT T_MARC.
* PARA LER UMA TABELA INTERNA2 USAR READ TABLE
* tabela interna1 WITH KEY campo da tabela interna1
* igual ao campo da TABELA INTERNA2
* BINARY SEARCH -> DEIXA A PESQUISA MAIS RAPIDA.
READ TABLE T_001W WITH KEY werks = t_marc-werks BINARY SEARCH.
* SY-SUBRC se voltar ZERO encontrou na Tabela
IF sy-subrc eq 0.
t_marc-name1 = T_001W-name1.
ELSE.
t_marc-name1 = ' '.
ENDIF.
* PARA ATUALIZAR A TABELA INTERNA MODIFY tabela interna2
MODIFY t_marc.
ENDLOOP.
LOOP AT T_MARC.
* PARA LER UMA TABELA INTERNA2 USAR READ TABLE
* tabela interna1 WITH KEY campo da tabela interna1
* igual ao campo da TABELA INTERNA2
* BINARY SEARCH -> DEIXA A PESQUISA MAIS RAPIDA.
READ TABLE T_MAKT WITH KEY matnr = t_marc-matnr BINARY SEARCH.
* SY-SUBRC se voltar ZERO encontrou na Tabela
IF sy-subrc eq 0.
t_marc-maktx = T_makt-maktx.
ELSE.
t_marc-maktx = ' '.
ENDIF.
* PARA ATUALIZAR A TABELA INTERNA MODIFY tabela interna2
MODIFY t_marc.
ENDLOOP.
* PARA ORDENAR A TABELA INTERNA. SORT tabela_interna BY campo
SORT t_marc BY maktx ASCENDING.
WRITE 5 'MATERIAL'.
WRITE 20 'Descrição'.
WRITE 70 'Cód '.
WRITE 80 'CENTRO'.
ULINE.
LOOP AT T_MARC.
IF wcor EQ 'I'.
FORMAT COLOR COL_POSITIVE.
wcor = 'X'.
ELSE.
FORMAT COLOR COL_NEGATIVE.
wcor = 'I'.
ENDIF.
WRITE 5 T_MARC-MATNR.
WRITE 20 T_MARC-MAKTX.
WRITE 70 T_MARC-WERKS.
WRITE 80 T_MARC-NAME1.
SKIP 1.
ENDLOOP.