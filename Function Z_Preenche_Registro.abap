FUNCTION z_preenche_registros.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IT_NOTA) TYPE  ZST_NOTA OPTIONAL
*"     REFERENCE(R1319_DIF_CST) TYPE  EFG_TAB_RANGES OPTIONAL
*"     REFERENCE(R1319_ISE_CST) TYPE  EFG_TAB_RANGES OPTIONAL
*"     REFERENCE(R1319_RED_CST) TYPE  EFG_TAB_RANGES OPTIONAL
*"     REFERENCE(R1319_TRF_CST) TYPE  EFG_TAB_RANGES OPTIONAL
*"     REFERENCE(R1319_TRF_CFOP) TYPE  EFG_TAB_RANGES OPTIONAL
*"     REFERENCE(R1319_TRF_FINNFE) TYPE  EFG_TAB_RANGES OPTIONAL
*"     REFERENCE(R1319_WERKS) TYPE  EFG_TAB_RANGES OPTIONAL
*"----------------------------------------------------------------------

  CONSTANTS: BEGIN OF c_r1319, "Constantes para nota tecnica da nota 13.2019 da SEFAZ
               tpnf_ent TYPE p LENGTH 1 VALUE '0',    "0" - ENTRADA
               tpnf_sai TYPE p LENGTH 1 VALUE '1',    "1" - SAIDA
             END OF c_r1319.

  " STRUCTURES
  DATA: wa_zt1319_e115 TYPE zt1319_e115,
        wa_zt1319_c197 TYPE zt1319_c197,
        wa_zt1319_e111 TYPE zt1319_e111,
        wa_zt1319_c100 TYPE zt1319_c100.

  " Benefício Isenção
  IF    it_nota-cst     IN r1319_ise_cst
    AND it_nota-werks   IN r1319_werks
    AND it_nota-cbenef  IS NOT INITIAL.

    "Registro E111 Tabela ZT1319_E111
    wa_zt1319_e111-docnum           = it_nota-docnum.
    wa_zt1319_e111-itmnum           = it_nota-itmnum.
*    wa_zt1319_e111-cod_aj_apur      = 'RJ018003'. " Verificar
    wa_zt1319_e111-descr_compl_aj   = it_nota-cbenef.
*    wa_zt1319_e111-vl_aj_apur       = '0,20'. " verificar qual sera o valor e onde?
    wa_zt1319_e111-pstdat           = it_nota-pstdat.
    MODIFY zt1319_e111 FROM wa_zt1319_e111.
  ENDIF.

*** Tabelas em comuns para Redução/Diferimento/Transferencia.
  IF    (   it_nota-cst    IN r1319_red_cst    ) " Benefício Redução
     OR (   it_nota-cst    IN r1319_dif_cst    ) " Benefício Diferimento
     OR (   it_nota-cst    IN r1319_trf_cst      " Benefício Transferencia
    AND     it_nota-finnfe IN r1319_trf_finnfe )
    AND     it_nota-werks  IN r1319_werks
    AND     it_nota-cbenef IS NOT INITIAL.

    IF it_nota-tpnf EQ c_r1319-tpnf_ent. "Se for nota de entrada salva o C100.
      "Registro C100 Tabela zt1319_c100
      wa_zt1319_c100-bukrs      = it_nota-bukrs.
      wa_zt1319_c100-branch     = it_nota-branch.
      wa_zt1319_c100-docnum     = it_nota-docnum.
      wa_zt1319_c100-itmnum     = it_nota-itmnum.
      wa_zt1319_c100-vl_icms    = it_nota-vicms.
      wa_zt1319_c100-pstdat     = it_nota-pstdat.
      MODIFY zt1319_c100 FROM wa_zt1319_c100.
    ENDIF.
  ENDIF.

  "Tabelas em comuns para Isenção/Redução/Diferimento/Repasse.
  IF    ( it_nota-cst    IN r1319_ise_cst    ) " Isenção
     OR ( it_nota-cst    IN r1319_red_cst    ) " Redução
     OR ( it_nota-cst    IN r1319_dif_cst    ) " Diferimento
     OR ( it_nota-cst    IN r1319_trf_cst
    AND   it_nota-finnfe IN r1319_trf_finnfe ) " Transferencia
    AND   it_nota-werks  IN r1319_werks
    AND   it_nota-cbenef IS NOT INITIAL .

    "Registro E115 Tabela ZT1319_E115.
    wa_zt1319_e115-bukrs            = it_nota-bukrs.
    wa_zt1319_e115-branch	          = it_nota-branch.
    wa_zt1319_e115-docnum	          = it_nota-docnum.
    wa_zt1319_e115-itmnum	          = it_nota-itmnum.
    wa_zt1319_e115-cod_inf_adic	    = it_nota-cbenef.
    wa_zt1319_e115-vl_inf_adic      = '0'.
    wa_zt1319_e115-descr_compl_aj	  = ' '.
    wa_zt1319_e115-pstdat           = it_nota-pstdat.
    MODIFY zt1319_e115 FROM wa_zt1319_e115.

    "Registro C197 Tabela ZT1319_C197.
    wa_zt1319_c197-bukrs          = it_nota-bukrs.
    wa_zt1319_c197-branch         = it_nota-branch.
    wa_zt1319_c197-docnum         = it_nota-docnum.
    wa_zt1319_c197-itmnum         = it_nota-itmnum.
*    wa_zt1319_c197-cod_aj         = 'rj90980000' " VERIFICAR SE VAI SER DIFERENTE PARA CADA REGISTRO.
    wa_zt1319_c197-descr_compl_aj = it_nota-cbenef.
    wa_zt1319_c197-cod_item       = it_nota-cprod.
    wa_zt1319_c197-vl_bc_icms     = ''.
    wa_zt1319_c197-aliq_icms      = ''.
    wa_zt1319_c197-vl_icms        = ''.
    wa_zt1319_c197-vl_outros      = it_nota-vicmsdeson.
    wa_zt1319_c197-pstdat         = it_nota-pstdat.
    MODIFY zt1319_c197 FROM wa_zt1319_c197.

    CLEAR: wa_zt1319_e111,
           wa_zt1319_e115,
           wa_zt1319_c197,
           wa_zt1319_c100.
  ENDIF.

ENDFUNCTION.