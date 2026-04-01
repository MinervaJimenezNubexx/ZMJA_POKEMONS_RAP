CLASS zmja_load_roles DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zmja_load_roles IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lt_roles TYPE STANDARD TABLE OF zmja_roles,
          ls_roles TYPE zmja_roles.

    DELETE FROM zmja_roles.

    CLEAR ls_roles.
    TRY.
        ls_roles-rolid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_roles-rolname        = 'Manager'.
    ls_roles-edit           = abap_true.
    ls_roles-viewer         = abap_true.
    ls_roles-admin          = abap_true.
    ls_roles-capturepokemon = abap_false.
    APPEND ls_roles TO lt_roles.

    CLEAR ls_roles.
    TRY.
        ls_roles-rolid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_roles-rolname        = 'Trainer'.
    ls_roles-edit           = abap_true.
    ls_roles-viewer         = abap_true.
    ls_roles-admin          = abap_false.
    ls_roles-capturepokemon = abap_true.
    APPEND ls_roles TO lt_roles.

    CLEAR ls_roles.
    TRY.
        ls_roles-rolid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_roles-rolname        = 'Viewer'.
    ls_roles-edit           = abap_false.
    ls_roles-viewer         = abap_true.
    ls_roles-admin          = abap_false.
    ls_roles-capturepokemon = abap_false.
    APPEND ls_roles TO lt_roles.

    MODIFY zmja_roles FROM TABLE @lt_roles.

    out->write( 'Limpieza completada y datos mock reinsertados' ).
    out->write( |Se han cargado { lines( lt_roles ) } roles en ZMJA_ROLES.| ).

  ENDMETHOD.

ENDCLASS.
