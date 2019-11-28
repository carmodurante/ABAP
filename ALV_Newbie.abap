*&---------------------------------------------------------------------*
*& Report  Z_CND_ALV_NEWBIE
*&
*&---------------------------------------------------------------------*
*&
*&ALV BASICÃo MASTER
*&---------------------------------------------------------------------*

REPORT  z_cnd_alv_newbie.

TABLES: t001w. "Declaração da Tabela que será usada no ALV.


DATA: gt_plants TYPE TABLE OF t001w. "Declaração de uma variavel do tipo de tabela.
DATA: gr_alv    TYPE REF TO   cl_salv_table. "Declaração de variavel do tipo de classe da classe do alv.

SELECT-OPTIONS: so_werks FOR t001w-werks,
                so_land1 FOR t001w-land1.

START-OF-SELECTION.

  SELECT * FROM t001w
    INTO TABLE gt_plants
    WHERE werks IN so_werks
    AND land1 IN so_land1.

END-OF-SELECTION.

  IF gt_plants[] IS NOT INITIAL.
    CALL METHOD cl_salv_table=>factory "chamada do metodo do alv.
        EXPORTING
        list_display = if_salv_c_bool_sap=>true " Deixa mais bonitinha a lista.
      IMPORTING
        r_salv_table = gr_alv "importando variavel local do tipo de classe alv.
      CHANGING
        t_table      = gt_plants. "passgem de parametro da tabela preenchida para a montagem alv.
                                  "Sempre vai ser a tabela preenchida.

* Finally, show alv
    CALL METHOD gr_alv->display( ). "Chamada de metodo para mostrar o ALV na tela.
  ELSE.
    MESSAGE i208(00) WITH 'no plants found!'. " Mensagem caso a tabela não tenha valor.
  ENDIF.