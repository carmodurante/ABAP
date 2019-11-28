*&---------------------------------------------------------------------*
*& Report  Z_CDN_PROGRAMA07
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_cdn_programa07 LINE-SIZE 200 LINE-COUNT 65 NO STANDARD PAGE HEADING

MESSAGE-ID z01.
TABLES : mard, makt, t001w, t001l.

TYPES: BEGIN OF t_mard,
matnr LIKE mard-matnr,
werks LIKE mard-werks,
name1 LIKE t001w-name1,
maktx LIKE makt-maktx,
lgort LIKE mard-lgort,
lgobe LIKE t001l-lgobe,
labst LIKE mard-labst,
speme LIKE mard-speme,
END OF t_mard.

DATA: tg_t_mard TYPE TABLE OF t_mard,
      wa_t_mard type t_mard.


DATA : BEGIN OF t_001 OCCURS 0,
werks LIKE t001w-werks,
END OF t_001.

* PARA COLOCARMOS UM DELIMITAR TIPO (;) DEVEMOS CRIAR UMA TABELA INTERNA
* COM OS CAMPOS QUE IREMOS EXPORTAR ( TODOS TXT ) E MOVER O CONTEUDO DA
* TABELA INTERNA PARA A TABELA DE EXPORTAÇÃO
* VARIAVEL PARA CONVERTER O PARAMETRO p_arq EM string
* para passarmos na função gui_download.
DATA v_arquivo TYPE string.

CLEAR : tg_t_mard, T_001.

SELECTION-SCREEN BEGIN OF BLOCK b_janela WITH FRAME TITLE text-001.
SELECT-OPTIONS s_materi FOR wa_t_mard-matnr.
SELECT-OPTIONS s_centro FOR wa_t_mard-werks.
SELECT-OPTIONS s_deposi FOR wa_t_mard-lgort.
SELECTION-SCREEN END OF BLOCK b_janela.
* PARA CRIAR BOTÕES DE SELEÇÃO
*
SELECTION-SCREEN BEGIN OF BLOCK b_janela3 WITH FRAME TITLE text-003.
PARAMETERS p_bot1 RADIOBUTTON GROUP b1.
PARAMETERS p_bot2 RADIOBUTTON GROUP b1.
SELECTION-SCREEN END OF BLOCK b_janela3.
SELECTION-SCREEN BEGIN OF BLOCK b_janela2 WITH FRAME TITLE text-002.
* OBLIGATORY faz com que o parametro seja obRigatório
PARAMETERS p_arq LIKE rlgrap-filename. " OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b_janela2.

INITIALIZATION.
  PERFORM f_selecionar.

AT SELECTION-SCREEN ON s_materi.

AT SELECTION-SCREEN ON s_deposi.
  PERFORM f_buscar_material.

TOP-OF-PAGE.
  PERFORM f_cabeca.

END-OF-PAGE.

START-OF-SELECTION.
  PERFORM f_buscar_dados.

END-OF-SELECTION.
* VERIFICA SE A VRIAVEL P_ARQ ESTA LIMPA, SE SIM MOSTRA NA TELA SE NÃO GERA ARQUIVO
  IF p_arq IS NOT INITIAL.
    v_arquivo = p_arq.
    IF p_bot1 = 'X'.
      PERFORM f_download_arq.
    ELSE.
* somente para UNIX NÃO FUNCIONA EM WINDOWS
      PERFORM f_down_unix.
    ENDIF.
  ELSE.
    PERFORM f_mostrar_dados.
  ENDIF.
* o comando AT LINE-SELECTION é um evento que serve para
* quando clicarmos em uma linha de relatório abrir uma outra
* janela e mostrarmos outros dados
AT LINE-SELECTION.
* IF NOT var IS INITIAL -> verifica se o header liner esta vazio
* se não for vazio imprime a tela de detalhes
  IF NOT tg_t_mard IS INITIAL.
* SET TITLEBAR 'var' mostra o titulo da nova tela
    SET TITLEBAR 'DET'.
* SY-ULINE -> imprime linha com comprimento fixo
    WRITE sy-uline(83).
