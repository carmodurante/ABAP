Pode ser lido um valor de uma tabela interna com o field-symbol
conforme abaixo:

*- Exemplo 1 READ TABLE simples:

READ TABLE lt_mara ASSIGNING <fs_mara> WITH KEY matnr = 'MAT1'.

*- Exemplo 2 LOOP + READ TABLE:

 LOOP AT affwb_out_tab ASSIGNING <affwb_out_tab>.

    UNASSIGN <fsl_mard_resb>.
    READ TABLE it_mard_resb ASSIGNING <fsl_mard_resb>
       WITH KEY MATNR = <affwb_out_tab>-matnr
                WERKS = <affwb_out_tab>-WERKS
                LGORT = <affwb_out_tab>-LGORT.

       IF <fsl_mard_resb> IS ASSIGNED.
         <affwb_out_tab>-MSGV2 = <fsl_mard_resb>-erfmg - <fsl_mard_resb>-ENMNG.
      ENDIF.

  ENDLOOP.

*OBS: Todos os FIELD-SYMBOL são declarados como WA do tipo da tabela.