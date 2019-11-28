REPORT zrregsped.

DATA: table_name       TYPE string,
      line_type        TYPE REF TO cl_abap_structdescr,
      line_type_native TYPE REF TO cl_abap_typedescr,
      tl_ze11          TYPE zt1319_e111,
      internal_table   TYPE REF TO data,
      o_alv            TYPE REF TO cl_salv_table,
      table_type       TYPE REF TO cl_abap_tabledescr.

FIELD-SYMBOLS <internal_table> TYPE STANDARD TABLE.

SELECTION-SCREEN BEGIN OF BLOCK rad1
                          WITH FRAME TITLE title.

PARAMETERS: tn TYPE dd02l-tabname OBLIGATORY.
SELECT-OPTIONS: s_data FOR tl_ze11-pstdat.

SELECTION-SCREEN END OF BLOCK rad1.

INITIALIZATION.
  title = 'Visualizar Tabelas'.

START-OF-SELECTION.
  table_name = tn.

  CALL METHOD cl_abap_typedescr=>describe_by_name
    EXPORTING
      p_name         = table_name
    RECEIVING
      p_descr_ref    = line_type_native
    EXCEPTIONS
      type_not_found = 1
      OTHERS         = 2.

  CHECK sy-subrc IS INITIAL.

  line_type ?= line_type_native.
  table_type = cl_abap_tabledescr=>create( p_line_type = line_type
                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

  CREATE DATA internal_table TYPE HANDLE table_type.

  ASSIGN internal_table->* TO <internal_table>.

  IF   table_name EQ 'ZT1319_C197'
    OR table_name EQ 'ZT1319_C100'
    OR table_name EQ 'ZT1319_E111'
    OR table_name EQ 'ZT1319_E115'.

    SELECT * FROM (tn) INTO TABLE <internal_table>
      WHERE pstdat IN s_data.

    IF sy-subrc IS NOT INITIAL.
      SELECT * FROM (tn) INTO TABLE <internal_table>.
    ENDIF.

  ELSE.
    SELECT * FROM (tn) INTO TABLE <internal_table>.
  ENDIF.

  IF sy-subrc IS INITIAL.
    " Mostra ALV.
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = o_alv
      CHANGING
        t_table      = <internal_table>.

   "popup
    o_alv->set_screen_popup(
    start_column = 15
    end_column   = 175
    start_line   = 1
    end_line     = 22 ).

    o_alv->display( ).

  ELSE.
    MESSAGE 'Tabela indicada está incorreta ou não contém dados!' TYPE 'I'.
  ENDIF.