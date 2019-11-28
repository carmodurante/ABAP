  CONSTANTS: BEGIN OF c_r1319, "Constantes para nota tecnica da nota 13.2019 da SEFAZ
    cst_isen_30 TYPE p LENGTH 2 VALUE '30',   "30" – CST Referente ao Benefício de Isenção
    cst_isen_40 TYPE p LENGTH 2 VALUE '40',   "40" – CST Referente ao Benefício de Isenção
    cst_redu_20 TYPE p LENGTH 2 VALUE '20',   "20" – CST Referente ao Benefício de Red Base ou Aliquota
    cst_redu_70 TYPE p LENGTH 2 VALUE '70',   "70" – CST Referente ao Benefício de Red Base ou Aliquota
    cst_dife    TYPE p LENGTH 2 VALUE '51',   "51" – CST Referente ao Benefício de Diferimento
    cst_tran    TYPE p LENGTH 2 VALUE '90',   "90" – CST Referente ao Benefício de Transferencia Saldo Credor
    cfop_trans  TYPE p LENGTH 4 VALUE '5601', "5601" - CFOP TRANSFERENCIA SALDO CREDOR
    finnfe_t    TYPE p LENGTH 1 VALUE '3',    "3" - Tag Finalidade da Nfe
    tpnf_ent    TYPE p LENGTH 1 VALUE '0',    "0" - ENTRADA
    tpnf_sai    TYPE p LENGTH 1 VALUE '1',    "1" - SAIDA
    werks       TYPE p LENGTH 4 VALUE '0103', "0103" – Centro RJ válido para solução
    END OF c_r1319.  