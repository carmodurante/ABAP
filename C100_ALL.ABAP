***** CAST (CDN) 160394 RESOLUÇÃO SEFAZ 13.2019 - SPED EFD - INICIO.

FIELD-SYMBOLS: <t_j_1bnflin> TYPE j_1bnflin,
<fs_bukrs>    TYPE j_1bnfdoc-bukrs,
<fs_branch>   TYPE j_1bnfdoc-branch.

ASSIGN: ('(J_1BEFD_MAIN)J5_BUKRS') TO <fs_bukrs>,
        ('(J_1BEFD_MAIN)J5_BRNCH') TO <fs_branch>,
        ('(SAPDBJ5F)J_1BNFLIN')    TO <t_j_1bnflin>.

*** C100 INICIO
SELECT SINGLE *
FROM zt1319_c100
INTO @DATA(wa_zt1319_c100)
WHERE docnum EQ @<t_j_1bnflin>-docnum
AND   itmnum EQ @<t_j_1bnflin>-itmnum.

IF sy-subrc EQ 0 AND wa_zt1319_c100 IS NOT INITIAL.
SELECT SINGLE *
FROM j_1bnfe_active
INTO @DATA(wa_j_1bnfe_active_c100)
WHERE docnum EQ @wa_zt1319_c100-docnum.

IF wa_j_1bnfe_active_c100-docsta EQ 1 AND sy-subrc EQ 0.
cs_c100-vl_icms = wa_zt1319_c100-vl_icms.
ENDIF.
ENDIF.
*** C100 FIM.
*** C195/C197 INICIO.

SELECT SINGLE *
FROM zt1319_c197
INTO @DATA(wa_zt1319_c197)
WHERE docnum EQ @<t_j_1bnflin>-docnum
AND   itmnum EQ @<t_j_1bnflin>-itmnum.

IF sy-subrc EQ 0 AND wa_zt1319_c197 IS NOT INITIAL.
SELECT SINGLE *
FROM j_1bnfe_active
INTO @DATA(wa_j_1bnfe_active_c197)
WHERE docnum EQ @wa_zt1319_c197-docnum.

IF wa_j_1bnfe_active_c197-docsta EQ 1 AND sy-subrc EQ 0.
IF cs_c100-tab_c195 IS INITIAL.
*** C195
APPEND INITIAL LINE TO cs_c100-tab_c195 ASSIGNING FIELD-SYMBOL(<fs_wa_tab_c195>).
<fs_wa_tab_c195>-reg = 'C195'.
<fs_wa_tab_c195>-cod_obs = ' '.
<fs_wa_tab_c195>-txt_compl = wa_zt1319_c197-cod_aj.
*** C197
IF <fs_wa_tab_c195>-tab_c197 IS INITIAL.
APPEND INITIAL LINE TO <fs_wa_tab_c195>-tab_c197 ASSIGNING FIELD-SYMBOL(<fs_wa_tab_c197>).
<fs_wa_tab_c197>-reg            = 'C197'.
<fs_wa_tab_c197>-cod_aj         = wa_zt1319_c197-cod_aj.
<fs_wa_tab_c197>-descr_compl_aj = wa_zt1319_c197-descr_compl_aj.
<fs_wa_tab_c197>-cod_item       = wa_zt1319_c197-cod_item.
<fs_wa_tab_c197>-vl_bc_icms     = wa_zt1319_c197-vl_bc_icms.
<fs_wa_tab_c197>-aliq_icms      = wa_zt1319_c197-aliq_icms.
<fs_wa_tab_c197>-vl_icms        = wa_zt1319_c197-vl_icms.
<fs_wa_tab_c197>-vl_outros      = wa_zt1319_c197-vl_outros.
ENDIF.
ELSE.
READ TABLE cs_c100-tab_c195 ASSIGNING FIELD-SYMBOL(<fs_wa_tab_c195_upt>) INDEX 1.
IF <fs_wa_tab_c195_upt>-tab_c197 IS NOT INITIAL.
READ TABLE <fs_wa_tab_c195_upt>-tab_c197 ASSIGNING FIELD-SYMBOL(<fs_wa_tab_c197_upt>) INDEX 1.
<fs_wa_tab_c197_upt>-reg         = 'C197'.
<fs_wa_tab_c197_upt>-cod_aj         = wa_zt1319_c197-cod_aj.
<fs_wa_tab_c197_upt>-descr_compl_aj = wa_zt1319_c197-descr_compl_aj.
<fs_wa_tab_c197_upt>-cod_item       = wa_zt1319_c197-cod_item.
<fs_wa_tab_c197_upt>-vl_bc_icms     = wa_zt1319_c197-vl_bc_icms.
<fs_wa_tab_c197_upt>-aliq_icms      = wa_zt1319_c197-aliq_icms.
<fs_wa_tab_c197_upt>-vl_icms        = wa_zt1319_c197-vl_icms.
<fs_wa_tab_c197_upt>-vl_outros      = wa_zt1319_c197-vl_outros.
ELSE.
APPEND INITIAL LINE TO <fs_wa_tab_c195_upt>-tab_c197 ASSIGNING FIELD-SYMBOL(<fs_wa_tab_c197_add>).
<fs_wa_tab_c197_add>-reg            = 'C197'.
<fs_wa_tab_c197_add>-cod_aj         = wa_zt1319_c197-cod_aj.
<fs_wa_tab_c197_add>-descr_compl_aj = wa_zt1319_c197-descr_compl_aj.
<fs_wa_tab_c197_add>-cod_item       = wa_zt1319_c197-cod_item.
<fs_wa_tab_c197_add>-vl_bc_icms     = wa_zt1319_c197-vl_bc_icms.
<fs_wa_tab_c197_add>-aliq_icms      = wa_zt1319_c197-aliq_icms.
<fs_wa_tab_c197_add>-vl_icms        = wa_zt1319_c197-vl_icms.
<fs_wa_tab_c197_add>-vl_outros      = wa_zt1319_c197-vl_outros.
ENDIF.
ENDIF.
ENDIF.
ENDIF.
*** C195/C197 FIM.
***** CAST (CDN) 160394 RESOLUÇÃO SEFAZ 13.2019 - SPED EFD - FIM.