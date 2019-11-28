*----------------------------------------------------------------------*
*                     === ABAP ZOMBIE PRESENTS ===                     *
*----------------------------------------------------------------------*
*                      Selection Screen Examples                       *
*----------------------------------------------------------------------*
* Description -> Code to help you remember how to create and control   *
*                selection-screen elements. The report main concept    *
*                is to provide an ALV with material information,       *
*                according to some restrictions.                       *
* Date        -> Jan 5th, 2010                                         *
* SAP Version -> 6.0                                                   *
*----------------------------------------------------------------------*
* ABAP Zombie Staff: Mauricio Roberto Cruz                             *
*                    Mauro Cesar Laranjeira                            *
*----------------------------------------------------------------------*
* Please, visit us at http://abapzombie.blog.br/ and drop a Comment!   *
*----------------------------------------------------------------------*
REPORT zaz_screen_examples.

TABLES: mara, sscrfields.
TYPE-POOLS: icon.


* Main Screen
*-------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK bl01 WITH FRAME.

SELECT-OPTIONS: s_matnr FOR mara-matnr.

PARAMETERS:     p_werks TYPE t001w-werks MODIF ID pl,
                p_lgort TYPE t001l-lgort MODIF ID sl.

*--> Button 1, plant data
SELECTION-SCREEN FUNCTION KEY 1.

*--> Button 2, Storage location data
SELECTION-SCREEN FUNCTION KEY 2.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN ULINE.

*--> First Check, plant data
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (5)   check1i.
SELECTION-SCREEN COMMENT 6(55) check1.
SELECTION-SCREEN PUSHBUTTON 62(18) resetp USER-COMMAND resetp
                 MODIF ID pl.
SELECTION-SCREEN END OF LINE.

*--> Second Check, Storage location data
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (5)   check2i.
SELECTION-SCREEN COMMENT 6(55) check2.
SELECTION-SCREEN PUSHBUTTON 62(18) resets USER-COMMAND resets
                 MODIF ID sl.
SELECTION-SCREEN END OF LINE.


*--> Control Parameters
* This two cannot be flags created by DATA, as SAP always
* will clear declared variables after a program's execution. Declaring
* this two as DATA flags would mess up with user-entered parameters
* after any execution.
PARAMETERS: p_nopl TYPE c NO-DISPLAY,
            p_nost TYPE c NO-DISPLAY.

SELECTION-SCREEN END OF BLOCK bl01.


* Plant Additional Data
* (Tabstrip Screen)
*-------------------------------------------------------------
SELECTION-SCREEN BEGIN OF SCREEN 9000 AS WINDOW.

*--> Tabbed Block for 2 tabs
SELECTION-SCREEN BEGIN OF TABBED BLOCK t1 FOR 10 LINES.

SELECTION-SCREEN TAB (20) tab1 USER-COMMAND tab1 DEFAULT SCREEN 101.
SELECTION-SCREEN TAB (20) tab2 USER-COMMAND tab2 DEFAULT SCREEN 102.

SELECTION-SCREEN END OF BLOCK t1.

* No Plant Data Button
SELECTION-SCREEN FUNCTION KEY 3.

SELECTION-SCREEN END OF SCREEN 9000.

* Subscreen 101 -> Key Plant Info.
SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
PARAMETERS: p_bwkey TYPE t001w-bwkey
                         AS LISTBOX VISIBLE LENGTH 20 MODIF ID mt1,
            p_kunnr TYPE t001w-kunnr MODIF ID mt1,
            p_lifnr TYPE t001w-lifnr MODIF ID mt1,
            p_fabkl TYPE t001w-fabkl MODIF ID mt1,
            p_name1 TYPE t001w-name1 MODIF ID mt1.


SELECTION-SCREEN END OF SCREEN 101.

* Subscreen 102 -> Additional Plant Info.
SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
PARAMETERS: p_land1 TYPE t001w-land1 MODIF ID mt1,
            p_regio TYPE t001w-regio MODIF ID mt1,
            p_stras TYPE t001w-stras MODIF ID mt1,
            p_ekorg TYPE t001w-ekorg MODIF ID mt1,
            p_vkorg TYPE t001w-vkorg MODIF ID mt1.
SELECTION-SCREEN END OF SCREEN 102.


* Storage location Additional Data
* (Plain Pop-up Screen)
*-------------------------------------------------------------
SELECTION-SCREEN BEGIN OF SCREEN 9001 AS WINDOW.

PARAMETERS: p_lgobe TYPE t001l-lgobe MODIF ID lc1,
            p_spart TYPE t001l-spart MODIF ID lc1,
            p_vkork TYPE t001l-vkorg MODIF ID lc1,
            p_vtweg TYPE t001l-vtweg MODIF ID lc1,
            p_vstel TYPE t001l-vstel MODIF ID lc1.

* No Storage Location Data Button
SELECTION-SCREEN FUNCTION KEY 4.

SELECTION-SCREEN END OF SCREEN 9001.





