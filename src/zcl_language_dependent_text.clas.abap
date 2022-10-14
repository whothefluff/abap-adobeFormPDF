"! <p class="shorttext synchronized" lang="EN">Language dependent text</p>
class zcl_language_dependent_text definition
                                  public
                                  create public.

  public section.

    interfaces: zif_language_dependent_text.

    aliases: in for zif_language_dependent_text~in,
             in_current_language for zif_language_dependent_text~in_current_language,
             available_languages for zif_language_dependent_text~available_languages,
             available_translations for zif_language_dependent_text~available_translations.

    "! <p class="shorttext synchronized" lang="EN">Creates a text with the supplied translations</p>
    "!
    "! @parameter i_translations | <p class="shorttext synchronized" lang="EN"></p>
    methods constructor
              importing
                i_translations type zif_language_dependent_text=>t_translations.

  protected section.

    data a_translation_list type zif_language_dependent_text=>t_translations.

ENDCLASS.



CLASS ZCL_LANGUAGE_DEPENDENT_TEXT IMPLEMENTATION.


  method constructor.

    me->a_translation_list = i_translations.

  endmethod.


  method in.

    read table me->available_translations( ) with key language_key = i_language_key into data(found_translation) transporting content.

    r_text_in_supplied_language = cond #( when sy-subrc eq 0
                                          then found_translation-content
                                          else throw cx_sy_itab_line_not_found( key_name = 'language key'
                                                                                key_comp_values = |{ i_language_key }| ) ).

  endmethod.


  method available_languages.

    r_languages = value #( for <translation> in me->available_translations( )
                           ( <translation>-language_key ) ).

  endmethod.


  method in_current_language.

    r_text_in_current_language = me->in( cl_abap_syst=>get_language( ) ).

  endmethod.


  method available_translations.

    r_translations = me->a_translation_list.

  endmethod.
ENDCLASS.
