  DATA: o_query       TYPE REF TO cl_crm_bol_dquery_service,
        o_col_entity  TYPE REF TO if_bol_entity_col,
        o_entity      TYPE REF TO cl_crm_bol_entity.

  "Pega a instancia do objeto de pesquisa
  o_query = cl_crm_bol_dquery_service=>get_instance( 'BTQSrvOrd' ).

  "Preenche os par�metros de sele��o
  o_query->add_selection_param( iv_attr_name = 'BU_PARTNER'
                                   iv_sign      = 'I'
                                   iv_option    = 'EQ'
                                   iv_low       = '0000000000' ). "N�mero do BP

  "Executa a busca e retorna uma cole��o de entities
  "ou seja, todos os documentos encontrados
  o_col_entity = o_query->get_query_result( ).


------------------------------------------------------------------------

  "Pega a primeira entity do resultado da pesquisa
  o_entity = o_col_entity->get_first( ). 

  "Entity instanciada?
  WHILE o_entity IS BOUND.

//Toda a logica com a entity

    "Pega a pr�xima entity do resultado da pesquisa
    o_entity = o_col_entity->get_next( ).

  ENDWHILE.