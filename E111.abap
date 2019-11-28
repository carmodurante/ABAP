**** CAST (CDN) 160394 RESOLUÇÃO SEFAZ 13.2019 - SPED EFD - INICIO.
SELECT *
FROM zt1319_e111
INTO TABLE @DATA(tl_zt1319_e111)
WHERE pstdat = @gc_per
  AND bukrs  = @<fs_emp>
  AND branch = @<fs_neg>.

IF tl_zt1319_e111 IS NOT INITIAL AND sy-subrc EQ 0.

SELECT *
  FROM j_1bnfe_active
  INTO TABLE @DATA(tl_j_1bnfe_active)
  FOR ALL ENTRIES IN @tl_zt1319_e111
  WHERE docnum EQ @tl_zt1319_e111-docnum.

IF sy-subrc EQ 0 AND tl_j_1bnfe_active IS NOT INITIAL.

  LOOP AT tl_zt1319_e111 ASSIGNING FIELD-SYMBOL(<fs_wa_zt1319_e111>).
    READ TABLE tl_j_1bnfe_active ASSIGNING FIELD-SYMBOL(<fs_wa_j_1bnfe_active>)
    WITH KEY docnum = <fs_wa_zt1319_e111>-docnum.

    IF sy-subrc EQ 0 AND <fs_wa_j_1bnfe_active>-docsta = 1.
      APPEND INITIAL LINE TO ct_e111 ASSIGNING FIELD-SYMBOL(<fs_gs_e111>).
      <fs_gs_e111>-reg             = 'E111' .
      <fs_gs_e111>-cod_aj_apur     = gs_ajuste-cod_ajuste.
      <fs_gs_e111>-descr_compl_aj  = gs_cod_ajuste-descr .
      <fs_gs_e111>-vl_aj_apur      = gs_ajuste-valor_ajuste .

**      Sumarizar informações no E110
      CASE <fs_gs_e111>-cod_aj_apur+2(2) .

        WHEN '00' .
          ADD <fs_gs_e111>-vl_aj_apur TO gs_e110_aux-vl_tot_aj_debitos .
        WHEN '01' .
          ADD <fs_gs_e111>-vl_aj_apur TO gs_e110_aux-vl_estornos_cred .
        WHEN '02' .
          ADD <fs_gs_e111>-vl_aj_apur TO gs_e110_aux-vl_tot_aj_creditos.
        WHEN '03' .
          ADD <fs_gs_e111>-vl_aj_apur TO gs_e110_aux-vl_estornos_deb .
        WHEN '04' .
          ADD <fs_gs_e111>-vl_aj_apur TO gs_e110_aux-vl_tot_ded .
        WHEN '05' .
          ADD <fs_gs_e111>-vl_aj_apur TO gs_e110_aux-deb_esp .
      ENDCASE.

      gs_e110_aux-vl_sld_apurado =
      ( gs_e110_aux-vl_tot_debitos     +
        gs_e110_aux-vl_aj_debitos      +
        gs_e110_aux-vl_tot_aj_debitos  +
        gs_e110_aux-vl_estornos_cred )
        -
      ( gs_e110_aux-vl_tot_creditos    +
        gs_e110_aux-vl_aj_creditos     +
        gs_e110_aux-vl_tot_aj_creditos +
        gs_e110_aux-vl_estornos_deb    +
        gs_e110_aux-vl_sld_credor_ant  ).

      IF gs_e110_aux-vl_sld_apurado > 0 .
        gs_e110_aux-vl_sld_credor_transportar = 0 .
      ELSE.
        gs_e110_aux-vl_sld_credor_transportar = abs( gs_e110_aux-vl_sld_apurado ).
        gs_e110_aux-vl_sld_apurado = 0 .
      ENDIF.

    ENDIF.
  ENDLOOP.

  gs_e110-vl_aj_creditos             = gs_e110-vl_aj_creditos            + gs_e110_aux-vl_aj_creditos.
  gs_e110-vl_aj_debitos              = gs_e110-vl_aj_debitos             + gs_e110_aux-vl_aj_debitos.
  gs_e110-vl_estornos_cred           = gs_e110-vl_estornos_cred          + gs_e110_aux-vl_estornos_cred.
  gs_e110-vl_estornos_deb            = gs_e110-vl_estornos_deb           + gs_e110_aux-vl_estornos_deb.
  gs_e110-vl_icms_recolher           = gs_e110-vl_icms_recolher          + gs_e110_aux-vl_icms_recolher.
  gs_e110-vl_sld_apurado             = gs_e110-vl_sld_apurado            + gs_e110_aux-vl_sld_apurado.
  gs_e110-vl_sld_credor_ant          = gs_e110-vl_sld_credor_ant         + gs_e110_aux-vl_sld_credor_ant.
  gs_e110-vl_sld_credor_transportar  = gs_e110-vl_sld_credor_transportar + gs_e110_aux-vl_sld_credor_transportar.
  gs_e110-vl_tot_aj_creditos         = gs_e110-vl_tot_aj_creditos        + gs_e110_aux-vl_tot_aj_creditos.
  gs_e110-vl_tot_aj_debitos          = gs_e110-vl_tot_aj_debitos         + gs_e110_aux-vl_tot_aj_debitos.
  gs_e110-vl_tot_creditos            = gs_e110-vl_tot_creditos           + gs_e110_aux-vl_tot_creditos.
  gs_e110-vl_tot_debitos             = gs_e110-vl_tot_debitos            + gs_e110_aux-vl_tot_debitos.
  gs_e110-vl_tot_ded                 = gs_e110-vl_tot_ded                + gs_e110_aux-vl_tot_ded.
ENDIF.
ENDIF.
***** CAST (CDN) 160394 RESOLUÇÃO SEFAZ 13.2019 - SPED EFD - FIM.