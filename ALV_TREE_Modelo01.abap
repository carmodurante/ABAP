REPORT  zprac_simple_tree.

TABLES: vbak.

CLASS cl_column_tree DEFINITION DEFERRED.

DATA: g_app TYPE REF TO cl_column_tree,
      g_cont TYPE REF TO cl_gui_custom_container,
      g_tree TYPE REF TO cl_gui_column_tree,
      tcode TYPE sy-ucomm,
      ok_code TYPE sy-ucomm,
      event TYPE cntl_simple_event,
      t_event TYPE cntl_simple_events,
      thhdr TYPE treev_hhdr.

DATA: node_table TYPE treev_ntab,
      " Crie uma estrutura do tipo de tabela MTREEITM
      item_table TYPE zitem_table,
      w_node TYPE treev_node,
      w_item TYPE mtreeitm,
      g_node_key TYPE tv_nodekey,
      g_node TYPE tv_nodekey,
      g_item TYPE tv_itmname.

DATA: root TYPE tv_nodekey VALUE 'Root',
      colm1 TYPE tv_itmname VALUE 'Column1',
      colm2 TYPE tv_itmname VALUE 'Column2'.

TYPES:BEGIN OF st_get,
      vbeln TYPE vbak-vbeln,
      auart TYPE vbak-auart,
      netwr TYPE vbak-netwr,
      END OF st_get.

DATA: it_get TYPE STANDARD TABLE OF st_get,
      wa_get TYPE st_get.

TYPES:BEGIN OF st_sot,
      auart TYPE vbak-auart,

      END OF st_sot.

DATA: it_sot TYPE STANDARD TABLE OF st_sot,
      wa_sot TYPE st_sot.

TYPES:BEGIN OF st_so,
      vbeln TYPE vbak-vbeln,
      auart TYPE vbak-auart,
      netwr TYPE vbak-netwr,
      END OF st_so.

DATA: it_so TYPE STANDARD TABLE OF st_so,
      wa_so TYPE st_so.

TYPES:BEGIN OF st_line,
      vbeln TYPE vbap-vbeln,
      posnr TYPE vbap-posnr,
      netwr TYPE vbap-netwr,
      END OF st_line.

DATA: it_line TYPE STANDARD TABLE OF st_line,
      wa_line TYPE st_line.

DATA: budj TYPE vbak-netwr,
      rson TYPE string.

*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*       CLASS cl_simple_tree DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*

CLASS cl_column_tree DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_node_double_click 

                           FOR EVENT node_double_click OF cl_gui_column_tree
               IMPORTING
                 node_key,
             handle_item_double_click 

                           FOR EVENT item_double_click OF cl_gui_column_tree
               IMPORTING
                 node_key
                 item_name,
             handle_expand_no_children 

                           FOR EVENT expand_no_children OF cl_gui_column_tree
               IMPORTING
                 node_key.
ENDCLASS.                    "cl_simple_tree DEFINITION

*----------------------------------------------------------------------*
*       CLASS cl_simple_tree IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*

CLASS cl_column_tree IMPLEMENTATION.
  METHOD handle_node_double_click.
    g_node = node_key.
  ENDMETHOD.                    "handle_node_double_click

  METHOD handle_item_double_click.
    g_node = node_key.
    g_item = item_name.
    IF g_item = colm2.
    CALL SCREEN 200 STARTING AT 10 10
                    ENDING AT 46 15.

    IF budj IS NOT INITIAL.
      PERFORM update_tree USING budj g_node g_item.
    ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD handle_expand_no_children.

    g_node = node_key.
  ENDMETHOD.                    "handle_expand_no_children
ENDCLASS.                    "cl_simple_tree IMPLEMENTATION

SELECTION-SCREEN: BEGIN OF BLOCK mgrp.
SELECT-OPTIONS: sdtype FOR vbak-auart.
SELECTION-SCREEN: END OF BLOCK mgrp.

START-OF-SELECTION.

