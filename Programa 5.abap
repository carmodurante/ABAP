*Programa 5 APPEND
*&---------------------------------------------------------------------*
*& Report ZC00108 *
*& *
*&---------------------------------------------------------------------*
*& *
*& **   APPEND
*&---------------------------------------------------------------------*
REPORT ZC00108 LINE-SIZE 200 LINE-COUNT 65 NO STANDARD PAGE HEADING
MESSAGE-ID Z01.
TABLES : MARC, MARD, T001L, T001W.
* para fazer a quebra do relatório por centro, este deve ser o primeiro
* da tabela interna.
* no SELECT ... INNER JOIN os campos devem sempre seguir a seqüência da
* tabela interna.
DATA : BEGIN OF T_MARC OCCURS 0,
WERKS LIKE MARC-WERKS,
MATNR LIKE MARC-MATNR,
NAME1 LIKE T001W-NAME1,
MAKTX LIKE MAKT-MAKTX,
LGORT LIKE MARD-LGORT,
LFGJA LIKE MARD-LFGJA,
LFMON LIKE MARD-LFMON,
LABST LIKE MARD-LABST,
SPEME LIKE MARD-SPEME,
END OF T_MARC.
DATA : BEGIN OF T_001 OCCURS 0,
WERKS LIKE T001W-WERKS,
END OF T_001.
REFRESH : T_MARC.
CLEAR : T_MARC.
SELECTION-SCREEN BEGIN OF BLOCK b_janela WITH FRAME TITLE text-001.
SELECT-OPTIONS S_MATERI FOR T_MARC-MATNR.
SELECT-OPTIONS S_CENTRO FOR T_MARC-WERKS.
SELECT-OPTIONS S_DEPOSI FOR T_MARC-LGORT.
SELECT-OPTIONS S_ANO FOR T_MARC-LFGJA.
SELECT-OPTIONS S_MES FOR T_MARC-LFMON.
SELECTION-SCREEN END OF BLOCK b_janela.
INITIALIZATION.
PERFORM F_SELECIONAR.
AT SELECTION-SCREEN ON s_materi.
AT SELECTION-SCREEN ON s_deposi.
PERFORM F_BUSCAR_MATERIAL.
TOP-OF-PAGE.
PERFORM F_CABECA.
END-OF-PAGE.
START-OF-SELECTION.
PERFORM F_BUSCAR_DADOS.
END-OF-SELECTION.
PERFORM F_MOSTRAR_DADOS.
* o comando AT LINE-SELECTION é um evento que serve para
* quando clicarmos em uma linha de relatório abrir uma outra
* janela e mostrarmos outros dados
AT LINE-SELECTION.
* IF NOT var IS INITIAL -> verifica se o header line esta vazio
* se não for vazio imprime a tela de detalhes
IF NOT T_MARC IS INITIAL.
* SET TITLEBAR 'var' mostra o titulo da nova tela
SET TITLEBAR 'DET'.
* SY-ULINE -> imprime linha com comprimento fixo
WRITE SY-ULINE(83).
* SY-VLINE -> serve para fazer fechamento de bordas
WRITE / SY-VLINE.
WRITE :'Material : '.
WRITE : T_MARC-MATNR,' - ', t_marc-maktx,' '.
WRITE 83 SY-VLINE.
WRITE / SY-VLINE.
WRITE :'Centro : '.
WRITE : T_MARC-werks, ' - ', t_marc-name1,' '.
WRITE 83 SY-VLINE.
WRITE /:SY-VLINE.
WRITE :'Deposito : '.
WRITE : T_MARC-lgort.
WRITE 83 SY-VLINE.
WRITE /:SY-VLINE.
WRITE :'Disponível : '.
WRITE : T_MARC-labst.
WRITE 83 SY-VLINE.
WRITE /:SY-VLINE.
WRITE : 'Bloqueado : '.
WRITE : T_MARC-SPEME.
WRITE 83 SY-VLINE.
WRITE / SY-ULINE(83).
ENDIF.
* depois de listar a nova informação devemos limpar o header line da
* tabela
CLEAR T_MARC.
*&---------------------------------------------------------------------*
*& Form F_SELECIONAR
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_SELECIONAR .
SELECT werks INTO TABLE t_001 FROM t001w.
REFRESH S_CENTRO.
LOOP AT T_001.
clear S_CENTRO.
s_centro-sign = 'I'.
s_centro-option = 'EQ'.
s_centro-low = t_001-werks.
APPEND S_CENTRO.
ENDLOOP.
ENDFORM. " F_SELECIONAR
*&---------------------------------------------------------------------*
*& Form F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_BUSCAR_DADOS .
SELECT marc~werks marc~matnr t001w~name1 makt~maktx mard~lgort
mard~lfgja mard~lfmon mard~labst mard~speme
INTO TABLE t_marc
FROM marc
INNER JOIN t001w ON marc~werks = t001w~werks
INNER JOIN makt ON marc~matnr = makt~matnr
and makt~spras = sy-langu
INNER JOIN mard ON marc~matnr = mard~matnr
WHERE t001w~werks IN S_CENTRO
AND marc~matnr IN S_MATERI
AND mard~lfgja IN S_ANO
AND mard~lfmon IN S_MES
AND mard~lgort IN S_DEPOSI.
IF sy-subrc <> 0.
MESSAGE S001.
ENDIF.
ENDFORM. " F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
*& Form F_MOSTRAR_DADOS
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_MOSTRAR_DADOS .
SORT T_MARC BY matnr werks lgort.
* comando LOOP AT tabela serve para criar um loop até o final da tabela
* para podermos imprimir seu conteúdo.
LOOP AT T_MARC.
WRITE /5 T_MARC-MATNR.
WRITE 18 T_MARC-MAKTX.
WRITE 60 T_MARC-WERKS.
WRITE 80 T_MARC-NAME1.
WRITE 120 T_MARC-LGORT.
WRITE 140 T_MARC-LFGJA.
WRITE 150 T_MARC-LFMON.
WRITE 160 T_MARC-LABST.
* HIDE com os campos que queiramos mostrar na nova janela. Deve ser
* colocado depois de imprimir linha
HIDE :T_MARC-MATNR,T_MARC-MAKTX,T_MARC-WERKS, T_MARC-NAME1,
T_MARC-LGORT,T_MARC-LABST, T_MARC-SPEME.
* o comando AT END OF campo, faz com que quando houver uma quebra de
* centro ( no caso werks ) o programa entre e execute as instruções
* contidas dentro dele.
AT END OF werks.
* o comando SUM totaliza os campos numéricos
SUM.
WRITE : /5 'TOTAL DO MATERIAL : ',t_marc-maktx.
WRITE 160 T_MARC-LABST.
ENDAT.
ENDLOOP.
ENDFORM. " F_MOSTRAR_DADOS
*&---------------------------------------------------------------------*
*& Form F_CABECA
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_CABECA .
DATA novo(60) TYPE C.
WRITE 5 sy-datum.
WRITE 50 'CHEMYUNION QUIMICA LTDA'.
WRITE 120 sy-pagno.
WRITE AT /40 text-002.
WRITE AT /5 'Material'.
WRITE 18 'Descrição'.
WRITE 60 'Centro'.
WRITE 80 'Descrição'.
WRITE 120 'DEPOSTIO'.
WRITE 140 'ANO '.
WRITE 150 'MES '.
WRITE 180 'QTD '.
ULINE.
ENDFORM. " F_CABECA
*&---------------------------------------------------------------------*
*& Form F_BUSCAR_MATERIAL
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_BUSCAR_MATERIAL .
SELECT * FROM marc UP TO 1 ROWS WHERE matnr IN s_materi.
ENDSELECT.
IF SY-SUBRC <> 0.
MESSAGE W001.
ENDIF.
SELECT * FROM t001L UP TO 1 ROWS WHERE lgort IN s_deposi.
ENDSELECT.
IF SY-SUBRC <> 0.
MESSAGE W002.
ENDIF.
ENDFORM. " F_BUSCAR_MATERIAL