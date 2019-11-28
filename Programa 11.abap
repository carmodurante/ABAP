***Programa 11
*&---------------------------------------------------------------------*
*& Report ZC00116 *
*& *
*&---------------------------------------------------------------------*
REPORT ZC00116 LINE-SIZE 80 LINE-COUNT 65 NO STANDARD PAGE HEADING.
TABLES T001L.
DATA: BEGIN OF T_001L OCCURS 0,
WERKS TYPE T001L-WERKS,
LGORT TYPE T001L-LGORT,
LGOBE TYPE T001L-LGOBE,
END OF T_001L.
REFRESH t_001l.
CLEAR t_001l.
SELECT werks lgort lgobe INTO TABLE t_001l FROM T001L.
* COMANDO PARA CRIAR BOTAO NO RELATORIO
* SET PF-STATUS 'nome_botao'
* DAR DUPLO CLICK NO nome_do_botão PARA CRIAR O OBJETO
SET PF-STATUS 'BOTAO'.
INITIALIZATION.
TOP-OF-PAGE.
PERFORM F_CABECALHO.
END-OF-PAGE.
START-OF-SELECTION.
PERFORM f_imprimir_dados.
END-OF-SELECTION.
* EVENTO PARA O BOTAO
AT USER-COMMAND.
* variável de sistema. retorna o nome do botão (DOWNLOAD)
IF sy-ucomm = 'DOWNLOAD'.
PERFORM F_DOW_NOVO.
ENDIF.
*&---------------------------------------------------------------------*
*& Form F_CABECALHO
*&---------------------------------------------------------------------*
FORM F_CABECALHO .
WRITE 5 sy-datum.
WRITE 30 'CHEMYUNION QUIMICA LTDA'.
WRITE 75 sy-pagno.
WRITE /2 'Centro'.
WRITE 10 'Deposito'.
WRITE 20 'Descrição'.
ULINE.
ENDFORM. " F_CABECALHO
*&---------------------------------------------------------------------*
*& Form f_imprimir_dados
*&---------------------------------------------------------------------*
FORM f_imprimir_dados .
* O FORM QUE VAI SER CHAMADO POR OUTRO PROGRAMA deve ter todas as infor
* mações para gerar o form ( ou seja neste caso montar a tabela )
LOOP AT t_001l.
WRITE /2 t_001l-werks.
WRITE 10 t_001l-lgort.
WRITE 20 t_001l-lgobe.
ENDLOOP.
ENDFORM. " f_imprimir_dados
*&---------------------------------------------------------------------*
*& Form F_DOW_NOVO
*&---------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_DOW_NOVO .
* tambem temos a função UPLOAD
* ESTA FUNÇÃO VEM COM TELA DE ESCOLHAR ( MENU ABRIR )
* podemos escolher o formato de arquivo.
CALL FUNCTION 'DOWNLOAD'
* EXPORTING
* BIN_FILESIZE = ' '
* CODEPAGE = ' '
* FILENAME = ' '
* FILETYPE = ' '
* ITEM = ' '
* MODE = ' '
* WK1_N_FORMAT = ' '
* WK1_N_SIZE = ' '
* WK1_T_FORMAT = ' '
* WK1_T_SIZE = ' '
* FILEMASK_MASK = ' '
* FILEMASK_TEXT = ' '
* FILETYPE_NO_CHANGE = ' '
* FILEMASK_ALL = ' '
* FILETYPE_NO_SHOW = ' '
* SILENT = 'S'
* COL_SELECT = ' '
* COL_SELECTMASK = ' '
* NO_AUTH_CHECK = ' '
* IMPORTING
* ACT_FILENAME =
* ACT_FILETYPE =
* FILESIZE =
* CANCEL =
TABLES
DATA_TAB = T_001L
* FIELDNAMES =
EXCEPTIONS
INVALID_FILESIZE = 1
INVALID_TABLE_WIDTH = 2
INVALID_TYPE = 3
NO_BATCH = 4
UNKNOWN_ERROR = 5
GUI_REFUSE_FILETRANSFER = 6
OTHERS = 7
.
IF SY-SUBRC <> 0.
MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
ENDFORM. " F_DOW_NOVO