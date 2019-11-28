*&-----------------------------------------------
*& Report  ZDEMO_ALVGRID
*&
*&-----------------------------------------------
*&
*& Example SALV_TABLE ALV Grid Report
*& ...................................
*&
*& Author: SAPDev.co.uk
*&
*& The basic requirement for this demo is to
*& display a number of fields from the EKPO
*& table using the CL_SALV_TABLE methods
*&-----------------------------------------------
REPORT zsalv_demo.

*Data Declaration
*----------------
TYPES: BEGIN OF t_ekpo,
  ebeln TYPE ekpo-ebeln,
  ebelp TYPE ekpo-ebelp,
  statu TYPE ekpo-statu,
  aedat TYPE ekpo-aedat,
  matnr TYPE ekpo-matnr,
  menge TYPE ekpo-menge,
  meins TYPE ekpo-meins,
  netpr TYPE ekpo-netpr,
  peinh TYPE ekpo-peinh,
  LINE_COLOR  TYPE lvc_t_scol,
 END OF t_ekpo.

DATA: lt_s_color TYPE lvc_t_scol.
DATA: it_ekpo TYPE STANDARD TABLE OF t_ekpo INITIAL SIZE 0,
      wa_ekpo TYPE t_ekpo.

DATA alv_table    TYPE REF TO cl_salv_table.
DATA alv_columns TYPE REF TO cl_salv_columns_table.
DATA single_column  TYPE REF TO cl_salv_column.


************************************************************************
* START-OF-SELECTION
START-OF-SELECTION.
  PERFORM data_retrieval.
  PERFORM display_settings.


************************************************************************
* END-OF-SELECTION
END-OF-SELECTION.
  perform display_alv_report.


*&---------------------------------------------------------------------*
*& FORM data_retrieval.
*&---------------------------------------------------------------------*
FORM data_retrieval.
  select ebeln ebelp statu aedat matnr menge meins netpr peinh
   up to 10 rows
    from ekpo
    into table it_ekpo.

*  loop at it_ekko assigning .
*  ls_s_color-fname = 'EBELN'.
*  ls_s_color-color-col = 5.
*  ls_s_color-color-int = 1.
*  ls_s_color-color-inv = 0.
*  APPEND ls_s_color TO -line_color.


ENDFORM.                    " DATA_RETRIEVAL


*&---------------------------------------------------------------------*
*& FORM display_settings.
*&---------------------------------------------------------------------*
FORM display_settings.
  DATA: err_message   TYPE REF TO cx_salv_msg.

  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = alv_table
      CHANGING
        t_table      = it_ekpo ).

      alv_columns = alv_table->get_columns( ).
      alv_columns->set_optimize( 'X' ). "optimise colums of SALV grid
      alv_columns->set_color_column( 'LINE_COLOR' ). "set line colour of SALV report


      PERFORM build_layout.
      PERFORM build_fieldcatalog.
      PERFORM build_toolbar.
      PERFORM hide_columns.
      PERFORM report_settings.

    CATCH cx_salv_msg INTO err_message.
*   Add error processing
  ENDTRY.
ENDFORM.


*&---------------------------------------------------------------------*
*& FORM display_alv_report.
*&---------------------------------------------------------------------*
FORM display_alv_report.
* set_optimize will set columns optimised based on data and will remove
* any width specification setup within build_fieldcatalog column setup
*  it_columns->set_optimize( ).

  alv_table->display( ).
ENDFORM.


*&---------------------------------------------------------------------*
*& FORM build_layout.
*&---------------------------------------------------------------------*
FORM build_layout.
  DATA: layout TYPE REF TO cl_salv_layout.
  DATA: layout_key      TYPE salv_s_layout_key.

  layout = alv_table->get_layout( ).

  layout_key-report = sy-repid.
  layout->set_key( layout_key ).

  layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
ENDFORM.                    "BUILD_LAYOUT


*&---------------------------------------------------------------------*
*& FORM hide_columns.
*&---------------------------------------------------------------------*
FORM hide_columns.
  DATA: err_notfound TYPE REF TO cx_salv_not_found.

  TRY.
      single_column = alv_columns->get_column( 'PEINH' ).
      single_column->set_visible( if_salv_c_bool_sap=>false ).

    CATCH cx_salv_not_found INTO err_notfound.
*   Add error processing
  ENDTRY.
ENDFORM.


*&---------------------------------------------------------------------*
*& FORM build_fieldcatalog.
*&---------------------------------------------------------------------*
*  Your ALV report should get texts from the internal table used but you
*  overwrite them here if you require
*&---------------------------------------------------------------------*
FORM build_fieldcatalog.
  DATA: err_notfound TYPE REF TO cx_salv_not_found.

  TRY.
      single_column = alv_columns->get_column( 'EBELN' ).
      single_column->set_short_text( 'POrder' ).  "Will cause syntax error if text is too long
      single_column->set_medium_text( 'Purchase Order' ).
      single_column->set_long_text( 'Purchase Order' ).
      single_column->SET_OUTPUT_LENGTH( '15' ). "Force column to be wider to accomodate heading

      single_column = alv_columns->get_column( 'NETPR' ).
      single_column->set_short_text( 'Net Price' ).  "Will cause syntax error if text is too long
      single_column->set_medium_text( 'Net Price' ).
      single_column->set_long_text( 'Net Price' ).

    CATCH cx_salv_not_found INTO err_notfound.
*   Add error processing
  ENDTRY.
ENDFORM.


*&---------------------------------------------------------------------*
*& FORM build_toolbar.
*&---------------------------------------------------------------------*
*  The code below simply displays all available functions but you can
*  restrict this if you require
*&---------------------------------------------------------------------*
FORM build_toolbar.
  DATA: toolbar_functions TYPE REF TO cl_salv_functions_list.

  toolbar_functions = alv_table->get_functions( ).
  toolbar_functions->set_all( ).

ENDFORM.


*&---------------------------------------------------------------------*
*& FORM report_settings.
*&---------------------------------------------------------------------*
FORM report_settings.
  DATA: report_settings TYPE REF TO cl_salv_display_settings.

  report_settings = alv_table->get_display_settings( ).
  report_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  report_settings->set_list_header( 'Display EKKO Records' ).
ENDFORM.