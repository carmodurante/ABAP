* Busca inst�ncia do scanner
DATA: lo_scanner TYPE REF TO cl_vsi.

CALL METHOD cl_vsi=>get_instance
  EXPORTING
    if_profile         = '/MEU_PACOTE/MINHA_APLICACAO'
  IMPORTING
    eo_instance        = lo_scanner
  EXCEPTIONS
    profile_not_active = 1
    OTHERS             = 2.

CASE sy-subrc.
  WHEN 0.
* Tudo certo com a interface
  WHEN 1.
* O antiv�rus est� desabilitado para a aplica��o /MEU_PACOTE/MINHA_APLICACAO.
* Aqui, a SAP recomenda exibir o erro com a mensagem da exce��o se o
* escaneamento anti-v�rus for obrigat�rio.
  WHEN OTHERS.
* Este caso � sempre um erro, e a SAP tamb�m recomenda que seja sempre usada
* a mensagem da exce��o.
ENDCASE.

DATA: lv_scanrc TYPE vscan_scanrc,
      lv_data   TYPE xstring,
      lv_text   TYPE string.

* A vari�vel LV_DATA aqui deve receber o conte�do do arquivo a ser escaneado

CALL METHOD lo_scanner->scan_bytes
  EXPORTING
    if_data             = lv_data
  IMPORTING
    ef_scanrc           = lv_scanrc
  EXCEPTIONS
    not_available       = 1
    configuration_error = 2
    internal_error      = 3
    OTHERS              = 4.

* Se o SY-SUBRC voltar diferente de 0 aqui, � erro da VSI
IF sy-subrc <> 0.
* MESSAGE...
* EXIT.
ENDIF.

* Para cada valor de LV_SCANRC retornado pelo SCAN_BYTES, existe um texto
* correspondente que pode ser buscado com o GET_SCANRC_TEXT. Se voltar 0,
* nenhum v�rus
lv_text = cl_vsi=>get_scanrc_text( lv_scanrc ).

WRITE: / 'Resultado do escaneamento:',
       / 'Return code: ',              lv_scanrc,
       / 'Descri��o: ',                lv_text.