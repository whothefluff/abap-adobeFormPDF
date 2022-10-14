"! <p class="shorttext synchronized" lang="EN">Generic AdobeForm PDF file</p>
"! This is based in { @link CL_PDF }, but less horrible
class zcl_adobe_form_pdf definition
                         public
                         create public
                         abstract.

  public section.

    interfaces: zif_adobe_form_pdf.

    aliases: output_processing_parameters for zif_adobe_form_pdf~output_processing_parameters,
             document_processing_parameters for zif_adobe_form_pdf~document_processing_parameters,
             form_function_module_name for zif_adobe_form_pdf~form_function_module_name,
             close_form_job for zif_adobe_form_pdf~close_form_job,
             open_form_job for zif_adobe_form_pdf~open_form_job,
             print for zif_adobe_form_pdf~print,
             print_and_download_to_frontend for zif_adobe_form_pdf~print_and_download_to_frontend,
             form_name for zif_adobe_form_pdf~form_name.

    "! <p class="shorttext synchronized" lang="EN"></p>
    "!
    "! @parameter i_name | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter i_output_processing_params | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter i_document_processing_params | <p class="shorttext synchronized" lang="EN"></p>
    methods constructor
              importing
                value(i_name) type fpname
                value(i_output_processing_params) type sfpoutputparams
                value(i_document_processing_params) type sfpdocparams.

    "! <p class="shorttext synchronized" lang="EN">Override to call form FM with appropriate parameters</p>
    "! The signature should be identical to that of { @link zif_adobe_form_pdf.METH:call_form }
    "!
    "! @parameter i_function_module_name | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter i_processing_parameters | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter r_output | <p class="shorttext synchronized" lang="EN"></p>
    "! @raising cx_pdf | <p class="shorttext synchronized" lang="EN"></p>
    methods call_form
              abstract
              importing
                value(i_function_module_name) type funcname
                value(i_processing_parameters) type sfpdocparams
              returning
                value(r_output) type fpformoutput
              raising
                cx_pdf.

  protected section.

    data a_name type fpname.

    data a_doc_proc_params_str type sfpdocparams.

    data an_output_proc_params_str type sfpoutputparams.

endclass.


class zcl_adobe_form_pdf implementation.

  method constructor.

    me->a_name = i_name.

    me->an_output_proc_params_str = value #( base i_output_processing_params
                                             getpdf = abap_true ).

    me->a_doc_proc_params_str = i_document_processing_params.

  endmethod.
  method zif_adobe_form_pdf~output_processing_parameters.

    r_output_processing_params = me->an_output_proc_params_str.

  endmethod.
  method zif_adobe_form_pdf~document_processing_parameters.

    r_document_processing_params = me->a_doc_proc_params_str.

  endmethod.
  method zif_adobe_form_pdf~close_form_job.

    call function 'FP_JOB_CLOSE'
      importing
        e_result       = r_result
      exceptions
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        others         = 4.

    if sy-subrc ne 0.

      raise exception type cx_pdf exporting textid = cx_pdf=>cx_close.

    endif.

  endmethod.
  method zif_adobe_form_pdf~open_form_job.

    call function 'FP_JOB_OPEN'
      changing
        ie_outputparams = me->an_output_proc_params_str
      exceptions
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        others          = 5.

    r_self = cond #( when sy-subrc eq 0
                     then me
                     else throw cx_pdf( textid = cx_pdf=>cx_open ) ).

  endmethod.
  method zif_adobe_form_pdf~print.

    me->open_form_job( ).

    try.

      data(output) = me->call_form( i_function_module_name = me->form_function_module_name( )
                                    i_processing_parameters = me->document_processing_parameters( ) ).

    catch cx_fp_api_repository
          cx_fp_api_internal
          cx_fp_api_usage into data(fm_name_error).

      raise exception type cx_pdf exporting textid = cx_pdf=>cx_custom
                                            custom_message = conv #( 'There was a problem with the form name'(001) )
                                            previous = fm_name_error.

    endtry.

    me->close_form_job( ).

    r_printed_content = output-pdf.

  endmethod.
  method zif_adobe_form_pdf~form_name.

    r_form_name = me->a_name.

  endmethod.
  method zif_adobe_form_pdf~form_function_module_name.

    call function 'FP_FUNCTION_MODULE_NAME'
      exporting
        i_name     = me->form_name( )
      importing
        e_funcname = r_form_internal_name.

  endmethod.
  method zif_adobe_form_pdf~call_form.

    r_output = me->call_form( i_function_module_name = i_function_module_name
                              i_processing_parameters = i_processing_parameters ).

  endmethod.
  method zif_adobe_form_pdf~print_and_download_to_frontend.

    data(print_result) = me->print( ).

    data(print_result_as_solix) = cl_bcs_convert=>xstring_to_solix( print_result ).

    cl_gui_frontend_services=>gui_download( exporting bin_filesize = xstrlen( print_result )
                                                      filename = i_filename
                                                      filetype = 'BIN'
                                                      append = i_append
                                                      header = i_header
                                                      confirm_overwrite = i_confirm_overwrite
                                                      no_auth_check = i_no_auth_check
                                            changing data_tab = print_result_as_solix
                                            exceptions file_write_error = 1
                                                       no_batch = 2
                                                       gui_refuse_filetransfer = 3
                                                       invalid_type = 4
                                                       no_authority = 5
                                                       unknown_error = 6
                                                       header_not_allowed = 7
                                                       separator_not_allowed = 8
                                                       filesize_not_allowed = 9
                                                       header_too_long = 10
                                                       dp_error_create = 11
                                                       dp_error_send = 12
                                                       dp_error_write = 13
                                                       unknown_dp_error = 14
                                                       access_denied = 15
                                                       dp_out_of_memory = 16
                                                       disk_full = 17
                                                       dp_timeout = 18
                                                       file_not_found = 19
                                                       dataprovider_exception = 20
                                                       control_flush_error = 21
                                                       not_supported_by_gui = 22
                                                       error_no_gui = 23
                                                       others = 24 ).

    r_self = cond #( when sy-subrc eq 0
                     then me
                     else throw cx_pdf( textid = cx_pdf=>cx_pdf ) ).

  endmethod.

endclass.
