Basicamente, você pode criar eventos para manipular a tela em diversos momentos. 
Quando o SAP estiver processando a tela, ele poderá passar pelos seguintes eventos:

AT SELECTION-SCREEN OUTPUT: Evento no PBO (process before output) da tela de seleção (antes dos valores serem exibidos).
AT SELECTION-SCREEN ON parameter/sel-option: Evento do PAI (process after input) para um PARAMETER ou SELECT-OPTIONS. Ideal para validar o input dos usuários em campos específicos. Lembrando que radiobuttons devem ser tratados no evento apropriado.
AT SELECTION-SCREEN ON RADIOBUTTON GROUP nomedogrupo: Mesmo coisa que o de cima, mas para Radiobuttons
AT SELECTION-SCREEN ON END OF sel-option: Irá passar aqui no final do preenchimento do sel-options em questão.
AT SELECTION-SCREEN ON BLOCK nomedobloco: No PAI também, no final do processamento do bloco XXX (aqueles que você define na declaração da tela!).
AT SELECTION-SCREEN (sim, nada mais): Esse é o mais chato. Sempre vai ser disparado, e sempre por último hahaha.
AT SELECTION-SCREEN ON HELP-REQUEST FOR parameter/sel-option: Quando alguem apertar F1 no campo especificado após o FOR.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR parameter/sel-option: quando alguem aertar F4 no campo especificado após o FOR
AT SELECTION-SCREEN ON EXIT-COMMAND: Sempre que o usuário quiser sair da tela, através do EXIT, BACK ou o CANCEL, vai passar por aqui :)

Exemplos abaixo:

REPORT zombie_at_selection_screen.
 
TABLES: mara.
 
* Tela de Seleção beeeem simples!
SELECTION-SCREEN BEGIN OF BLOCK bloco1.
 
* Um simples enter irá passar pelos eventos:
* AT SELECTION-SCREEN ON p_any.
* AT SELECTION-SCREEN ON RADIOBUTTON GROUP rb1.
* AT SELECTION-SCREEN ON BLOCK bloco1.
* AT SELECTION-SCREEN.
PARAMETER: p_any  TYPE mara-matnr.
 
* Apertando F1 nesse campo, irá parar no evento:
* AT SELECTION-SCREEN ON HELP-REQUEST FOR p_f1.
PARAMETER: p_f1   TYPE mara-matnr.
 
* Apertando F4 nesse campo, irá parar no evento:
* AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_f4.
PARAMETER: p_f4   TYPE mara-matnr.
 
* Se você preencher várias linhas aqui, ele irá parar no evento:
* AT SELECTION-SCREEN ON END OF s_any.
SELECT-OPTIONS: s_any FOR mara-matnr.
 
PARAMETER: p_sim RADIOBUTTON GROUP rb1,
           p_nao RADIOBUTTON GROUP rb1.
 
* Se você sair do Report, irá passar no evento
* AT SELECTION-SCREEN ON EXIT-COMMAND.
 
SELECTION-SCREEN END OF BLOCK bloco1.
 
* Como é no PBO, vai passar aqui antes de exibir a tela.
AT SELECTION-SCREEN OUTPUT.
  BREAK-POINT.
 
AT SELECTION-SCREEN ON p_any.
  BREAK-POINT.
 
AT SELECTION-SCREEN ON RADIOBUTTON GROUP rb1.
  BREAK-POINT.
 
AT SELECTION-SCREEN ON END OF s_any.
  BREAK-POINT.
 
AT SELECTION-SCREEN ON BLOCK bloco1.
  BREAK-POINT.
 
AT SELECTION-SCREEN ON HELP-REQUEST FOR p_f1.
  BREAK-POINT.
 
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_f4.
  BREAK-POINT.
 
* Se você tentar sair, vai parar aqui :)
AT SELECTION-SCREEN ON EXIT-COMMAND.
  BREAK-POINT.
 
AT SELECTION-SCREEN.
  BREAK-POINT.