CREATE OBJECT g_app.

  SELECT * FROM vbak INTO CORRESPONDING FIELDS OF TABLE it_get
    WHERE auart IN sdtype.

  LOOP AT it_get INTO wa_get.
    MOVE-CORRESPONDING wa_get TO wa_sot.
    MOVE-CORRESPONDING wa_get TO wa_so.
    APPEND wa_sot TO it_sot.
    APPEND wa_so TO it_so.
  ENDLOOP.

  SORT it_sot BY auart.
  DELETE ADJACENT DUPLICATES FROM it_sot.

  SORT it_so BY vbeln.
  DELETE ADJACENT DUPLICATES FROM it_so COMPARING vbeln.

  SELECT * FROM vbap INTO CORRESPONDING FIELDS OF TABLE it_line
    FOR ALL ENTRIES IN it_so
    WHERE vbeln = it_so-vbeln.

  SORT it_line BY vbeln.
  DELETE ADJACENT DUPLICATES FROM it_line COMPARING ALL FIELDS.
END-OF-SELECTION.

  SET SCREEN 100.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'TMENU'.
*  SET TITLEBAR 'xxx'.

  IF g_tree IS INITIAL.
    PERFORM grow_tree.
  ELSE.
    IF budj IS NOT INITIAL AND rson IS NOT INITIAL.

      CALL METHOD g_tree->delete_all_nodes
        EXCEPTIONS
          failed            = 1
          cntl_system_error = 2
          others            = 3
             .
      IF sy-subrc <> 0.
       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      CALL METHOD g_tree->add_nodes_and_items
        EXPORTING
          node_table                     = node_table
          item_table                     = item_table
          item_table_structure_name      = 'MTREEITM'
        EXCEPTIONS
          failed                         = 1
          cntl_system_error              = 2
          error_in_tables                = 3
          dp_error                       = 4
          table_structure_name_not_found = 5
          others                         = 6
             .
      IF sy-subrc <> 0.
       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.


    ENDIF.
  ENDIF.


ENDMODULE.                 " STATUS_0100  OUTPUT

 

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

MODULE user_command_0100 INPUT.
  CASE tcode.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Form  GROW_TREE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM grow_tree .
  CREATE OBJECT g_cont
    EXPORTING
      container_name = 'STREE'.

thhdr-heading = 'Column1'.
thhdr-width = 30.

CREATE OBJECT g_tree
  EXPORTING
*    lifetime                    =
    parent                      = g_cont
*    shellstyle                  =
    node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
*    hide_selection              =
    item_selection              = 'X'
    hierarchy_column_name       = colm1
    hierarchy_header            = thhdr
*    no_hierarchy_column         =
*    name                        =
  EXCEPTIONS
    lifetime_error              = 1
    cntl_system_error           = 2
    create_error                = 3
    illegal_node_selection_mode = 4
    failed                      = 5
    illegal_column_name         = 6
    others                      = 7
    .
IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

  event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  event-appl_event = 'X'. " process PAI if event occurs
  APPEND event TO t_event.

  event-eventid = cl_gui_column_tree=>eventid_item_double_click.
  event-appl_event = 'X'. " process PAI if event occurs
  APPEND event TO t_event.

  " expand no children
  event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  event-appl_event = 'X'.
  APPEND event TO t_event.

  CALL METHOD g_tree->set_registered_events
    EXPORTING
      events                    = t_event
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3
      OTHERS                    = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  SET HANDLER g_app->handle_node_double_click FOR g_tree.
  SET HANDLER g_app->handle_item_double_click FOR g_tree.
  SET HANDLER g_app->handle_expand_no_children FOR g_tree.

  CALL METHOD g_tree->add_column
    EXPORTING
      name                         = colm2
*      hidden                       =
*      disabled                     =
*      alignment                    =
      width                        = 20
*      width_pix                    =
*      header_image                 =
      header_text                  = 'Column2'
*      header_tooltip               =
    EXCEPTIONS
      column_exists                = 1
      illegal_column_name          = 2
      too_many_columns             = 3
      illegal_alignment            = 4
      different_column_types       = 5
      cntl_system_error            = 6
      failed                       = 7
      predecessor_column_not_found = 8
      others                       = 9
         .
  IF sy-subrc <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM build_tree USING node_table item_table.

  CALL METHOD g_tree->add_nodes_and_items
    EXPORTING
      node_table                     = node_table
      item_table                     = item_table
      item_table_structure_name      = 'MTREEITM'
    EXCEPTIONS
      failed                         = 1
      cntl_system_error              = 2
      error_in_tables                = 3
      dp_error                       = 4
      table_structure_name_not_found = 5
      others                         = 6
         .
  IF sy-subrc <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.                    " GROW_TREE