* SY-VLINE -> serve para fazer fechamento de bordas
    WRITE / sy-vline.
    WRITE :'Material : '.
    WRITE : wa_t_mard-matnr,' - ', wa_t_mard-maktx,' '.
    WRITE 83 sy-vline.
    WRITE / sy-vline.
    WRITE :'Centro : '.
    WRITE 83 sy-vline.
    WRITE /:sy-vline.
    WRITE :'Deposito : '.
    WRITE : wa_t_mard-lgort.
    WRITE 83 sy-vline.
    WRITE /:sy-vline.
    WRITE :'Disponível : '.
    WRITE : wa_t_mard-labst.
    WRITE 83 sy-vline.
    WRITE /:sy-vline.
    WRITE : 'Bloqueado : '.
    WRITE : wa_t_mard-speme.
    WRITE 83 sy-vline.
    WRITE / sy-uline(83).
  ENDIF.
* depois de listar a nova informação devemos limpar o header liner da tabela
  CLEAR wa_t_mard.
*&---------------------------------------------------------------------*
*& Form F_SELECIONAR
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_selecionar .
  SELECT werks INTO TABLE t_001 FROM t001w.
  REFRESH s_centro.
  LOOP AT t_001.
    CLEAR s_centro.
    s_centro-sign = 'I'.
    s_centro-option = 'EQ'.
    s_centro-low = t_001-werks.
    APPEND s_centro.
  ENDLOOP.
ENDFORM. " F_SELECIONAR
*&---------------------------------------------------------------------*
*& Form F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM f_buscar_dados .
  SELECT mard~matnr mard~werks t001w~name1 makt~maktx mard~lgort
  t001l~lgobe mard~labst mard~speme
  INTO TABLE tg_t_mard
  FROM mard
  INNER JOIN t001w ON mard~werks = t001w~werks
  INNER JOIN makt ON mard~matnr = makt~matnr
  AND makt~spras = sy-langu
  INNER JOIN t001l ON mard~werks = t001l~werks
  AND mard~lgort = t001l~lgort
  WHERE t001w~werks IN s_centro
  AND mard~matnr IN s_materi
  AND mard~lgort IN s_deposi.
  IF sy-subrc <> 0.
    MESSAGE s001.
  ENDIF.
ENDFORM. " F_BUSCAR_DADOS
*&---------------------------------------------------------------------*
*& Form F_MOSTRAR_DADOS
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM f_mostrar_dados .
  SORT tg_t_mard BY matnr werks lgort.
* comando LOOP AT tabela serve para criar um loop até o final da tabela
* para podermos imprimir seu conteúdo.
  LOOP AT tg_t_mard into wa_t_mard.
    WRITE / wa_t_mard-matnr.
    WRITE 13 wa_t_mard-maktx.
    WRITE 55 wa_t_mard-werks.
    WRITE 65 wa_t_mard-name1(20).
    WRITE 89 wa_t_mard-lgort.
    WRITE 95 wa_t_mard-lgobe(10).
    WRITE 105 wa_t_mard-labst.
    WRITE 122 wa_t_mard-speme.
* HIDE com os campos que queiramos mostrar na nova janela. Deve ser
* colocado depois de imprimir linha
    HIDE :wa_t_mard-matnr,wa_t_mard-maktx,wa_t_mard-werks, wa_t_mard-name1,
    wa_t_mard-lgort,wa_t_mard-labst, wa_t_mard-speme.
* o comando AT END OF campo, faz com que quando houver uma quebra de
* centro ( no caso werks ) o programa entre e execute as instruções
* contidas dentro dele.
    AT END OF werks.
* o comando SUM totaliza os campos numéricos
      SUM.
      WRITE : / 'TOTAL DO MATERIAL '.
      WRITE '........................................................:'.
      WRITE 105 wa_t_mard-labst.
      WRITE 122 wa_t_mard-speme.
    ENDAT.
  ENDLOOP.
ENDFORM. " F_MOSTRAR_DADOS
*&---------------------------------------------------------------------*
*& Form F_CABECA
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM f_cabeca .
  DATA novo(60) TYPE c.
  WRITE 5 sy-datum.
  WRITE 50 'CHEMYUNION QUIMICA LTDA'.
  WRITE 120 sy-pagno.
  WRITE AT / 'Material'.
  WRITE 13 'Descrição'.
  WRITE 55 'Centro'.
  WRITE 65 'Descrição'.
  WRITE 89 'DEPOSITO.'.
  WRITE 115 'Estoque'.
  WRITE 130 'Bloqueado'.
  ULINE.
