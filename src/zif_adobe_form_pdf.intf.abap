"! <p class="shorttext synchronized" lang="EN">AdobeForm PDF file</p>
interface zif_adobe_form_pdf public.

  "! <p class="shorttext synchronized" lang="EN">Return parameters to run { @link FUNC:FP_JOB_OPEN }</p>
  "!
  "! @parameter r_output_processing_params | <p class="shorttext synchronized" lang="EN"></p>
  methods output_processing_parameters
            returning
              value(r_output_processing_params) type sfpoutputparams.

  "! <p class="shorttext synchronized" lang="EN">Return parameters to run the form FM</p>
  "!
  "! @parameter r_document_processing_params | <p class="shorttext synchronized" lang="EN"></p>
  methods document_processing_parameters
            returning
              value(r_document_processing_params) type sfpdocparams.

  "! <p class="shorttext synchronized" lang="EN">Return the form name</p>
  "!
  "! @parameter r_form_name | <p class="shorttext synchronized" lang="EN"></p>
  methods form_name
            returning
              value(r_form_name) type fpname.

  "! <p class="shorttext synchronized" lang="EN">Return the name of the FM associated with the form</p>
  "!
  "! @parameter r_form_internal_name | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_fp_api_repository | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_fp_api_usage | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_fp_api_internal | <p class="shorttext synchronized" lang="EN"></p>
  methods form_function_module_name
            returning
              value(r_form_internal_name) type funcname
            raising
              cx_fp_api_repository
              cx_fp_api_usage
              cx_fp_api_internal.

  "! <p class="shorttext synchronized" lang="EN">Run form FM</p>
  "!
  "! @parameter i_function_module_name | <p class="shorttext synchronized" lang="EN"></p>
  "! @parameter i_processing_parameters | <p class="shorttext synchronized" lang="EN"></p>
  "! @parameter r_output | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_pdf | <p class="shorttext synchronized" lang="EN"></p>
  methods call_form
            importing
              value(i_function_module_name) type funcname
              value(i_processing_parameters) type sfpdocparams
            returning
              value(r_output) type fpformoutput
            raising
              cx_pdf.

  "! <p class="shorttext synchronized" lang="EN">Run from start to finish and get an output</p>
  "!
  "! @parameter r_printed_content | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_pdf | <p class="shorttext synchronized" lang="EN"></p>
  methods print
            returning
              value(r_printed_content) type fpformoutput-pdf
            raising
              cx_pdf.

  "! <p class="shorttext synchronized" lang="EN">Run { @link .METH:print} and {@link FUNC:GUI_DOWNLOAD }</p>
  "!
  "! @parameter i_filename | <p class="shorttext synchronized" lang="EN">Local file path and name (should end in '.pdf')</p>
  "! @parameter i_append | <p class="shorttext synchronized" lang="EN">Append content instead of overwriting</p>
  "! @parameter i_header | <p class="shorttext synchronized" lang="EN"></p>
  "! @parameter i_confirm_overwrite | <p class="shorttext synchronized" lang="EN"></p>
  "! @parameter i_no_auth_check | <p class="shorttext synchronized" lang="EN"></p>
  "! @parameter r_self | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_pdf | <p class="shorttext synchronized" lang="EN"></p>
  methods print_and_download_to_frontend
            importing
              i_filename type string default 'adobeForm.pdf'
              i_append type sap_bool default abap_false
              i_header type xstring default '00'
              i_confirm_overwrite type sap_bool default abap_false
              i_no_auth_check type sap_bool default abap_false
            returning
              value(r_self) type ref to zif_adobe_form_pdf
            raising
              cx_pdf.

  "! <p class="shorttext synchronized" lang="EN">Run { @link FUNC:FP_JOB_OPEN }</p>
  "!
  "! @parameter r_self | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_pdf | <p class="shorttext synchronized" lang="EN"></p>
  methods open_form_job
            returning
              value(r_self) type ref to zif_adobe_form_pdf
            raising
              cx_pdf.

  "! <p class="shorttext synchronized" lang="EN">Run { @link FUNC:FP_JOB_CLOSE }</p>
  "!
  "! @parameter r_result | <p class="shorttext synchronized" lang="EN"></p>
  "! @raising cx_pdf | <p class="shorttext synchronized" lang="EN"></p>
  methods close_form_job
            returning
              value(r_result) type sfpjoboutput
            raising
              cx_pdf.

endinterface.
