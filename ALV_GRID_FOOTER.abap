FORM end_of_list_html USING end TYPE REF TO cl_dd_document.

DATA: ls_text TYPE sdydo_text_element,

l_grid TYPE REF TO cl_gui_alv_grid,

f(14) TYPE c VALUE 'SET_ROW_HEIGHT'.

ls_text = 'Footer title'.

adds and icon (red triangle)

CALL METHOD end->add_icon

EXPORTING

sap_icon = 'IL'.

adds test (via variable)

CALL METHOD end->add_text

EXPORTING

text = ls_text

sap_emphasis = 'strong'.

adds new line (start new line)

CALL METHOD end->new_line.

display text(bold)

CALL METHOD end->add_text

EXPORTING

text = 'Bold text'

sap_emphasis = 'strong'.

adds new line (start new line)

CALL METHOD end->new_line.

display text(normal)

CALL METHOD end->add_text

EXPORTING

text = 'Nor'.

adds new line (start new line)

CALL METHOD end->new_line.

display text(bold)

CALL METHOD end->add_text

EXPORTING

text = 'Yellow '

sap_emphasis = 'str'.

adds and icon (yellow triangle)

CALL METHOD end->add_icon

EXPORTING

sap_icon = 'IC'.

display text(normal)

CALL METHOD end->add_text

EXPORTING

text = 'Mor'.

*set height of this section

CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'

IMPORTING

e_grid = l_grid.

CALL METHOD l_grid->parent->parent->(f)

EXPORTING

id = 3

height = 14.

ENDFORM. "end_of_list_html