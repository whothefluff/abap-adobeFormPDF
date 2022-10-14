# abap-adobeFormPDF
Create a .pdf file from an AdobeForm name

Use example

```
class some_adobe_form_pdf definition
                          create public
                          inheriting from zcl_adobe_form_pdf.
  public section.

    methods constructor.

    methods call_form redefinition.

endclass.
```
```
class some_adobe_form_pdf implementation.

  method call_form.

    call function i_function_module_name
      exporting
        /1bcdwb/docparams  = i_processing_parameters
        parameter1         = data1
        parameter2         = data2
        ...
      importing
        /1bcdwb/formoutput = r_output
      exceptions
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        others             = 4.

    if sy-subrc ne 0.

      raise exception type cx_pdf exporting textid = cx_pdf=>cx_pdf.

    endif.

  endmethod.
  method constructor.

    constants go type xuspdb value 'G'. "the other possible value is (H)old

    constants delete type xuspda value 'D'. "the other possible value is (K)eep

    select single spld as output_device,
                  spdb as print_immediately,
                  spda as delete_immetiately
      from usr01
      where bname eq @( cl_abap_syst=>get_user_name( ) )
      into @data(current_user_data).

    super->constructor( i_name = 'ADOBE_FORM_NAME'
                        i_output_processing_params = value #( dest = current_user_data-output_device
                                                              reqnew = abap_true
                                                              reqimm = xsdbool( current_user_data-print_immediately eq go )
                                                              reqdel = xsdbool( current_user_data-delete_immetiately eq delete )
                                                              reqfinal = abap_true )
                        i_document_processing_params = value #( langu = cl_abap_syst=>get_language( ) ) ).

  endmethod.

endclass.
```
```
start-of-selection.

  try.

    new some_adobe_form_pdf( )->print_and_download_to_frontend( i_filename = 'something.pdf' ).

  catch cx_.

    ...

  endtry.
```
