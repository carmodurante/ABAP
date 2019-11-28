A programação dinâmica é realmente implementada usando símbolos de campo genéricos. 
Os tipos genéricos mais usados ​​são TYPE ANY e TYPE ANY TABLE .

*Exemplo Declaração:
FIELD-SYMBOLS: <fs_str> TYPE ANY.
FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.

TYPE ANY : "podemos atribuir qualquer objeto de dados ao símbolo do campo
TYPE ANY TABLE "é usado para atribuir qualquer tabela interna.

*Assign uma work area do type MARA to TYPE ANY field symbol, popular a work area usando field symbol.

FIELD-SYMBOLS: <fs_str> TYPE ANY.
FIELD-SYMBOLS: <fs_data> TYPE ANY.

DATA: lw_mara TYPE mara.

ASSIGN lw_mara TO <fs_str>.
IF <fs_str> IS ASSIGNED.
  ASSIGN COMPONENT 'MATNR' OF STRUCTURE <fs_str> TO <fs_data>.
  IF <fs_data> IS ASSIGNED.
    <fs_data> = 'MAT001'.
    UNASSIGN <fs_data>.
    ENDIF.
  UNASSIGN <fs_str>.
ENDIF.

->> Após atribuir lw_mara TO <fs_str>, não podemos usar diretamente o operador 
'-' no field-symbol para acessar os campos da estrutura MARA, ou seja, 
<fs_str>-matnr produziria erro de sintaxe. Isso ocorre porque o tipo de símbolo 
do campo é declarado apenas no tempo de execução e não no tempo de compilação.

->> Portanto para acessar o campo MATNR com o FIELD-symbol, é necessário
atribuir o componente do campo a um Field-Symbol diferente e em
seguida usar o novo para atualizar o matnr.

ASSIGN COMPONENT 'MATNR' OF STRUCTURE <fs_str> TO <fs_data>.
  IF <fs_data> IS ASSIGNED.
    <fs_data> = 'MAT001'.
