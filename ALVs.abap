*********ALVs TREE.   *********

Exemplos programas: BCALV_TREE*

*********Field Catalog*********

COL_POS = Posição da coluna onde será apresentado
FIELDNAME = Nome do campo
REF_FIELDNAME = Referência do campo na minha tabela interna que será utilizado.
REF_TABNAME = Tabela transparente referência de origem do dado (LFA1, KNA1, J_1BNFDOC, etc.
TABNAME = Tabela interna referência utilizada no ALV.


*********LAYOUT*********
Utilizado para alterações finais no modelo do ALV

Opções mais utilizadas:
ZEBRA
Mostra o relatório em cores diferentes linha a linha.
NUMC_TOTAL
Número total de linhas do relatório
COLWIDTH_OPTIMIZE
Otimizar o espaçamento dos campos
EDIT
Estrutura de tela do ALV é marcada como editável, desta forma a tabela interna é modificada.



*********ALV SIMPLES LIST********
FUNCTION REUSE_ALV_LIST_DISPLAY

Reuse_alv_fieldcatalog_merge (Função para montar o Field Catalog essencial para configurar os dados da saída).
Reuse_alv_list_display (Função de apresentação dos dados).
Reuse_alv_events_get (Função para criar eventos na lista de saída).
Reuse_alv_grid_display (Apresenta o resultado num grid full screen).
Reuse_alv_commentary_write (Criar um cabeçalho com informações desejadas).

Cabeçalho do ALV
Vinculado a chamada da Função do ALV através do FORM criado.

FORM monta_layout.

  gd_layout-no_input          = 'X'.
  gd_layout-colwidth_optimize = 'X'.
  gd_layout-zebra             = 'X'.

ENDFORM.                    "Monta_layout


FORM f_alv_grid_display.

    wa_layout-zebra = 'X'.
*   wa_layout-edit = 'X'.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING 
            i_callback_program      = SY-REPID
            i_callback_top_of_page  = 'F_TOP_OF_PAGE'
            is_layout               =  wa_layout
            it_fieldcat             =  t_fieldcat
*            it_events               =  t_event  " Eventos
            i_save                  = 'X'
        TABLES
            t_outtab                = tg_alv. " Tabela com os dados

    IF sy-subrc <> 0.

    ENDIF.

ENDFORM.

FORM f_top_of_page.

   "ALV Header declarations

    DATA: t_header      TYPE slis_t_listheader,
          wa_header     TYPE slis_listheader,
          t_line        LIKE wa_header-info,
          id_line       TYPE i,
          id_linesc(10) TYPE c.
   "TITLE
    wa_header-typ = 'H'.
    wa_header-info = 'Report exemplo TOP'.
    APPEND wa_header TO t_header.
    CLEAR wa_header.

   "DATA
    wa_header-typ = 'S'.
    wa_header-key = 'Data: '.
    CONCATENATE SY-DATUM+6(2) '.'
    SY-DATUM+4(2) '.'
    SY-DATUM(4) INTO wa_header-info.
    APPEND wa_header TO t_header.
    CLEAR: wa_header.

   "TOTAL NO. OF RECORDS SELECTED
    DESCRIBE TABLE tg_alv LINES ld_lines.
    ld_lines = id_lines.
    CONCATENATE 'Número total de linhas selecionadas: ' ld_linesc
    INTO t_line SEPARATED BY space.
    wa_header-typ = 'A'.
    wa_header-info = t_line.
    APPEND wa_header TO t_header.
    CLEAR: wa_header, t_line.
    CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
        EXPORTING
            it_list_commentary = t_header
            i_logo             = 'Z_LOGO'. "Colocar os logos.

ENDFORM.           


********** ALV OO EXEMPLO ***********

TYPES:
    BEGIN OF ty_j_1bnfdoc, 
        docnum TYPE j_1bnfdoc-docnum,
        parid  TYPE j_1bnfdoc-parid,
    END OF ty_j_1bnfdoc.

DATA: tg_j_1bnfdoc TYPE STANDARD TABLE OF ty_j_1bnfdoc.

START-OF-SELECTION.

    DATA: r_table        TYPE REF TO cl_salv_table,
          r_functions    TYPE REF TO cl_salv_functions.

    
    SELECT docnum parid UP TO 100 ROWS
        FROM    j_1bnfdoc
        INTO TABLE tg_j_1bnfdoc.

    CALL METHOD cl_salv_table=>factory
        IMPORTING
            r_salv_table = r_table
        CHANGING
            t_table      = tg_j_1bnfdoc.

    CALL METHOD r_table->display.


