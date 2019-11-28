**Programa 3** SELECTION-SCREENSELECTION-SCREEN
"SELECTION-OPTIONS
"SELECT INTO TABLE
"SELECT INTO TABLE INNER JOIN
"INITIALIZATION
"START-OF-SELECTION
"END-OF-SELECTION
*&---------------------------------------------------------------------*
*& Report ZC00106 *
*& *
*&---------------------------------------------------------------------*
*& * SELECTION-SCREEN
*& *
*&---------------------------------------------------------------------*
REPORT ZC00104 LINE-SIZE 130 LINE-COUNT 65.
TABLES : MARC, T001W.
DATA : BEGIN OF T_MARC OCCURS 0,
MATNR LIKE MARC-MATNR,
WERKS LIKE MARC-WERKS,
NAME1 LIKE T001W-NAME1,
MAKTX LIKE MAKT-MAKTX,
END OF T_MARC.
DATA : BEGIN OF T_001 OCCURS 0,
WERKS LIKE T001W-WERKS,
END OF T_001.
REFRESH : T_MARC.
CLEAR : T_MARC.
* PARA CRIAR UM BOX NA JANELA
* SELECTION-SCREEN BEGIN OF BLOCK nome_do_bloco WITH FRAME TITLE
* nome_do_elemento_de_texto
* -> DEPOIS COLOCAR OS SELECT-OPTIONS ( variáveis )
* FECHAR COM : SELECTION-SCREEN END OF BLOCK nome_do_bloco
* clicar duas vezes sobre o nome_do_bloco para colocar o nome
* que ira aparecer na tela
SELECTION-SCREEN BEGIN OF BLOCK b_janela WITH FRAME TITLE text-001.
SELECT-OPTIONS S_MATERI FOR T_MARC-MATNR.
SELECT-OPTIONS S_CENTRO FOR T_MARC-WERKS.
SELECTION-SCREEN END OF BLOCK b_janela.
* COMANDO PARA INICIALIZAÇÃO DE VARIAVEL
INITIALIZATION.
* seleciona o CAMPO_que_iremos tratar INTO TABLE
* tabela_interna FROM tabela_de_onde_vira os dados
SELECT werks INTO TABLE t_001 FROM t001w.
* LIMPA A TABELA DE VARIAVEL
REFRESH S_CENTRO.
* LOOP DA TABELA INTERNA
LOOP AT T_001.
* LIMPA A VARIAVEL
clear S_CENTRO.
* iguala SIGN a I e OPTION a EQ
s_centro-sign = 'I'.
s_centro-option = 'EQ'.
* COLOCAR O VALOR do campo
s_centro-low = t_001-werks.
* atualiza a tabela.
APPEND S_CENTRO.
ENDLOOP.
* EVENTO DE EXTRAÇÃO DE DADOS - ANTES DA SELEÇÃO
START-OF-SELECTION.
* USO DE INNER JOIN
* SELECT campos_das_tabelas que contem os dados
* INTO TABLE nome_da_tabela que ira guardar os dados
* FROM tabela principal para fazer o join
* INNER JOIN tabela secundária para fazer o join com o from
* ON condição de ligação do JOIN
* WHERE condições
SELECT marc~matnr marc~werks t001w~name1 makt~maktx
INTO TABLE t_marc
FROM marc
INNER JOIN t001w ON marc~werks = t001w~werks
INNER JOIN makt ON marc~matnr = makt~matnr
and makt~spras = sy-langu
WHERE t001w~werks IN S_CENTRO
AND marc~matnr IN S_MATERI.
*WRITE 5 'MATERIAL'.
*WRITE 18 'Descrição'.
*WRITE 60 'Centro'.
*WRITE 80 'Descrição'.
*ULINE.
* EVENTO PARA EXIBIR OS DADOS
END-OF-SELECTION.
LOOP AT T_MARC.
WRITE 5 T_MARC-MATNR.
WRITE 18 T_MARC-MAKTX.
WRITE 60 T_MARC-WERKS.
WRITE 80 T_MARC-NAME1.
SKIP 1.
ENDLOOP.