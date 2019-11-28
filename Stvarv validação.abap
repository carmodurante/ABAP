  DATA: rg_bsart_lc TYPE RANGE OF ekko-bsart.

  SELECT sign, opti, low, high
  FROM tvarvc
  INTO TABLE @DATA(tl_bsart_lc)
  WHERE name = 'ZMM_TEXTO_PED'.

  LOOP AT tl_bsart_lc ASSIGNING FIELD-SYMBOL(<fsl_t_bsart_lc>).
    APPEND INITIAL LINE TO rg_bsart_lc ASSIGNING FIELD-SYMBOL(<fsl_r_bsart_lc>).
    MOVE-CORRESPONDING <fsl_t_bsart_lc> TO <fsl_r_bsart_lc>.
    <fsl_r_bsart_lc>-option = <fsl_t_bsart_lc>-opti.
  ENDLOOP.