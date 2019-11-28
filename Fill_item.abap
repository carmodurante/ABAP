***** CAST (CDN) 160394 RESOLUÇÃO SEFAZ 13.2019 - SPED EFD - INICIO. *****

*** Constants Declaration
CONSTANTS: BEGIN OF c_r1319, "Constantes para nota tecnica da nota 13.2019 da SEFAZ
tpnf_ent TYPE p LENGTH 1 VALUE '0',    "0" - ENTRADA
tpnf_sai TYPE p LENGTH 1 VALUE '1',    "1" - SAIDA
END OF c_r1319.

*** NOTA
DATA: wl_nota TYPE zst_nota.

*** TABLES PARAMETROS
DATA: tl_dif_cst    TYPE STANDARD TABLE OF string,
tl_ise_cst    TYPE STANDARD TABLE OF string,
tl_red_cst    TYPE STANDARD TABLE OF string,
tl_trf_cfop   TYPE STANDARD TABLE OF string,
tl_trf_cst    TYPE STANDARD TABLE OF string,
tl_trf_finnfe TYPE STANDARD TABLE OF string,
tl_werks      TYPE STANDARD TABLE OF string.

*** RANGES DECLARATION
DATA: r1319_ise_cst    TYPE RANGE OF numc2,
r1319_red_cst    TYPE RANGE OF numc2,
r1319_trf_cst    TYPE RANGE OF numc2,
r1319_dif_cst    TYPE RANGE OF numc2,
r1319_trf_cfop   TYPE RANGE OF zst_nota-cfop,
r1319_trf_finnfe TYPE RANGE OF zst_nota-finnfe,
r1319_werks      TYPE RANGE OF zst_nota-werks.

*** Tratativa para os FCP's.
READ TABLE in_tax ASSIGNING FIELD-SYMBOL(<fs_wa_in_tax>)
WITH KEY docnum = in_lin-docnum
itmnum = in_lin-itmnum
taxtyp = 'ICSC'.
IF sy-subrc EQ 0 AND <fs_wa_in_tax>-taxval > 0.
wl_nota-pfcp = <fs_wa_in_tax>-rate.
wl_nota-vbcfcp = <fs_wa_in_tax>-taxval.
wl_nota-vfcp  = <fs_wa_in_tax>-base.
ENDIF.

**** Separa os CST de acordo com o preenchido.
IF in_xml_item-l1_20_cst IS NOT INITIAL.
wl_nota-cst    = in_xml_item-l1_20_cst.
wl_nota-predbc = in_xml_item-l1_20_predbc.
wl_nota-vbc    = in_xml_item-l1_20_vbc.
wl_nota-picms  = in_xml_item-l1_20_picms.
wl_nota-vicms  = in_xml_item-l1_20_vicms.

ELSEIF in_xml_item-l1_51_cst IS NOT INITIAL.
wl_nota-cst   = in_xml_item-l1_51_cst.
wl_nota-vbc   = in_xml_item-l1_51_vbc.
wl_nota-picms = in_xml_item-l1_51_picms.
wl_nota-vicms = in_xml_item-l1_51_vicms.

ELSEIF in_xml_item-l1_70_cst IS NOT INITIAL.
wl_nota-cst    = in_xml_item-l1_70_cst.
wl_nota-predbc = in_xml_item-l1_70_predbc.
wl_nota-vbc    = in_xml_item-l1_70_vbc.
wl_nota-picms  = in_xml_item-l1_70_picms.
wl_nota-vicms  = in_xml_item-l1_70_vicms.

ELSEIF in_xml_item-l1_40_cst IS NOT INITIAL.
wl_nota-cst = in_xml_item-l1_40_cst.

ELSEIF in_xml_item-l1_90_cst IS NOT INITIAL.
wl_nota-cst = in_xml_item-l1_90_cst.
ENDIF.

*** Seleciona os Parametros
SELECT *
FROM zsd_parametros
INTO TABLE @DATA(tl_parametros)
WHERE programa = 'ZFIS_R1319'.

IF sy-subrc EQ 0 AND tl_parametros IS NOT INITIAL.
**** SPLITA OS VALORES DE CADA PARAMETRO PARA TABELA.

*** CST DIFERIMENTO
READ TABLE tl_parametros ASSIGNING FIELD-SYMBOL(<fs_wa_parametros_dif_cst>)
WITH KEY campo = 'DIF_CST'.
IF sy-subrc EQ 0.
IF <fs_wa_parametros_dif_cst>-valor CA ';'.
SPLIT <fs_wa_parametros_dif_cst>-valor AT ';' INTO TABLE tl_dif_cst.
ELSE.
APPEND <fs_wa_parametros_dif_cst>-valor TO tl_dif_cst.
ENDIF.
ENDIF.

