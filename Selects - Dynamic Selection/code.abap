REPORT zselect_dinamico.

* Declara��es
*---------------------------------
DATA: fieldcat    TYPE lvc_t_fcat,
 r_fieldcat  LIKE LINE OF fieldcat,
 d_reference TYPE REF TO data.

FIELD-SYMBOLS: <table> TYPE STANDARD TABLE,
               <wa_table> TYPE ANY.

TYPES: BEGIN OF ty_select,
 line TYPE fieldname,
 END OF ty_select.

DATA: t_campos TYPE TABLE OF ty_select WITH HEADER LINE,
 t_tables TYPE TABLE OF ty_select WITH HEADER LINE,
 t_where  TYPE TABLE OF ty_select WITH HEADER LINE.

* Cria��o do Fieldcat para Tabela Din�mica
*-----------------------------------------
r_fieldcat-fieldname = 'KUNNR'.
r_fieldcat-ref_field = 'KUNNR'.
r_fieldcat-ref_table  = 'KNA1'.
APPEND r_fieldcat TO fieldcat.

r_fieldcat-fieldname = 'NAME1'.
r_fieldcat-ref_field = 'NAME1'.
r_fieldcat-ref_table  = 'KNA1'.
APPEND r_fieldcat TO fieldcat.

* M�todo Est�tico que cria a tabela interna do tipo do fieldcat
* Esse m�todo est� sendo "emprestado" da classe de ALV, s� para
* a montagem da tabela interna de maneira din�mica
*----------------------------------------------------------------
CALL METHOD cl_alv_table_create=>create_dynamic_table
 EXPORTING
 it_fieldcatalog = fieldcat
 IMPORTING
 ep_table        = d_reference.

* A vari�vel d_reference � do tipo DATA
* Associa a refer�ncia da tabela, para ser possivel alterar os dados.
*--------------------------------------------------------------------
ASSIGN d_reference->* TO <table>.

* Monta tabela com os Campos que ser�o selecionados
*--------------------------------------------------
LOOP AT fieldcat INTO r_fieldcat  .
 t_campos-line = r_fieldcat-fieldname.
 APPEND t_campos.
ENDLOOP.

* Tabela onde ser� feito o Select
*---------------------------------
t_tables-line = 'KNA1'.

* Cl�usula Where do Select
*-----------------------------------
t_where-line = 'KUNNR = ''0000006251'' OR'.
APPEND t_where.
t_where-line = 'LAND1 = ''CL'' '.
APPEND t_where.

* Select Totalmente Din�mico! :)
*---------------------------------
SELECT (t_campos)
 INTO TABLE <table>
 FROM (t_tables-line)
 WHERE (t_where).

* Divirta-se vendo os dados nos field-symbols
*------------------------------------------
LOOP AT <table> ASSIGNING <wa_table>.

 BREAK-POINT.

ENDLOOP.

BREAK-POINT.