*-------------------------------
* INITIALIZATION Event
*-------------------------------
INITIALIZATION.

*--> Generate button texts
  PERFORM create_button.

*--> Generate Parameters and Select Options Texts
  PERFORM create_texts.

*--> Tab Names for Plan Data
  tab1 = 'Key Values'.
  tab2 = 'Additional Info'.

*--> Buttons to Reset Additional Data.
  resetp = 'Enter Add. Data...'.
  resets = 'Enter Add. Data...'.

*-------------------------------
* AT SELECTION-SCREEN Event
*-------------------------------
AT SELECTION-SCREEN.

*--> User Action at Main Screen
  CASE sy-ucomm.
    WHEN 'FC01'.
      CALL SELECTION-SCREEN 9000 STARTING AT 2 5.
    WHEN 'FC02'.
      CALL SELECTION-SCREEN 9001 STARTING AT 2 5.
    WHEN 'FC03'.
      p_nopl = 'X'.
      CLEAR: p_bwkey,
             p_kunnr,
             p_lifnr,
             p_fabkl,
             p_name1.
    WHEN 'FC04'.
      p_nost = 'X'.
      CLEAR: p_lgobe,
             p_spart,
             p_vkork,
             p_vtweg,
             p_vstel.
    WHEN 'RESETP'.
      CLEAR p_nopl.
      CALL SELECTION-SCREEN 9000 STARTING AT 2 5.
    WHEN 'RESETS'.
      CLEAR p_nost.
      CALL SELECTION-SCREEN 9001 STARTING AT 2 5.
    WHEN 'ONLI'.

*--> Error Consistency for Execution
      IF s_matnr IS INITIAL.
        MESSAGE ID '00' TYPE 'E' NUMBER 001
        WITH 'Please Enter Material Number'.
      ENDIF.
      IF NOT p_nopl     IS INITIAL AND
         p_werks        IS INITIAL.
        MESSAGE ID '00' TYPE 'E' NUMBER 001
              WITH 'Please Enter Plant Number'.
      ENDIF.
      IF p_nopl         IS INITIAL AND
         p_bwkey        IS INITIAL AND
         p_kunnr        IS INITIAL AND
         p_lifnr        IS INITIAL AND
         p_fabkl        IS INITIAL AND
         p_name1        IS INITIAL.
        MESSAGE ID '00' TYPE 'E' NUMBER 001
              WITH 'Please Enter Plant Additional Data'.
      ENDIF.
      IF NOT p_nost     IS INITIAL AND
         p_lgort        IS INITIAL.
        MESSAGE ID '00' TYPE 'E' NUMBER 001
                 WITH 'Please Enter Storag. Loc. Code'.
      ENDIF.
      IF p_nost          IS INITIAL AND
         p_lgobe         IS INITIAL AND
         p_spart         IS INITIAL AND
         p_vkork         IS INITIAL AND
         p_vtweg         IS INITIAL AND
         p_vstel         IS INITIAL.
        MESSAGE ID '00' TYPE 'E' NUMBER 001
                 WITH 'Please Enter Storag. Loc. Additional Data'.

      ENDIF.

  ENDCASE.

*-----------------------------------
* AT SELECTION-SCREEN OUTPUT Event
*-----------------------------------
AT SELECTION-SCREEN OUTPUT.

* Change Screen Elements
  PERFORM change_screen.

* Generate Parameters and Select Options Texts
  PERFORM create_texts.

* Comments Information
*--> Plant Data Comment
  IF  p_bwkey        IS INITIAL AND
      p_kunnr        IS INITIAL AND
      p_lifnr        IS INITIAL AND
      p_fabkl        IS INITIAL AND
      p_name1        IS INITIAL AND
      p_nopl IS INITIAL.
    check1 = '* Please enter key Additional Plant data'.
    check1i = icon_yellow_light.
  ELSEIF NOT p_nopl IS INITIAL.
    check1 = 'Enter Plant Code Directly, or click to reset Add. Data.'.
    check1i = icon_green_light.
  ELSE.
    check1 = 'Plant Data Correctly Entered.'.
    check1i = icon_green_light.
  ENDIF.

*--> Storage Location Comment
  IF  p_lgobe        IS INITIAL AND
      p_spart        IS INITIAL AND
      p_vkork        IS INITIAL AND
      p_vtweg        IS INITIAL AND
      p_vstel        IS INITIAL AND
      p_nost         IS INITIAL.
    check2 = '* Please enter key Additional Storage Location data'.
    check2i = icon_yellow_light.
  ELSEIF NOT p_nost IS INITIAL.
    check2 = 'Enter Plant Code Directly, or click to reset Add. Data.'.
    check2i = icon_green_light.
  ELSE.
    check2 = 'Storage Location Data Correctly Entered.'.
    check2i = icon_green_light.
  ENDIF.



*&---------------------------------------------------------------------*
*&      Form  CREATE_BUTTON
*&---------------------------------------------------------------------*
FORM create_button .

* Local Variables
*-------------------------------
  DATA: wa_button TYPE smp_dyntxt.

