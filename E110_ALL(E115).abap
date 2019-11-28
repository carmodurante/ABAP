*&---------------------------------------------------------------------------------------------------
*" FQM_INC079710_160394 RESOLUÇÃO SEFAZ 13.2019 - SPED EFD
*" Consultoria: CAST GROUP
*" Consultor: Carmo Durante Neto
*" Data: 21/11/2019
*&---------------------------------------------------------------------------------------------------

IF gc_e110_ok EQ '1'.

  DATA :      gc_per  TYPE zt1319_e115-pstdat.
  FIELD-SYMBOLS : <fs_mes> TYPE any,
                  <fs_ano> TYPE any,
                  <fs_emp> TYPE any,
                  <fs_neg> TYPE any.

  ASSIGN ('(J_1BEFD_MAIN)P_MONTH')  TO <fs_mes>.
  ASSIGN ('(J_1BEFD_MAIN)P_YEAR')   TO <fs_ano>.
  ASSIGN ('(J_1BEFD_MAIN)J5_BUKRS') TO <fs_emp>.
  ASSIGN ('(J_1BEFD_MAIN)J5_BRNCH') TO <fs_neg>.

  IF   <fs_mes> IS ASSIGNED
  AND  <fs_ano> IS ASSIGNED
  AND  <fs_emp> IS ASSIGNED
  AND  <fs_neg> IS ASSIGNED.

    CONCATENATE <fs_ano>
                <fs_mes>
                INTO gc_per .

    SELECT *
      FROM zt1319_e115
      INTO TABLE @DATA(tl_zt1319_e115)
      WHERE pstdat  EQ @gc_per
        AND bukrs   EQ @<fs_emp>
        AND branch  EQ @<fs_neg>.

    IF tl_zt1319_e115 IS NOT INITIAL AND sy-subrc EQ 0.

      SELECT *
        FROM j_1bnfe_active
        INTO TABLE @DATA(tl_ativo)
        FOR ALL ENTRIES IN @tl_zt1319_e115
        WHERE docnum EQ @tl_zt1319_e115-docnum.

      LOOP AT tl_zt1319_e115 ASSIGNING FIELD-SYMBOL(<fs_wa_zt1319_e115>).
        READ TABLE tl_ativo ASSIGNING FIELD-SYMBOL(<fs_wa_ativo>)
        WITH KEY docnum = <fs_wa_zt1319_e115>-docnum.
        IF sy-subrc EQ 0 AND <fs_wa_ativo>-docsta EQ 1.
          APPEND INITIAL LINE TO cs_e110-tab_e115 ASSIGNING FIELD-SYMBOL(<fs_e115>).
          <fs_e115>-reg              = 'E115' .
          <fs_e115>-cod_inf_adic     = <fs_wa_zt1319_e115>-cod_inf_adic .
          <fs_e115>-vl_inf_adic      = <fs_wa_zt1319_e115>-vl_inf_adic .
          <fs_e115>-descr_compl_aj   = <fs_wa_zt1319_e115>-descr_compl_aj.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.