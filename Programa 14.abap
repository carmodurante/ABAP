***Programa 14
*&---------------------------------------------------------------------*
*& Report ZEXEMPLO_ALV1 *
*& *
*&---------------------------------------------------------------------*
*& *
*& *
*&---------------------------------------------------------------------*
*-----------------------------------------------------------------------
* Descrição : Programa de exemplo para criação de relatório ALV
*-----------------------------------------------------------------------
report zexemplo_alv1.
*-----------------------------------------------------------------------
* Tabelas transparentes
*-----------------------------------------------------------------------
tables:
vbrk, "Documentos de faturamento
vbrp. "Documento de faturamento: dados de item
*-----------------------------------------------------------------------
* Tipos standard
*
* O conjunto de tipos VRM e SLIS são utilizados por funções ALV. Defina
* sempre no início. O mais importante mesmo é o SLIS. - sempre ter
*-----------------------------------------------------------------------
type-pools:
vrm, "Necessário para uso de ALV
slis. "Tipos globais para ALV
*-----------------------------------------------------------------------
* Tipos do usuário
*-----------------------------------------------------------------------
types:
begin of y_vbrk,
vbeln like vbrk-vbeln, "Número documento
kdgrp like vbrk-kdgrp, "Grupo de clientes
netwr like vbrk-netwr, "Valor líquido
mwsbk like vbrk-mwsbk, "Montante do imposto
fkart like vbrk-fkart, "Tipo documento faturamento
vtweg like vbrk-vtweg, "Canal de distribuição
kunag like vbrk-kunrg, "Emissor da ordem
xblnr like vbrk-xblnr, "Nota fiscal
mark type c, "Marcar alterações
end of y_vbrk,
begin of y_vbrp,
posnr like vbrp-posnr, "Item do doc.de faturamento
matnr like vbrp-matnr, "Nº do material
fkimg like vbrp-fkimg, "Qde.faturada
vrkme like vbrp-vrkme, "Unidade de venda
end of y_vbrp.
*-----------------------------------------------------------------------
* Tabelas internas ALV
*
* As estruturas aqui utilizadas (SLIS) estão explicadas com as opções
* mais importantes no final da apostila
*-----------------------------------------------------------------------
* sempre ter estas tabelas
data:
t_listheader type slis_t_listheader,
* para primeira alv
t_fieldcat type slis_t_fieldcat_alv with header line,
* segunda alv
t_fieldcatvbrp type slis_t_fieldcat_alv with header line,
* faz parte da 1 alv. indica o campo que vai ser index e totalizado
t_sort type slis_sortinfo_alv occurs 0 with header line.
* estruturas std - obrigatorio
data:
v_listheader type slis_listheader, "Cabeçalho
v_layout type slis_layout_alv, "layout para saída
v_print type slis_print_alv, "Ctrl de impressão
v_variante like disvariant. "Variante de exibição
*-----------------------------------------------------------------------
* Tabelas internas
*-----------------------------------------------------------------------
data:
t_vbrk type y_vbrk occurs 0 with header line,
t_vbrp type y_vbrp occurs 0 with header line.
* A próxima tabela é necessário porque não é possível um select em
* tabelas que possuem campos como outras tabelas.
* No caso foi necessário incluir a SLIS_T_SPECIALCOL_ALV
data: begin of t_alv occurs 0.
include structure t_vbrk.
data: end of t_alv.
*-----------------------------------------------------------------------
* Variáveis de uso geral
*-----------------------------------------------------------------------
data:
v_tabix like sy-tabix,
v_repid like sy-repid, " nome do programa
v_flag.
*-----------------------------------------------------------------------
* Tela de seleção
*-----------------------------------------------------------------------
selection-screen begin of block one.
select-options:
s_vbeln for vbrk-vbeln. "Documento de faturamento
selection-screen skip.
parameters:
p_varia like disvariant-variant. "Variante de exibição
*-----------------------------------------------------------------------
* O usuário terá a opção de iniciar a apresentação do relatório com
* algum layout salvo anteriormente.
* Essa escolha será armazenada em P_VARIA. Utilizamos uma função que
* retorna todos os layout possíveis.
*-----------------------------------------------------------------------
selection-screen end of block one.
*-----------------------------------------------------------------------
* Eventos
*-----------------------------------------------------------------------
initialization.
perform zf_init_alv.
at selection-screen on value-request for p_varia.
perform zf_recupera_layouts_salvos.
*-----------------------------------------------------------------------
* Principal
*-----------------------------------------------------------------------
start-of-selection.
perform:
zf_selecao_dados, "Seleciona a VBRK
zf_monta_tabela_alv, "Preenche o catálogo
zf_sort_subtotal, "Ordenação dos campos e subtotais
zf_executa_funcao_alv. "Gera o relatório
end-of-selection.
*-----------------------------------------------------------------------
* Rotinas
*-----------------------------------------------------------------------
*-----------------------------------------------------------------------
* Form zf_init_alv
*-----------------------------------------------------------------------
* Busca layout de exibição default para o relatório. Se houver
* algum formato padrão para o relatório, essa função busca e já
* apresenta o relatório nesse formato.
* Um layout fica como default quando marcamos "Config.Prelim." Um
* flag que pode ser marcado na opção "Gravar layout" na barra de
* ferramentas do ALV
*-----------------------------------------------------------------------
form zf_init_alv.
* recupera o nome do programa
v_repid = sy-repid.
clear v_variante.
v_variante-report = v_repid.
* função para recuperar todas as variante de exibição
call function 'REUSE_ALV_VARIANT_DEFAULT_GET'
exporting
i_save = 'A'
changing
cs_variant = v_variante
exceptions
not_found = 2.
if sy-subrc = 0.
p_varia = v_variante.
endif.
endform. "zf_init_alv
*-----------------------------------------------------------------------
* Form zf_recupera_layouts_salvos
*-----------------------------------------------------------------------
* Abre um search help com os layouts já gravados. Se o usuário
* escolher algum aqui, o programa vai iniciar a apresentação do
* relatório com esse layout, e não o que é default, retornado na
* função REUSE_ALV_VARIANT_DEFAULT_GET em ZF_INIT_ALV (Acima)
*-----------------------------------------------------------------------
form zf_recupera_layouts_salvos.
* lista todas as variantes
v_variante-report = v_repid.
call function 'REUSE_ALV_VARIANT_F4'
exporting
is_variant = v_variante
i_save = 'A'
importing
es_variant = v_variante
exceptions
not_found = 2.
if sy-subrc = 2.
message id sy-msgid type 'S' number sy-msgno
with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
else.
p_varia = v_variante-variant.
endif.
endform. "zf_recupera_layouts_salvos
*-----------------------------------------------------------------------
* Form zf_selecao_dados
*-----------------------------------------------------------------------
* Seleção dos dados
*-----------------------------------------------------------------------
form zf_selecao_dados.
select vbeln kdgrp netwr mwsbk
fkart vtweg kunag xblnr
from vbrk
into table t_vbrk
where vbeln in s_vbeln.
loop at t_vbrk.
move-corresponding t_vbrk to t_alv.
append t_alv.
endloop.
endform. "zf_selecao_dados
*-----------------------------------------------------------------------
* Form zf_monta_tabela_alv
*-----------------------------------------------------------------------
* Monta tabela para apresentação do relatório. Aqui montamos um
* catálogo com as informações dos campos.
* Veja que não estamos preenchendo todas as opções do catálogo,
* não é necessário. No anexo você poderá encontrar os principais
*-----------------------------------------------------------------------
form zf_monta_tabela_alv.
* colunas dos relatorios alv
clear t_fieldcat.
t_fieldcat-fieldname = 'MARK'. " nome do campo
t_fieldcat-tabname = 'T_ALV'. " tabela interna
t_fieldcat-reptext_ddic = 'S'. " titulo da coluna
t_fieldcat-inttype = 'C'. " tipo
t_fieldcat-outputlen = 1. " tamanho
t_fieldcat-checkbox = 'X'. "
append t_fieldcat.
clear t_fieldcat.
t_fieldcat-fieldname = 'VBELN'.
t_fieldcat-tabname = 'T_ALV'.
t_fieldcat-reptext_ddic = 'Doc. Fatura'.
t_fieldcat-inttype = 'C'.
t_fieldcat-outputlen = 10.
t_fieldcat-hotspot = 'X'. " aparecer a mão
append t_fieldcat.
clear t_fieldcat.
t_fieldcat-fieldname = 'KDGRP'.
t_fieldcat-tabname = 'T_ALV'.
t_fieldcat-reptext_ddic = 'Grupo de Clientes'.
t_fieldcat-inttype = 'C'.
t_fieldcat-outputlen = 2.
append t_fieldcat.
* Para o campo NETWR, o relatório já vai mostrar linha de total
clear t_fieldcat.
t_fieldcat-fieldname = 'NETWR'.
t_fieldcat-tabname = 'T_ALV'.
t_fieldcat-reptext_ddic = 'Valor líquido'.
t_fieldcat-inttype = 'P'.
t_fieldcat-outputlen = 15.
t_fieldcat-do_sum = 'X'. " indica campo totalizado
append t_fieldcat.
clear t_fieldcat.
t_fieldcat-fieldname = 'MWSBK'.
t_fieldcat-tabname = 'T_ALV'.
t_fieldcat-reptext_ddic = 'Montante do Imposto'.
t_fieldcat-inttype = 'P'.
t_fieldcat-outputlen = 15.
append t_fieldcat.
* Os campos abaixo não irão aparecer no relatório, apenas quando
* o usuário modificar o layout e inserir esses campos nas colunas
* a serem apresentadas
clear t_fieldcat.
t_fieldcat-fieldname = 'FKART'.
t_fieldcat-tabname = 'T_ALV'.
t_fieldcat-reptext_ddic = 'Tipo do documento'.
t_fieldcat-inttype = 'C'.
t_fieldcat-outputlen = 4.
t_fieldcat-no_out = 'X'. " campos ocultos
append t_fieldcat.
clear t_fieldcat.
t_fieldcat-fieldname = 'VTWEG'.
t_fieldcat-tabname = 'T_ALV'.
t_fieldcat-reptext_ddic = 'Canal de Distribuição'.
t_fieldcat-inttype = 'C'.
t_fieldcat-outputlen = 2.
t_fieldcat-no_out = 'X'.
append t_fieldcat.
clear t_fieldcat.
t_fieldcat-fieldname = 'KUNAG'.
t_fieldcat-tabname = 'T_ALV'.
t_fieldcat-reptext_ddic = 'Emissor da Ordem'.
t_fieldcat-inttype = 'C'.
t_fieldcat-outputlen = 10.
t_fieldcat-no_out = 'X'.
append t_fieldcat.
* Para o campo XBLNR, não vamos preencher nada. Nem disponível
* na modificação do layout ele vai estar.
* Não é necessário atribuir todos os campos, não ocorre
* nenhum erro.
endform. "zf_monta_tabela_alv
*-----------------------------------------------------------------------
* Form zf_sort_subtotal
*-----------------------------------------------------------------------
* Classificação e item de subtotalização
*-----------------------------------------------------------------------
form zf_sort_subtotal.
clear t_sort[].
t_sort-spos = 1. "
t_sort-fieldname = 'KDGRP'. " nome do campo
t_sort-tabname = 'T_ALV'.
t_sort-up = 'X'. " org. crescente
t_sort-subtot = 'X'. " totalizado
append t_sort.
* Com isso o relatório vai sair classificado em ordem crescente de Grupo
* de cliente e ainda irá aparecer um subtotal por esse campo.
endform. "zf_sort_subtotal
*-----------------------------------------------------------------------
* Form zf_executa_funcao_alv
*-----------------------------------------------------------------------
* Apresenta relatório
*-----------------------------------------------------------------------
form zf_executa_funcao_alv.
* Preenchendo algumas opções de impressão (Não é obrigatório)
* v_layout-expand_all = 'X'. "Abrir subitens
v_layout-colwidth_optimize = 'X'. "Largura melhor possível da coluna
v_layout-edit = 'X'. "Permitir a edição
v_layout-zebra = 'X'. "Impressão zebrada
* Indicando para função qual o layout que deve ser apresentado
* primeiro
v_variante-variant = p_varia.
v_print-no_print_listinfos = 'X'.
call function 'REUSE_ALV_GRID_DISPLAY'
exporting
i_callback_program = v_repid " nome do programa
i_background_id = 'ALV_BACKGROUND' " pano de fundo
i_callback_top_of_page = 'ZF_TOP_OF_PAGE' " cabecalho
i_callback_pf_status_set = 'ZF_STATUS' " rotina dos botões
i_callback_user_command = 'ZF_USER_COMMAND' " define as açoes bt
it_fieldcat = t_fieldcat[] " tabela das colunas
is_layout = v_layout " layout
it_sort = t_sort[] " totalização
i_default = 'X'
i_save = 'A'
is_variant = v_variante " varian layout
is_print = v_print
tables
t_outtab = t_alv " tabela dos dados
exceptions
program_error = 1
others = 2.
* As funções que geram relatórios ALV possuem vários parâmetros de
* I_CALLBACK. Os que mais são utilizados, são os que estão
* na chamada acima. Para ver os demais use a transação SE37. Esses
* parâmetros são preenchidos com nomes de FORMS do programa
* i_callback_program = Qual programa que executou a função
* i_callback_top_of_page = Rotina de cabeçalho
endform. "zf_executa_funcao_alv
*-----------------------------------------------------------------------
* Form zf_top_of_page
*-----------------------------------------------------------------------
* Cabeçalho do relatório
*-----------------------------------------------------------------------
form zf_top_of_page.
* Monta as linhas de cabeçalho
clear t_listheader[].
clear v_listheader.
v_listheader-typ = 'H'.
* TYP = H, faz com que a fonte fique maior
v_listheader-info = 'Exemplo em ALV'.
append v_listheader to t_listheader.
* Definição do Projeto
clear v_listheader.
v_listheader-typ = 'A'.
* TYP = S, outro tipo de fonte
v_listheader-info = 'Segunda linha do cabeçalho'.
append v_listheader to t_listheader.
* Apresenta o cabeçalho.
call function 'REUSE_ALV_COMMENTARY_WRITE'
exporting
i_logo = 'ENJOYSAP_LOGO'
it_list_commentary = t_listheader.
endform. "zf_top_of_page
*----------------------------------------------------------------------
* Form zf_status
*----------------------------------------------------------------------
* Status com botão de log (Item a mais na barra ALV)
*----------------------------------------------------------------------
form zf_status using rt_extab type slis_t_extab.
* Aqui estamos informando a função que ela deverá utilizar a barra de
* ferramentas ZALV_BOTOES.
set pf-status 'ZALV_BOTOES'.
* Também é possível excluir funções
"if sy-uname = ...
"EXCLUDING ...
"endif.
endform. "zf_status
*-----------------------------------------------------------------------
* Form zf_user_command
*-----------------------------------------------------------------------
* Tratamento das opções do usuário. Por exemplo um Drill-down ou
* algum botão que você inseriu ou alterou. O importante é conhecer
* os parâmetros que o form recebe
*-----------------------------------------------------------------------
form zf_user_command using ucomm like sy-ucomm
selfield type slis_selfield.
* UCOMM: é o sy-ucomm (Ok-code)
* SELFIELD: é uma estrutura com dados que nos permite identificar
* o que foi selecionado. Essa estrutura também está
* explicada no anexo ao final da apostila
* manter o relatório na linha selecionada antes do drill down.
selfield-row_stable = 'X'.
* manter o relatório na coluna selecionada antes do drill down.
selfield-col_stable = 'X'.
case ucomm.
*** Visualizar Documento de Faturamento - Transação VF03
when 'DOCF'.
*** Pesquisar o registro selecionado pelo usuário
read table t_alv index selfield-tabindex.
* SET ,,,,, IF id do campo ( F1/F9 ) FILED tab com o valor do campo
set parameter id 'VF' field t_alv-vbeln.
* AND SKIP FIRST SCREEN -> PULA A PRIMEIRA TELA
call transaction 'VF03' and skip first screen.
when '&IC1'.
*** Pesquisar o registro selecionado pelo usuário
read table t_alv index selfield-tabindex.
*** Verificar itens do Documento de Faturamento
perform zf_carregar_t_vbrp.
perform zf_monta_tabela_alv_vbrp. "Preenche o catálogo
perform zf_executa_funcao_alv_vbrp. "Gera o relatório
when 'ATUA'.
loop at t_alv where mark = 'X'.
v_tabix = sy-tabix.
*** Atualizar a tabela transparente
update vbrk set netwr = t_alv-netwr
where vbeln = t_alv-vbeln.
*** Então voltamos a T_VBRK sem marcação alguma
clear t_alv-mark.
modify t_alv index v_tabix.
endloop.
endcase.
endform. "zf_user_command
*&---------------------------------------------------------------------*
*& Form zf_carregar_t_vbrp
*&---------------------------------------------------------------------*
form zf_carregar_t_vbrp .
clear t_vbrp.
free t_vbrp.
select posnr matnr
fkimg vrkme
into table t_vbrp
from vbrp
where vbeln eq t_alv-vbeln.
endform. " zf_carregar_t_vbrp
*&---------------------------------------------------------------------*
*& Form zf_monta_tabela_alv_vbrp
*&---------------------------------------------------------------------*
form zf_monta_tabela_alv_vbrp .
free t_fieldcatvbrp.
clear t_fieldcatvbrp.
t_fieldcatvbrp-fieldname = 'POSNR'.
t_fieldcatvbrp-tabname = 'T_VBRP'.
t_fieldcatvbrp-reptext_ddic = 'Item'.
t_fieldcatvbrp-inttype = 'N'.
t_fieldcatvbrp-outputlen = 6.
append t_fieldcatvbrp.
clear t_fieldcatvbrp.
t_fieldcatvbrp-fieldname = 'MATNR'.
t_fieldcatvbrp-tabname = 'T_VBRP'.
t_fieldcatvbrp-reptext_ddic = 'Nº do material'.
t_fieldcatvbrp-inttype = 'C'.
t_fieldcatvbrp-outputlen = 10.
append t_fieldcatvbrp.
clear t_fieldcatvbrp.
t_fieldcatvbrp-fieldname = 'FKIMG'.
t_fieldcatvbrp-tabname = 'T_VBRP'.
t_fieldcatvbrp-reptext_ddic = 'Qtde.faturada'.
t_fieldcatvbrp-inttype = 'P'.
t_fieldcatvbrp-outputlen = 20.
append t_fieldcatvbrp.
clear t_fieldcatvbrp.
t_fieldcatvbrp-fieldname = 'VRKME'.
t_fieldcatvbrp-tabname = 'T_VBRP'.
t_fieldcatvbrp-reptext_ddic = 'Unidade'.
t_fieldcatvbrp-inttype = 'C'.
t_fieldcatvbrp-outputlen = 3.
append t_fieldcatvbrp.
endform. " zf_monta_tabela_alv_vbrp
*&---------------------------------------------------------------------*
*& Form zf_executa_funcao_alv_vbrp
*&---------------------------------------------------------------------*
form zf_executa_funcao_alv_vbrp .
* Preenchendo algumas opções de impressão (Não é obrigatório)
v_layout-expand_all = 'X'. "Abrir subitens
v_layout-colwidth_optimize = 'X'. "Largura melhor possível da coluna
v_layout-edit = 'X'. "Permitir a edição
* Indicando para função qual o layout que deve ser apresentado
* primeiro
v_variante-variant = p_varia.
v_print-no_print_listinfos = 'X'.
call function 'REUSE_ALV_GRID_DISPLAY'
exporting
i_callback_program = v_repid
i_background_id = 'ALV_BACKGROUND'
i_callback_top_of_page = 'ZF_TOP_OF_PAGE_VBRP'
it_fieldcat = t_fieldcatvbrp[]
is_layout = v_layout
i_default = 'X'
i_save = 'A'
is_print = v_print
* i_screen_start_column = 60 ABRE OUTRA JANELA POPUP UP
* i_screen_start_line = 5 COORDENADAS
* i_screen_end_column = 120
* i_screen_end_line = 20
tables
t_outtab = t_vbrp
exceptions
program_error = 1
others = 2.
endform. " zf_executa_funcao_alv_vbrp
*-----------------------------------------------------------------------
* Form zf_top_of_page_vbrp
*-----------------------------------------------------------------------
* Cabeçalho do relatório
*-----------------------------------------------------------------------
form zf_top_of_page_vbrp.
* Monta as linhas de cabeçalho
clear t_listheader[].
clear v_listheader.
v_listheader-typ = 'H'.
* TYP = H, faz com que a fonte fique maior
v_listheader-info = 'Itens do Documento de Faturamento'.
append v_listheader to t_listheader.
* Definição do Projeto
clear v_listheader.
v_listheader-typ = 'H'.
* TYP = S, outro tipo de fonte
v_listheader-info = t_alv-vbeln.
append v_listheader to t_listheader.
* Apresenta o cabeçalho.
call function 'REUSE_ALV_COMMENTARY_WRITE'
exporting
i_logo = 'ENJOYSAP_LOGO'
it_list_commentary = t_listheader.
endform. "zf_top_of_page_vbrp