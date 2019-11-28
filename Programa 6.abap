*Programa 6 DATA (INCLUDE STRUCTURE)
*&---------------------------------------------------------------------*
*& Report ZC00109 *
*& *
*&---------------------------------------------------------------------*
*& PROGRAMA PARA LER ARQUIVO EXTERNO E IMPORTAR PARA TABELA *
*& *
*&---------------------------------------------------------------------*
REPORT ZC00109 .
* TABELA QUE IRA CONTER OS DADOS IMPORTADOS
TABLES : ZTAB1_01.
* TABELA INTERNA PARA MANIPULAR OS DADOS
DATA : BEGIN OF t_tabela OCCURS 0,
texto01(100) TYPE C,
END OF t_tabela.
* COMO CRIAR UMA TABELA INTERNA COPIANDO A ESTRUTURA DA TABELA INTERNA.
DATA : BEGIN OF t_tempo OCCURS 0.
INCLUDE STRUCTURE ztab1_01.
DATA : END OF t_tempo.
* CRIA UMA CONSTANTE caractere com o valor ';'
CONSTANTS c_tipo TYPE C VALUE ';'.
SELECTION-SCREEN BEGIN OF BLOCK b_janela WITH FRAME TITLE text-001.
* nome do parametro para importar o arquivo -> RLGRAP-FILENAME
PARAMETERS P_ARQ LIKE RLGRAP-FILENAME.
SELECTION-SCREEN END OF BLOCK b_janela.
START-OF-SELECTION.
PERFORM F_CARREGAR_DADOS.
PERFORM F_DADOS_P_TAB_INTERNA.
PERFORM F_ATUALIZAR_DADOS.
*&---------------------------------------------------------------------*
*& Form F_CARREGAR_DADOS
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_CARREGAR_DADOS .
* limpar a tabela de entrada e o read line da tabela
REFRESH t_tabela.
CLEAR t_tabela.
* FUNÇÃO PARA IMPORTAR ARQUIVO
* chamar a função usar o botão MODELO
CALL FUNCTION 'WS_UPLOAD'
EXPORTING
* CODEPAGE = ' '
FILENAME = P_ARQ " COLOCAR O NOME DA VARIAVEL
" IRA CONTER O NOME DO ARQUIVO
FILETYPE = 'ASC' " TIPO DE ARQUIVO
* HEADLEN = ' '
* LINE_EXIT = ' '
* TRUNCLEN = ' '
* USER_FORM = ' '
* USER_PROG = ' '
* DAT_D_FORMAT = ' '
* IMPORTING
* FILELENGTH =
TABLES
DATA_TAB = t_tabela " NOME DA TABELA INTERNA QUE
" IRA RECEBER OS DADOS
* CODIGOS DE ERROS DE RETONO
EXCEPTIONS
CONVERSION_ERROR = 1
FILE_OPEN_ERROR = 2
FILE_READ_ERROR = 3
INVALID_TYPE = 4
NO_BATCH = 5
UNKNOWN_ERROR = 6
INVALID_TABLE_WIDTH = 7
GUI_REFUSE_FILETRANSFER = 8
CUSTOMER_ERROR = 9
NO_AUTHORITY = 10
OTHERS = 11.
* tratamento dos erros.
IF SY-SUBRC <> 0.
MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
ENDFORM. " F_CARREGAR_DADOS
*&---------------------------------------------------------------------*
*& Form F_DADOS_P_TAB_INTERNA
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_DADOS_P_TAB_INTERNA .
* LIMPAR A TABELA INTERNA
REFRESH t_tempo.
CLEAR t_tempo.
LOOP AT t_tabela.
* limpar o header line da tabela
CLEAR t_tempo.
* sy-mandt -> volta o mandante do sistema.
t_tempo-mandt = sy-mandt.
* SPLIT tabela_interna AT delimitador_do_arquivo INTO
* campos que irão receber os dados na seqüência do
* arquivo
SPLIT t_tabela-texto01 AT c_tipo INTO t_tempo-codigo
t_tempo-nome.
* APPEND nome da tabela que ira guardar os dados importados
* gravar na tabela
* coloca zeros na frente do numero
UNPACK t_tempo-codigo TO t_tempo-codigo.
APPEND t_tempo.
ENDLOOP.
ENDFORM. " F_DADOS_P_TAB_INTERNA
*&---------------------------------------------------------------------*
*& Form F_ATUALIZAR_DADOS
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM F_ATUALIZAR_DADOS .
LOOP AT t_tempo.
* move o conteúdo de uma tabela para outra tabela
* apenas os campos com o mesmo nome ( variáveis )
MOVE-CORRESPONDING t_tempo TO ztab1_01.
* INSERE O CONTEUDO DA VARIAVEL PARA A TABELA ( GRAVAR )
INSERT ztab1_01.
* UPDATE tabela interna
* DELETE tabela interna
ENDLOOP.
* EFETIVA AS ALTERAÇÕES NO BANCO
COMMIT WORK.
ENDFORM. " F_ATUALIZAR_DADOS