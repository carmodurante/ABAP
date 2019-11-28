*&---------------------------------------------------------------------*
*& Report ZC00101 *
*& *
*&---------------------------------------------------------------------*
*& * WRITE FORMAT SKIP ULINE.
*& *
*&---------------------------------------------------------------------*
REPORT ZC00101.
WRITE 'HELLO AMANTINO'.
WRITE / 'HOJE É UM BELO DIA'. " A BARRA (/) QUEBRA DE LINHA
SKIP 2. " O COMANDO SKIP PULA LINHAS NA EMISSÃO DO RELATORIO
WRITE 'OLHA NOIS AQUI TRA VEZ'.
ULINE. " COLOCA UMA LINHA RETA
FORMAT COLOR COL_TOTAL. " FORMATA A SAIDA DO COMANDO WRITE
WRITE 'QUALQUER COISA'.
FORMAT COLOR COL_KEY.
WRITE / 'QUALQUER COISA'.
FORMAT COLOR COL_BACKGROUND. " VOLTA AO PADRÃO