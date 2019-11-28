*Programa 4 NO STANDARD PAGE HEADING
*&---------------------------------------------------------------------*
*& Report ZC00107 *
*& * NO STANDARD PAGE HEADING
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT ZC00107 LINE-SIZE 130 LINE-COUNT 65 NO STANDARD PAGE HEADING
MESSAGE-ID Z01.
* REPORT nome_do_programa
* parâmetros do REPORT
* -> LINE-SIZE n_colunas
* -> LINE-COUNT n_linhas
* -> NO STANDARD PAGE HEADING ( não usar cabeçalho padrão )
* -> MESSAGE-ID z01 ( onde z01 é a classe de mensagem )
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
* PARA CRIAR UM BOX NA JANELA SELECTION-SCREEN BEGIN OF BLOCK nome_do_bloco WITH FRAME
TITLE nome_do_elemento_de_texto
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
* PARA CRIAR ROTINAS : PERFORM nome_da_rotina. NÃO USAR ROTINAS PARA CRIAR TABELAS E
ABRIR TABELAS ESTAS DEVEM ESTAR NO INICIO DO PROGRAMA FAZER SEMPRE DENTRO DOS EVENTOS
PERFORM F_SELECIONAR.
* ANALISA O RESULTADO DA VARIAVEL s_materi ANTES DE INICIAR LISTA DE MATERIAL
AT SELECTION-SCREEN ON s_materi.
PERFORM F_BUSCAR_MATERIAL.
TOP-OF-PAGE.
PERFORM F_CABECA.
END-OF-PAGE.
* EVENTO DE EXTRAÇÃO DE DADOS - ANTES DA SELEÇÃO
START-OF-SELECTION.
PERFORM F_BUSCAR_DADOS.
* EVENTO PARA EXIBIR OS DADOS
END-OF-SELECTION.
PERFORM F_MOSTRAR_DADOS.
*&---------------------------------------------------------------------*
*& Form F_SELECIONAR
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_SELECIONAR .
* seleciona o CAMPO_que_iremos tratar INTO TABLE tabela_interna FROM tabela_de_onde_vira
os dados
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
* sy-subrc <> 0 não achou nada
* MESSAGE tipo_de_mensagem (E/I/W/S)+numero_seq_da_mensagem
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
LOOP AT T_MARC.
WRITE 5 T_MARC-MATNR.
WRITE 18 T_MARC-MAKTX.
WRITE 60 T_MARC-WERKS.
WRITE 80 T_MARC-NAME1.
SKIP 1.
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
* WRITE AT /40 'RELATÓRIO DE MATERIAIS POR CENTRO DE CUSTO : '.
CONCATENATE text-002 ' : ' s_centro+3(4) INTO novo.
WRITE AT /40 novo.
WRITE AT /5 'Material'.
WRITE 18 'Descrição'.
WRITE 60 'Centro'.
WRITE 80 'Descrição'.
ULINE.
ENDFORM. " F_CABECA
*&---------------------------------------------------------------------*
*& Form F_BUSCAR_MATERIAL
*&---------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_BUSCAR_MATERIAL .
* VERIFICA SE EXISTE O MATERIAL
SELECT * FROM marc UP TO 1 ROWS WHERE matnr IN s_materi.
ENDSELECT.
* ANALISA O RESULTADO DO SELECT
IF SY-SUBRC <> 0.
MESSAGE W001.
ENDIF.
ENDFORM. " F_BUSCAR_MATERIAL