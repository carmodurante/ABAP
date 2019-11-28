*-----------------------------
TYPE-POOLS: icon.
TABLES: sscrfields.

* Começo criando uma tela dummy
*------------------------------
SELECTION-SCREEN BEGIN OF BLOCK bl01 WITH FRAME.

PARAMETER: p_tela1 TYPE char10.

SELECTION-SCREEN END OF BLOCK bl01.

* Esses botões irão chamar as novas telas
*----------------------------------------
SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.
SELECTION-SCREEN FUNCTION KEY 3.

* Criação de uma nova tela de seleção. Bem simples!
*--------------------------------------------------
SELECTION-SCREEN BEGIN OF SCREEN 9000.

SELECTION-SCREEN COMMENT /1(40) text1.
PARAMETER: p_nova TYPE char10.

SELECTION-SCREEN END OF SCREEN 9000.

* Outra tela de seleção. Você pode criar quantas quiser
* (apesar que a numeração de telas tem só 4 digitos.. enfim :P)
*--------------------------------------------------------------
SELECTION-SCREEN BEGIN OF SCREEN 9001.

SELECTION-SCREEN COMMENT /1(40) text2.
PARAMETER: p_popup TYPE char10.

SELECTION-SCREEN END OF SCREEN 9001.


SELECTION-SCREEN BEGIN OF SCREEN 9002.

SELECTION-SCREEN COMMENT /1(40) text3.
PARAMETER: p_popup1 TYPE char10.

SELECTION-SCREEN END OF SCREEN 9002.

* Evento para colcoar texto no comentários e ajustar os botões
*-------------------------------------------------------------
INITIALIZATION.

  PERFORM cria_botao.

  text1 = 'Tela Nova em Tela Cheia!'.
  text2 = 'Tela Nova como Pop-up!'.
  text3 = 'JEQUITI!'.

* Acerto das chamadas das novas telas.
*------------------------------------
AT SELECTION-SCREEN.

  CASE sy-ucomm.

*  Neste caso, chamando a tela como uma nova tela fullscreen.
    WHEN 'FC01'.
      CALL SELECTION-SCREEN 9000.

*  Aqui, chamando a nova tela como um pop-up
    WHEN 'FC02'.
      CALL SELECTION-SCREEN 9001 STARTING AT 5 5 ENDING AT 50 8.

    WHEN 'FC03'.
      CALL SELECTION-SCREEN 9002 STARTING AT 5 5 ENDING AT 50 8.

  ENDCASE.

* O form abaixo é do post da PARTE 1 da sequência Tela de Seleção
* turbinada. Estou usando para preencher os dados dos botões.
*&---------------------------------------------------------------------*
*&      Form  cria_botao
*&---------------------------------------------------------------------*
FORM cria_botao .

  DATA: wa_button TYPE smp_dyntxt.

  wa_button-text      = 'Tela Cheia'.
  wa_button-icon_id   = icon_businav_szenario.
  wa_button-icon_text = 'Tela Cheia'.
  sscrfields-functxt_01 = wa_button.

  wa_button-text      = 'Tela Pop-Up'.
  wa_button-icon_id   = icon_system_modus_create.
  wa_button-icon_text = 'Tela Pop-Up'.
  sscrfields-functxt_02 = wa_button.

  wa_button-text      = 'Jequiti'.
  wa_button-icon_id   = icon_system_modus_create.
  wa_button-icon_text = 'Jequiti'.
  sscrfields-functxt_03 = wa_button.

ENDFORM.                    " cria_botao