*** CST ISENÇÃO
READ TABLE tl_parametros ASSIGNING FIELD-SYMBOL(<fs_wa_parametros_ise_cst>)
WITH KEY campo = 'ISE_CST'.
IF sy-subrc EQ 0.
IF <fs_wa_parametros_ise_cst>-valor CA ';'.
SPLIT <fs_wa_parametros_ise_cst>-valor AT ';' INTO TABLE tl_ise_cst.
ELSE.
APPEND <fs_wa_parametros_ise_cst>-valor TO tl_ise_cst.
ENDIF.
ENDIF.

*** CST REDUÇÃO
READ TABLE tl_parametros ASSIGNING FIELD-SYMBOL(<fs_wa_parametros_red_cst>)
WITH KEY campo = 'RED_CST'.
IF sy-subrc EQ 0.
IF <fs_wa_parametros_red_cst>-valor CA ';'.
SPLIT <fs_wa_parametros_red_cst>-valor AT ';' INTO TABLE tl_red_cst.
ELSE.
APPEND <fs_wa_parametros_red_cst>-valor TO tl_red_cst.
ENDIF.
ENDIF.

*** TRF CFOP
READ TABLE tl_parametros ASSIGNING FIELD-SYMBOL(<fs_wa_parametros_trf_cfop>)
WITH KEY campo = 'TRF_CFOP'.
IF sy-subrc EQ 0.
IF <fs_wa_parametros_trf_cfop>-valor CA ';'.
SPLIT <fs_wa_parametros_trf_cfop>-valor AT ';' INTO TABLE tl_trf_cfop.
ELSE.
APPEND <fs_wa_parametros_trf_cfop>-valor TO tl_trf_cfop.
ENDIF.
ENDIF.

*** TRF CST
READ TABLE tl_parametros ASSIGNING FIELD-SYMBOL(<fs_wa_parametros_trf_cst>)
WITH KEY campo = 'TRF_CST'.
IF sy-subrc EQ 0.
IF <fs_wa_parametros_trf_cst>-valor CA ';'.
SPLIT <fs_wa_parametros_trf_cst>-valor AT ';' INTO TABLE tl_trf_cst.
ELSE.
APPEND <fs_wa_parametros_trf_cst>-valor TO tl_trf_cst.
ENDIF.
ENDIF.

*** TRF FINNFE
READ TABLE tl_parametros ASSIGNING FIELD-SYMBOL(<fs_wa_parametros_trf_finnfe>)
WITH KEY campo = 'TRF_FINNFE'.
IF sy-subrc EQ 0.
IF <fs_wa_parametros_trf_finnfe>-valor CA ';'.
SPLIT <fs_wa_parametros_trf_finnfe>-valor AT ';' INTO TABLE tl_trf_finnfe.
ELSE.
APPEND <fs_wa_parametros_trf_finnfe>-valor TO tl_trf_finnfe.
ENDIF.
ENDIF.

*** WERKS
READ TABLE tl_parametros ASSIGNING FIELD-SYMBOL(<fs_wa_parametros_werks>)
WITH KEY campo = 'WERKS'.
IF sy-subrc EQ 0.
IF <fs_wa_parametros_werks>-valor CA ';'.
SPLIT <fs_wa_parametros_werks>-valor AT ';' INTO TABLE tl_werks.
ELSE.
APPEND <fs_wa_parametros_werks>-valor TO tl_werks.
ENDIF.
ENDIF.
ENDIF.

*** Monta Range dos Parametros Encontrados

*** Diferimento CST
LOOP AT tl_dif_cst ASSIGNING FIELD-SYMBOL(<fs_dif_cst>).
APPEND INITIAL LINE TO r1319_dif_cst ASSIGNING FIELD-SYMBOL(<fs_wa_dif_cst>).
<fs_wa_dif_cst>-sign    = 'I'.
<fs_wa_dif_cst>-option  = 'EQ'.
<fs_wa_dif_cst>-low     = <fs_dif_cst>.
ENDLOOP.

*** Isento CST
LOOP AT  tl_ise_cst ASSIGNING FIELD-SYMBOL(<fs_ise_cst>).
APPEND INITIAL LINE TO r1319_ise_cst ASSIGNING FIELD-SYMBOL(<fs_wa_ise_cst>).
<fs_wa_ise_cst>-sign    = 'I'.
<fs_wa_ise_cst>-option  = 'EQ'.
<fs_wa_ise_cst>-low     = <fs_ise_cst>.
ENDLOOP.

*** Redução CST
LOOP AT tl_red_cst ASSIGNING FIELD-SYMBOL(<fs_red_cst>).
APPEND INITIAL LINE TO r1319_red_cst ASSIGNING FIELD-SYMBOL(<fs_wa_red_cst>).
<fs_wa_red_cst>-sign    = 'I'.
<fs_wa_red_cst>-option  = 'EQ'.
<fs_wa_red_cst>-low     = <fs_red_cst>.
ENDLOOP.

