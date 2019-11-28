*----------------------------------------------------------------------*
***INCLUDE MZTXT01_PAI_9020 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module USER_COMMAND_EXIT_9020 INPUT
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_EXIT_9020 INPUT.
PERFORM USER_COMMAND_EXIT_9020.
ENDMODULE. " USER_COMMAND_EXIT_9020 INPUT
*&---------------------------------------------------------------------*
*& Form USER_COMMAND_EXIT_9020
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM USER_COMMAND_EXIT_9020 .
DATA vl_okcode LIKE sy-ucomm.
vl_okcode = vg_okcode_9020.
CLEAR vg_okcode_9020.
CASE vl_okcode.
WHEN 'BACK' OR 'RW'.
* VOLTAR PARA A TELA 9000
LEAVE TO SCREEN 9010.
WHEN 'END'.
* SAIR DO PROGRAMA
LEAVE PROGRAM.
* LEAVE TO SCREEN 9010.
ENDCASE.
ENDFORM. " USER_COMMAND_EXIT_9020
COMANDO EXECUTADOS DENTRO DA TELA ( nome de tela )
PROCESS BEFORE OUTPUT.
MODULE STATUS_9000.
*
PROCESS AFTER INPUT.
* MODULO PARA TRATAR OS BOTAO DA PRIMEIRA TELA
* SO ENTRAR SE OS BOTAO TEM O PARAMETRO "E"
* AT EXIT-COMMAND.
* DEVE ESTAR EM PRIMEIRO
MODULE USER_COMMAND_EXIT_9000 AT EXIT-COMMAND.
* MODULO QUE VAI TRARTAR O BOTÃO CRIADO
MODULE USER_COMMAND_9000.
