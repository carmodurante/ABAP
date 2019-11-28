*&---------------------------------------------------------------------*
*& Report ZC0307 *
*& *
*&---------------------------------------------------------------------*
*& Criar objetos de autorização *
*& *
*&---------------------------------------------------------------------*
REPORT ZC0307 message-id Z001.
TABLES: ZTAB1_03.
DATA: BEGIN OF T_ZTAB103 OCCURS 0,
TEXTO(100) TYPE C,
END OF T_ZTAB103.
DATA: BEGIN OF T_ZTAB1_03 OCCURS 0.
INCLUDE STRUCTURE ZTAB1_03.
DATA END OF T_ZTAB1_03.
* CRIANDO UMA CONSTANTE QUE INFORMA DELIMITADOR DO
* ARQUIVOS .TXT QUE SERÁ LIDO PARA O BATCH INPUT
CONSTANTS: C_DELIMITADOR TYPE C VALUE';',
C_NOME(8) TYPE C VALUE 'ABAP'.
SELECTION-SCREEN BEGIN OF BLOCK B_001 WITH FRAME TITLE TEXT-001.
PARAMETERS P_TEXTO LIKE RLGRAP-FILENAME.
SELECTION-SCREEN END OF BLOCK B_001.
START-OF-SELECTION.
PERFORM F_CARDADOS.
END-OF-SELECTION.
*&---------------------------------------------------------------------*
*& Form F_CARDADOS
*----------------------------------------------------------------------*
FORM F_CARDADOS .
* data: vl_nome(8) type c.
* vl_nome = sy-uname.
* if vl_nome ne C_NOME.
* MESSAGE E006 WITH TEXT-E01.
* endif.
* comando para verificar autorização de objeto
* usar junto com su21 e su24
authority-check object 'ZZC0307Y'
* objetos da autorização
* ID 'nome_do_objeto' FIELD 'campo'
* id 'TCD' field 'DUMMY'.
id 'ACTVT' field 'DUMMY'.
IF SY-SUBRC NE 0.
MESSAGE E006 WITH TEXT-E01.
ENDIF.
ENDFORM. " F_CARDADOS