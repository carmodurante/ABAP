CALL FUNCTION 'WFMC_PREPARE_SMART_FORM'
    EXPORTING
      pi_nast       = nast
      pi_country    = lv_dlv-land
      pi_addr_key   = lv_addr_key
      pi_repid      = sy-repid
      pi_screen     = lc_x
    IMPORTING
      pe_returncode = gv_retcode
      pe_itcpo      = lv_itcpo
      pe_device     = lv_device
      pe_recipient  = lv_recipient
      pe_sender     = lv_sender.
  IF gv_retcode = 0.
*moving the data to composer and control parameters for output
    MOVE-CORRESPONDING lv_itcpo TO lv_composer_param.
    lv_control_param-device      = lv_device.
    lv_control_param-no_dialog   = lc_x.
    lv_control_param-preview     = lc_x.
    lv_control_param-getotf      = lv_itcpo-tdgetotf.
    lv_control_param-langu       = nast-spras.
    lv_composer_param-tdnoprint = space.
  ENDIF.

*Getting the Smartform Function module using Standard Function module
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname                 = lv_formname           "Smartform Name
   IMPORTING
     fm_name                  = lv_fm_name
   EXCEPTIONS
     no_form                  = 1
     no_function_module       = 2
     OTHERS                   = 3
            .
  IF sy-subrc <> 0.
    gv_retcode = sy-subrc.
    PERFORM protocol_update.
    PERFORM add_smfrm_prot.
  ENDIF.

**Smartform function module to get the output
  CALL FUNCTION lv_fm_name
    EXPORTING
   control_parameters         = lv_control_param
   mail_recipient             = lv_recipient
   mail_sender                = lv_sender
     output_options             = lv_composer_param
     user_settings              = ' '
      is_bil_invoice             = lv_bil_invoice
      gt_header                  = gt_header
   IMPORTING
     job_output_info            = gv_job_output
    TABLES
      gt_item                    = gt_item
   EXCEPTIONS
     formatting_error           = 1
     internal_error             = 2
     send_error                 = 3
     user_canceled              = 4
     OTHERS                     = 5
            .
  IF sy-subrc <> 0.
    gv_retcode = sy-subrc.
    PERFORM protocol_update.
    PERFORM add_smfrm_prot.
  ENDIF.

  IF nast-nacha = lc_mail.
    gt_otfdata[] = gv_job_output-otfdata[].

******************************************************************
*           Converting Smartform to PDF                          *
******************************************************************
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = lc_pdf
        max_linewidth         = 10
      IMPORTING
        bin_filesize          = gv_binfilesize
        bin_file              = gv_pdf_xstring
      TABLES
        otf                   = gt_otfdata[]
        lines                 = gt_pdftab[]
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*******************************************************************
*           Sending PDF to Email  using Class                     *
*******************************************************************
    IF NOT lv_email IS INITIAL .
      TRY.
         gv_send_request = cl_bcs=>create_persistent( ).
          gv_pdf_content = cl_document_bcs=>xstring_to_solix( gv_pdf_xstring ).

          gv_document = cl_document_bcs=>create_document(
                i_type    = lc_pdf
                i_hex     = gv_pdf_content
                i_length  = gv_pdf_size
                i_subject = lc_subject ).            "Subject for Email
          gv_send_request->set_document( gv_document ).
         gv_recipient = cl_cam_address_bcs=>create_internet_address( lv_email ).
          gv_send_request->add_recipient( gv_recipient ).
          gv_sent_to_all = gv_send_request->send( i_with_error_screen = lc_x ).
          COMMIT WORK.
          IF gv_sent_to_all IS INITIAL.
            MESSAGE i500(sbcoms) WITH lv_email.
          ELSE.
            MESSAGE s022(so).
          ENDIF.

        CATCH cx_bcs INTO gv_bcs_exception.
          MESSAGE i865(so) WITH gv_bcs_exception->error_type.
      ENDTRY.
    ENDIF.