REPORT  zppbap_rfc_assincrona.
**********************************************************************
* VARI�VEIS GLOBAIS (V_...)                                          *
**********************************************************************
DATA: v_tasks        TYPE i,
      v_task_id      TYPE numc2,
      v_task_count   TYPE i,
      v_task_ativa   TYPE i.

**********************************************************************
* TABELA INTERNA (T_...)                                             *
**********************************************************************
DATA: t_bseg      TYPE TABLE OF bseg,
      t_bseg_aux  TYPE TABLE OF bseg.

**********************************************************************
* TABELA                                                             *
**********************************************************************
TABLES: bseg.

**********************************************************************
* PAR�METROS DE TELA:                                                *
*   SELECT OPTIONS (S_...)                                           *
*   PARAMETERS     (P_...)                                           *
**********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.

SELECT-OPTIONS: s_gjahr FOR bseg-gjahr OBLIGATORY NO INTERVALS. "Ano
* Obs. Estou utilizando apenas como chave o campo GJAHR, pois o ambiente
* que estou fazendo testes n�o possui muitos registros

SELECTION-SCREEN END OF BLOCK b1.

**********************************************************************
* START-OF-SELECTION                                                 *
**********************************************************************
START-OF-SELECTION.
  DATA: wa_gjahr LIKE LINE OF s_gjahr.

* Obter o n�mero de sess�es dispon�veis
  CALL FUNCTION 'SPBT_INITIALIZE'
    IMPORTING
      free_pbt_wps                   = v_tasks
    EXCEPTIONS
      invalid_group_name             = 1
      internal_error                 = 2
      pbt_env_already_initialized    = 3
      currently_no_resources_avail   = 4
      no_pbt_resources_found         = 5
      cant_init_different_pbt_groups = 6
      OTHERS                         = 7.

  IF sy-subrc <> 0.
*** Mensagem de erro
    LEAVE LIST-PROCESSING.
  ENDIF.

* Para cada ano informado na tela de sele��o, ser� chamada a RFC
  LOOP AT s_gjahr INTO wa_gjahr.

* Como n�o sabemos a quantidade de registros, devemos controlar quantas sess�es ser�o geradas
    DO.

* Incrementar ao contador de sess�es ativas
      ADD 1 TO v_task_ativa.

* Verificar se o n�mero de sess�es ativas est� dentro do limite
      IF v_task_ativa <= v_tasks.

* Cada sess�o dever� ter um ID �nico
        ADD 1 TO v_task_id.

* Chamar a RFC em uma nova sess�o
        CALL FUNCTION 'Z_RFC_ASSINC'
          STARTING NEW TASK v_task_id
          DESTINATION IN GROUP DEFAULT
          PERFORMING update_order ON END OF TASK
          EXPORTING
            i_gjahr = wa_gjahr-low
          EXCEPTIONS
            OTHERS  = 1.

        IF sy-subrc <> 0.
* Se a RFC falhar, vamos tentar novamente e diminuir o n�mero de sess�es ativas. Cuidado para n�o entrar
* em loop infinito!!
          SUBTRACT 1 FROM v_task_ativa.
        ELSE.
          EXIT.
        ENDIF.
      ELSE.
        SUBTRACT 1 FROM v_task_ativa.
      ENDIF.
    ENDDO.
  ENDLOOP.

  IF sy-subrc IS INITIAL.
* Esperar at� que todas as sess�es sejam finalizadas. O n�mero � decrementado na subrtoina abaixo
* e incrementado quando a RFC � chamada.
    WAIT UNTIL v_task_ativa = 0.

*** Neste ponto voc� poder� utilizar os resultados retornados da RFC para continuar a l�gica do programa

  ENDIF.

**********************************************************************
* SUBROTINA                                                          *
**********************************************************************
FORM update_order USING name.

* Obter os resultados da RFC
  RECEIVE RESULTS FROM FUNCTION 'Z_RFC_ASSINC'
     TABLES
      t_bseg       = t_bseg_aux.

  APPEND LINES OF t_bseg_aux TO t_bseg.

  SUBTRACT 1 FROM v_task_ativa.

ENDFORM.                    " UPDATE_ORDER