*--> Plant Button
  wa_button-text        = 'Plant Data'.
  wa_button-icon_id     = icon_plant.
  wa_button-icon_text   = 'Plant Additional Data'.
  sscrfields-functxt_01 = wa_button.

*--> Storage Location Button
  wa_button-text        = 'Storage Location Data'.
  wa_button-icon_id     = icon_store_location.
  wa_button-icon_text   = 'Storage Location Additional Data'.
  sscrfields-functxt_02 = wa_button.

*--> No Plant Data Button
  wa_button-text        = 'Enter Plant Code Directly'.
  wa_button-icon_id     = icon_store_location.
  wa_button-icon_text   = 'Enter Plant Code Directly'.
  sscrfields-functxt_03 = wa_button.

*--> No Storage Location Data Button
  wa_button-text        = 'Enter Storage Location Code Directly'.
  wa_button-icon_id     = icon_store_location.
  wa_button-icon_text   = 'Enter Storage Location Code Directly'.
  sscrfields-functxt_04 = wa_button.

ENDFORM.                    " create_button.

*&---------------------------------------------------------------------*
*&      Form  CHANGE_SCREEN
*&---------------------------------------------------------------------*
FORM change_screen .

  LOOP AT SCREEN.

    IF NOT p_nopl IS INITIAL.

*   Show Plant Parameter at Main Screen.
      IF screen-group1 = 'PL'.
        screen-invisible = 0.
        screen-input     = 1.
        screen-active    = 1.
      ENDIF.

*     Unable Additional Data
      IF screen-group1 = 'MT1'.
        screen-input  = 0.
      ENDIF.

      MODIFY SCREEN.

    ELSE.

*   Hide Plant Parameter at Main Screen.
      IF screen-group1 = 'PL'.
        screen-invisible = 1.
        screen-input     = 0.
        screen-active    = 0.
      ENDIF.

*     Enable Additional Data
      IF screen-group1 = 'MT1'.
        screen-input  = 1.
      ENDIF.

      MODIFY SCREEN.

    ENDIF.

    IF NOT p_nost IS INITIAL.

*     Show Storage Location Parameter at Main Screen.
      IF screen-group1 = 'SL'.
        screen-invisible = 0.
        screen-input     = 1.
        screen-active    = 1.
      ENDIF.

*     Unable Additional Data
      IF screen-group1 = 'LC1'.
        screen-input  = 0.
      ENDIF.

      MODIFY SCREEN.

    ELSE.

*    Hide Storage Location Parameter at Main Screen.
      IF screen-group1 = 'SL'.
        screen-invisible = 1.
        screen-input     = 0.
        screen-active    = 0.
      ENDIF.

*     Enable Additional Data
      IF screen-group1 = 'LC1'.
        screen-input  = 1.
      ENDIF.

      MODIFY SCREEN.

    ENDIF.

  ENDLOOP.

ENDFORM.                    " CHANGE_SCREEN
*&---------------------------------------------------------------------*
*&      Form  CREATE_TEXTS
*&---------------------------------------------------------------------*
FORM create_texts .

* Note that I had to do this only to make users able to see texts
* for parameters and sel options when the copy-paste the code into
* a Z local program in their systems. You may maintain any texts
* normally through Go To -> Text Elements.
  %_s_matnr_%_app_%-text = 'Material Number'.
  %_p_bwkey_%_app_%-text = 'Valuation Area'.
  %_p_werks_%_app_%-text = 'Plant Number'.
  %_p_lgort_%_app_%-text = 'Storage Location Number'.
  %_p_kunnr_%_app_%-text = 'Customer number of plant'.
  %_p_lifnr_%_app_%-text = 'Vendor number of plant'.
  %_p_fabkl_%_app_%-text = 'Factory calendar key'.
  %_p_name1_%_app_%-text = 'Name'.
  %_p_land1_%_app_%-text = 'Country Key'.
  %_p_regio_%_app_%-text = 'Region (State, Province, County)'.
  %_p_stras_%_app_%-text = 'House number and street'.
  %_p_ekorg_%_app_%-text = 'Purchasing Organization'.
  %_p_vkorg_%_app_%-text = 'Sales organization for intercompany' &
                           'billing.'.
  %_p_lgobe_%_app_%-text = 'Description of Stor. Location'.
  %_p_spart_%_app_%-text = 'Division'.
  %_p_vkork_%_app_%-text = 'Sales Organization'.
  %_p_vtweg_%_app_%-text = 'Distribution Channel'.
  %_p_vstel_%_app_%-text = 'Shipping Point/Receiving Point'.

ENDFORM.                    " CREATE_TEXTS

*----------------------------------------------------------------------*
*                          === DISCLAIMER ===                          *
*----------------------------------------------------------------------*
* This code is made only for study and reference purposes. It was not  *
* copied from any running program and it does not make references      *
* to any functional requirement. All code here was created based on    *
* the authors experience and creativity! Enjoy!                        *
*----------------------------------------------------------------------*