ENDFORM. " F_CABECA
*&---------------------------------------------------------------------*
*& Form F_BUSCAR_MATERIAL
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM f_buscar_material .
  SELECT * FROM mard UP TO 1 ROWS WHERE matnr IN s_materi.
  ENDSELECT.
  IF sy-subrc <> 0.
    MESSAGE w001.
  ENDIF.
  SELECT * FROM t001l UP TO 1 ROWS WHERE lgort IN s_deposi.
  ENDSELECT.
  IF sy-subrc <> 0.
    MESSAGE w002.
  ENDIF.
ENDFORM. " F_BUSCAR_MATERIAL
*&---------------------------------------------------------------------*
*& Form F_DOWNLOAD_ARQ
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM f_download_arq .
* FUNÇAO USADO PARA EXPORTAR ARQUIVOS
  CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
* BIN_FILESIZE =
  filename = v_arquivo
  filetype = 'ASC'
* APPEND = ' '
* WRITE_FIELD_SEPARATOR = ' '
* HEADER = '00'
* TRUNC_TRAILING_BLANKS = ' '
* WRITE_LF = 'X'
* COL_SELECT = ' '
* COL_SELECT_MASK = ' '
* DAT_MODE = ' '
* CONFIRM_OVERWRITE = ' '
* NO_AUTH_CHECK = ' '
* IMPORTING
* FILELENGTH =
  TABLES
  data_tab = tg_t_mard
  EXCEPTIONS
  file_write_error = 1
  no_batch = 2
  gui_refuse_filetransfer = 3
  invalid_type = 4
  no_authority = 5
  unknown_error = 6
  header_not_allowed = 7
  separator_not_allowed = 8
  filesize_not_allowed = 9
  header_too_long = 10
  dp_error_create = 11
  dp_error_send = 12
  dp_error_write = 13
  unknown_dp_error = 14
  access_denied = 15
  dp_out_of_memory = 16
  disk_full = 17
  dp_timeout = 18
  file_not_found = 19
  dataprovider_exception = 20
  control_flush_error = 21
  OTHERS = 22
  .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
* MESSAGE xxx WITH yyy
* xxx numero da mensagem
* yyy parametro que será mostrado na mensagem
* na criação da mensagem devemos colocar o símbolo & para
* indicar que será passado um parametro.
* EXEMPLO : Arquivo & criado com sucesso.
    MESSAGE s003 WITH p_arq.
  ENDIF.
ENDFORM. " F_DOWNLOAD_ARQ
*&---------------------------------------------------------------------*
*& Form F_DOWN_UNIX
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM f_down_unix .
* abre o arquivo para gravar em txt
* OPEN DATASET parametro FOR OUTPUT IN TEXT MODE.
* ou INPUT para ler o arquivo ( importar )
  OPEN DATASET p_arq FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    MESSAGE s004.
  ELSE.
    MESSAGE w005.
  ENDIF.
  DATA texto01(20) TYPE c.
  DATA texto02(40) TYPE c.
  DATA texto03(04) TYPE c.
  DATA texto04(20) TYPE c.
  DATA texto05(04) TYPE c.
  DATA texto06(20) TYPE c.
  DATA texto07(18) TYPE c.
  DATA texto08(18) TYPE c.
  DATA texto09(200) TYPE c.
* é necessário fazer loop da tabela interna
  LOOP AT tg_t_mard into wa_t_mard.
* TRANSFER tabela TO parametro arquivo
* serve para ler e gravar o arquivo externo
    texto01 = wa_t_mard-matnr.
    texto02 = wa_t_mard-maktx.
    texto03 = wa_t_mard-werks.
    texto04 = wa_t_mard-name1.
    texto05 = wa_t_mard-lgort.
    texto06 = wa_t_mard-lgobe.
    texto07 = wa_t_mard-labst.
    texto08 = wa_t_mard-speme.
    CONCATENATE texto01 texto02 texto03
    texto04 texto05 texto06
    texto07 texto08 INTO texto09.
    TRANSFER texto09 TO p_arq.
* READ DATASET parametro INTO tabela interna
* serve para ler e importar tabela interna
* READ DATASET p_arq INTO arquivo ou variável.
  ENDLOOP.
* para fechar o arquivo externo
* CLOSE DATASET parametro
  CLOSE DATASET p_arq.
ENDFORM. " F_DOWN_UNIX