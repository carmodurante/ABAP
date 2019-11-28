Após executar esse codigo a tabela interna lt_mara terá duas linhas.

DATA: lt_mara TYPE STANDARD TABLE OF mara.
FIELD-SYMBOLS: <fs_mara> TYPE mara.

APPEND INITIAL LINE TO lt_mara ASSIGNING <fs_mara>.
IF <fs_mara> IS ASSIGNED.
  <fs_mara>-matnr = 'MAT1'.
  <fs_mara>-matkl = '001'.
  UNASSIGN <fs_mara>.
ENDIF.

APPEND INITIAL LINE TO lt_mara ASSIGNING <fs_mara>.
IF <fs_mara> IS ASSIGNED.
  <fs_mara>-matnr = 'MAT2'.
  <fs_mara>-matkl = '001'.
  UNASSIGN <fs_mara>.
ENDIF.

OBS: Sempre executar um check no Field-Symbol se está assigned,
antes de fazer qualquer operação, isso evitara dumps.
Após efetuar a operação faça um Unassign.