FORM build_tree USING node_table TYPE treev_ntab
                      item_table TYPE zitem_table.
  DATA: node TYPE mtreesnode,
        item TYPE mtreeitm,
        val_to_str TYPE string,
        sor TYPE vbap-vbeln,
        pos TYPE vbap-posnr,
        sopos TYPE string.

  node-node_key = root.
  CLEAR node-relatship.
  CLEAR node-relatkey.
  node-isfolder = 'X'.
  APPEND node TO node_table.

  item-node_key = root.
  item-item_name = colm1.
  item-class = cl_gui_column_tree=>item_class_text.
  item-text = root.
  APPEND item TO item_table.

  item-node_key = root.
  item-item_name = colm2.
  item-class = cl_gui_column_tree=>item_class_text.
  val_to_str = root.
  item-text = val_to_str.
  APPEND item TO item_table.

  LOOP AT it_sot INTO wa_sot.
    node-node_key = wa_sot-auart.
    node-relatkey = root.
    node-relatship = cl_gui_column_tree=>relat_last_child.
    node-isfolder = 'X'.
    node-expander = 'X'.
    APPEND node TO node_table.

    item-node_key = wa_sot-auart.
    item-item_name = colm1.
    item-class = cl_gui_column_tree=>item_class_text.
    val_to_str = wa_sot-auart.
    item-text = val_to_str.
    APPEND item TO item_table.

    item-node_key = wa_sot-auart.
    item-item_name = colm2.
    item-class = cl_gui_column_tree=>item_class_text.
    item-text = 'Net Value'.
    APPEND item TO item_table.

    LOOP AT it_so INTO wa_so WHERE auart = wa_sot-auart.
      node-node_key = wa_so-vbeln.
      node-relatkey = wa_sot-auart.
      node-relatship = cl_gui_column_tree=>relat_last_child.
      node-isfolder = 'X'.
      node-expander = 'X'.
      APPEND node TO node_table.

      item-node_key = wa_so-vbeln.
      item-item_name = colm1.
      item-class = cl_gui_column_tree=>item_class_text.
      val_to_str = wa_so-vbeln.
      item-text = val_to_str.
      APPEND item TO item_table.

      item-node_key = wa_so-vbeln.
      item-item_name = colm2.
      item-class = cl_gui_column_tree=>item_class_text.
      val_to_str = wa_so-netwr.
      item-text = val_to_str.
      APPEND item TO item_table.

      LOOP AT it_line INTO wa_line WHERE vbeln = wa_so-vbeln.
        SHIFT wa_line-posnr LEFT DELETING LEADING '0'.
        SHIFT wa_line-vbeln LEFT DELETING LEADING '0'.
        CONCATENATE wa_line-vbeln wa_line-posnr INTO sopos.
        node-node_key = sopos.
        node-relatkey = wa_so-vbeln.
        node-relatship = cl_gui_column_tree=>relat_last_child.
        node-isfolder = ''.
        node-expander = ''.
        APPEND node TO node_table.

        item-node_key = sopos.
        item-item_name = colm1.
        item-class = cl_gui_column_tree=>item_class_text.
        val_to_str = wa_line-posnr.
        item-text = val_to_str.
        APPEND item TO item_table.

        item-node_key = sopos.
        item-item_name = colm2.
        item-class = cl_gui_column_tree=>item_class_text.
        val_to_str = wa_line-netwr.
        item-text = val_to_str.
        APPEND item TO item_table.
      ENDLOOP.

      CLEAR wa_so.
    ENDLOOP.
    CLEAR wa_sot.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module STATUS_0200 output.
  SET PF-STATUS 'EDIT'.
*  SET TITLEBAR 'xxx'.
  CLEAR: budj, rson.
endmodule.                 " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module USER_COMMAND_0200 input.
  CASE ok_code.
    WHEN 'OK'.
      IF budj IS NOT INITIAL AND rson IS NOT INITIAL.
      LEAVE TO SCREEN 0.
      ELSE.
        MESSAGE 'Value cannot be nil' TYPE 'E'.
      ENDIF.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

endmodule.                 " USER_COMMAND_0200  INPUT

FORM update_tree USING budj g_node g_item.
DATA: key_to_char TYPE string.
LOOP AT item_table INTO w_item WHERE node_key = g_node
                                 AND item_name = g_item.
  w_item-node_key = g_node.
  w_item-item_name = g_item.
  w_item-class = cl_gui_column_tree=>item_class_text.
  key_to_char = budj.
  w_item-text = key_to_char.
  MODIFY item_table FROM w_item.

ENDLOOP.
ENDFORM.