*** Transferencia CST
LOOP AT tl_trf_cst ASSIGNING FIELD-SYMBOL(<fs_trf_cst>).
APPEND INITIAL LINE TO r1319_trf_cst ASSIGNING FIELD-SYMBOL(<fs_wa_trf_cst>).
<fs_wa_trf_cst>-sign    = 'I'.
<fs_wa_trf_cst>-option  = 'EQ'.
<fs_wa_trf_cst>-low     = <fs_trf_cst>.
ENDLOOP.

*** Transferencia CFOP
LOOP AT tl_trf_cfop ASSIGNING FIELD-SYMBOL(<fs_trf_cfop>).
APPEND INITIAL LINE TO r1319_trf_cfop ASSIGNING FIELD-SYMBOL(<fs_wa_trf_cfop>).
<fs_wa_trf_cfop>-sign    = 'I'.
<fs_wa_trf_cfop>-option  = 'EQ'.
<fs_wa_trf_cfop>-low     = <fs_trf_cfop>.
ENDLOOP.

*** Transferencia FINNFE
LOOP AT tl_trf_finnfe ASSIGNING FIELD-SYMBOL(<fs_trf_finnfe>).
APPEND INITIAL LINE TO r1319_trf_finnfe ASSIGNING FIELD-SYMBOL(<fs_wa_trf_finnfe>).
<fs_wa_trf_finnfe>-sign    = 'I'.
<fs_wa_trf_finnfe>-option  = 'EQ'.
<fs_wa_trf_finnfe>-low     = <fs_trf_finnfe>.
ENDLOOP.

*** WERKS
LOOP AT tl_werks ASSIGNING FIELD-SYMBOL(<fs_werks>).
APPEND INITIAL LINE TO r1319_werks ASSIGNING FIELD-SYMBOL(<fs_wa_werks>).
<fs_wa_werks>-sign    = 'I'.
<fs_wa_werks>-option  = 'EQ'.
<fs_wa_werks>-low     = <fs_werks>.
ENDLOOP.

"Tabela da OUT_HEADER da Fill_Header.
ASSIGN ('(SAPLJ_1B_NFE)XMLH') TO <xmlh>.
CHECK <xmlh> IS ASSIGNED.

*Se os parâmetros atenderem os requisitos abaixo:
IF   ( wl_nota-cst     IN r1319_ise_cst )      " Isenção
OR ( wl_nota-cst     IN r1319_red_cst )      " Redução
OR ( wl_nota-cst     IN r1319_dif_cst )      " Diferimento
OR ( wl_nota-cst     IN r1319_trf_cst        " Transferencia
AND   <xmlh>-finnfe   IN r1319_trf_finnfe )
AND   in_lin-werks    IN r1319_werks
AND   out_item-cbenef IS NOT INITIAL .

wl_nota-bukrs      = in_doc-bukrs.
wl_nota-branch     = in_doc-branch.
wl_nota-werks      = in_lin-werks.
wl_nota-parvw      = in_doc-parvw.
wl_nota-parid      = in_doc-parid.
wl_nota-docnum     = in_xml_item-docnum.
wl_nota-itmnum     = in_xml_item-itmnum.
wl_nota-cprod      = in_xml_item-cprod.
wl_nota-crt        = <xmlh>-crt.
wl_nota-finnfe     = <xmlh>-finnfe.
wl_nota-tpnf       = <xmlh>-tpnf.
wl_nota-emituf     = <xmlh>-cuf.
wl_nota-destuf     = <xmlh>-c1_uf.
wl_nota-cfop       = in_xml_item-cfop.
wl_nota-vicmsdeson = out_item-vicmsdeson.
wl_nota-motdesicms = out_item-motdeson.
wl_nota-cbenef     = out_item-cbenef.
wl_nota-vprod      = in_xml_item-vprod.
wl_nota-vicmsop    = out_item-vicmsop.
wl_nota-pdif       = out_item-picmsdif.
wl_nota-vicmsdif   = out_item-vicmsdif.
wl_nota-pstdat     = in_doc-pstdat(6).

CALL FUNCTION 'Z_PREENCHE_REGISTROS'
EXPORTING
it_nota          = wl_nota
r1319_dif_cst    = r1319_dif_cst
r1319_ise_cst    = r1319_ise_cst
r1319_red_cst    = r1319_red_cst
r1319_trf_cst    = r1319_trf_cst
r1319_trf_cfop   = r1319_trf_cfop
r1319_trf_finnfe = r1319_trf_finnfe
r1319_werks      = r1319_werks.

ENDIF.

***** CAST (CDN) 160394 RESOLUÇÃO SEFAZ 13.2019 - SPED EFD - FIM