Podemos atribuir qualquer tabela interna a um Field-Symbols. 

FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.
FIELD-SYMBOLS: <fs_str> TYPE ANY.
FIELD-SYMBOLS: <fs_data> TYPE ANY.

DATA: lt_mara TYPE STANDARD TABLE OF mara.
DATA: lw_mara TYPE mara.

ASSIGN lt_mara TO <fs_tab>.
SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.

LOOP AT <fs_tab> ASSIGNING <fs_str>.
  IF <fs_str> IS ASSIGNED.
    ASSIGN COMPONENT 'MATKL' OF STRUCTURE <fs_str> TO <fs_data>.
    IF <fs_data> IS ASSIGNED.
      IF <fs_data> EQ '01'.

*********** Faz algum processo aqui *********

      ENDIF.
      UNASSIGN <fs_data>. " Sempre dar um UNASSIGN depois de efetuar os processos.
    ENDIF.
  ENDIF.
ENDLOOP.

*-> Lendo tabela interna usando o Field-Symbol genérico:

FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.
FIELD-SYMBOLS: <fs_str> TYPE ANY.
DATA: lt_mara TYPE STANDARD TABLE OF mara.

ASSIGN lt_mara TO <fs_tab>.
SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.

READ TABLE <fs_tab> ASSIGNING <fs_str> WITH KEY ('MATNR') = 'MAT001'.

->> Como <fs_tab> é um Field-Symbol genérico, seu tipo será conhecido apenas em tempo de execução; 
portanto, não podemos escrever diretamente os campos da estrutura MARA após WITH KEY.
Precisamos escrever o nome do campo entre parênteses: ('MATNR').

->> Esse parêntese indica ao compilador que o valor do operando será 
decidido no tempo de execução; portanto, não obtemos nenhum erro de compilação.
 
 