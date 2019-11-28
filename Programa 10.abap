*Programa 10 GRAPH_MATRIX_3D
*&---------------------------------------------------------------------*
*& Include ZC00115 *
*&---------------------------------------------------------------------*
REPORT ZC00115.
DATA : BEGIN OF T_tabela OCCURS 0,
campo(20) TYPE C,
END OF T_tabela.
DATA : BEGIN OF T_vendedor OCCURS 0,
nome(10) TYPE C,
tv TYPE I,
vídeo TYPE I,
radio TYPE I,
dvd TYPE I,
END OF T_vendedor.
INItialization.
PERFORM F_CARREGA_DADOS.
START-OF-SELECTION.
PERFORM F_GRAFICO.
END-OF-SELECTION.
*&---------------------------------------------------------------------*
*& Form F_CARREGA_DADOS
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM F_CARREGA_DADOS .
REFRESH t_tabela.
CLEAR t_tabela.
t_tabela-campo = 'FIFRST=3D'.
APPEND t_tabela.
t_tabela-campo = 'P3TYPE=TO'.
APPEND t_tabela.
t_tabela-campo = 'P3CTYP=RO'.
APPEND t_tabela.
t_tabela-campo = 'TISIZE=2'.
APPEND t_tabela.
t_tabela-campo = 'CLBACK=X'.
APPEND t_tabela.
COMMIT WORK.
REFRESH t_vendedor.
CLEAR t_vendedor.
t_vendedor-nome = 'ZE'.
t_vendedor-tv = 98.
t_vendedor-VIDEO = 83.
t_vendedor-radio = 45.
t_vendedor-dvd = 65.
APPEND t_vendedor.
t_vendedor-nome = 'MANE'.
t_vendedor-tv = 52.
t_vendedor-VIDEO = 38.
t_vendedor-radio = 23.
t_vendedor-dvd = 5.
APPEND t_vendedor.
t_vendedor-nome = 'JOAO'.
t_vendedor-tv = 73.
t_vendedor-VIDEO = 54.
t_vendedor-radio = 35.
t_vendedor-dvd = 49.
APPEND t_vendedor.
COMMIT WORK.
ENDFORM. " F_CARREGA_DADOS
*&---------------------------------------------------------------------*
*& Form F_GRAFICO
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM F_GRAFICO .
* FUNÇÃO PARA CRIAR GRAFICOS
CALL FUNCTION 'GRAPH_MATRIX_3D'
EXPORTING
* AUTO_CMD_1 = ' '
* AUTO_CMD_2 = ' '
COL1 = 'TV'
COL2 = 'VIDEO CASSETE'
COL3 = 'RADIO'
COL4 = 'DVD'
* COL5 = ' '
* COL6 = ' '
DIM1 = 'PRODUTOS'
DIM2 = 'VENDEDOR'
* INBUF = ' '
INFORM = '6'
* MAIL_ALLOW = ' '
* PWDID = ' '
* SET_FOCUS = 'x'
* SMFONT = ' '
* SO_CONTENTS = ' '
* SO_RECEIVER = ' '
* SO_SEND = ' '
* SO_TITLE = ' '
* STAT = ' '
* SUPER = ' '
* TIMER = ' '
TITL = 'VENDAS 2003'
VALT = 'QTD'
* WDID = ' '
* WINID = ' '
WINPOS = '5'
WINSZX = '5'
WINSZY = '70'
* X_OPT = ' '
* NOTIFY = ' '
* IMPORTING
* B_KEY =
* B_TYP =
* CUA_ID =
* MOD_COL =
* MOD_ROW =
* MOD_VAL =
* M_TYP =
* RBUFF =
* RWNID =
TABLES
DATA = t_vendedor
OPTS = t_tabela.
ENDFORM. " F_GRAFICO