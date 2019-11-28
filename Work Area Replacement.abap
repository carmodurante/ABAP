
Se alterarmos qualquer campo da estrutura FIELD-SYMBOLS, 
o campo correspondente será atualizado. Não precisamos 
escrever a instrução MODIFY que teríamos escrito se tivéssemos usado 
a Work Area. Isso ocorre porque a área de trabalho armazena 
uma cópia da linha interna da tabela, enquanto o FIELD-SYMBOL
faz referência direta à linha interna da tabela.
Portanto, o processamento da tabela interna com o símbolo do campo 
é mais rápido que o processamento da tabela interna com a área de trabalho.

Exemplo:

DATA: lt_mara TYPE STANDARD TABLE OF mara.
FIELD-SYMBOLS: <fs_mara> TYPE mara.
SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.
LOOP AT lt_mara ASSIGNING <fs_mara>.
  <fs_mara>-matkl = 'DEMO'.
ENDLOOP.