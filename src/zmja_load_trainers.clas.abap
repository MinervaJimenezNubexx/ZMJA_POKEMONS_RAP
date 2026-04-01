CLASS zmja_load_trainers DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zmja_load_trainers IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " Variables
    DATA: lt_trainers TYPE STANDARD TABLE OF zmja_trainers,
          ls_trainers TYPE zmja_trainers,
          lt_teams    TYPE STANDARD TABLE OF zmja_teams,
          ls_teams    TYPE zmja_teams,
          lt_captures TYPE STANDARD TABLE OF zmja_captures,
          ls_captures TYPE zmja_captures.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    " Limpieza inicial para no duplicar datos
    DELETE FROM zmja_trainers.
    DELETE FROM zmja_teams.
    DELETE FROM zmja_captures.

    " Borramos el mundo fantasma (Drafts)
    DELETE FROM zmja_dtrainers.
    DELETE FROM zmja_dteams.
    DELETE FROM zmja_dcapture.

    " =========================================
    " 1. ASH KETCHUM
    " =========================================
    CLEAR ls_trainers.
    TRY.
        ls_trainers-trainerid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_trainers-firstname             = 'Ash'.
    ls_trainers-lastname              = 'Ketchum'.
    ls_trainers-email                 = 'ashketchum@nubexx.es'.
    ls_trainers-birthdate             = '19970401'.
    ls_trainers-created_by            = sy-uname.
    ls_trainers-created_at            = lv_timestamp.
    ls_trainers-local_last_changed_by = sy-uname.
    ls_trainers-local_last_changed_at = lv_timestamp.
    ls_trainers-last_changed_at       = lv_timestamp.
    APPEND ls_trainers TO lt_trainers.

    " --- Equipo 1: Eléctrico ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Eléctrico'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 1.1: Pikachu
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'pikachu'.
    ls_captures-altura                = 4.
    ls_captures-peso                  = 60.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 1.2: Raichu
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'raichu'.
    ls_captures-altura                = 8.
    ls_captures-peso                  = 300.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " --- Equipo 2: Volador ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Volador'.
    ls_teams-status                = abap_false.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 2.1: Pidgeot
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'pidgeot'.
    ls_captures-altura                = 15.
    ls_captures-peso                  = 395.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 2.2: Aerodactyl
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'aerodactyl'.
    ls_captures-altura                = 18.
    ls_captures-peso                  = 590.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " =========================================
    " 2. MISTY
    " =========================================
    CLEAR ls_trainers.
    TRY.
        ls_trainers-trainerid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_trainers-firstname             = 'Misty'.
    ls_trainers-lastname              = 'Waterflower'.
    ls_trainers-email                 = 'misty@nubexx.es'.
    ls_trainers-birthdate             = '19980505'.
    ls_trainers-created_by            = sy-uname.
    ls_trainers-created_at            = lv_timestamp.
    ls_trainers-local_last_changed_by = sy-uname.
    ls_trainers-local_last_changed_at = lv_timestamp.
    ls_trainers-last_changed_at       = lv_timestamp.
    APPEND ls_trainers TO lt_trainers.

    " --- Equipo 1: Agua ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Agua'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 1.1: Starmie
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'starmie'.
    ls_captures-altura                = 11.
    ls_captures-peso                  = 800.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 1.2: Gyarados
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'gyarados'.
    ls_captures-altura                = 65.
    ls_captures-peso                  = 2350.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " --- Equipo 2: Hielo ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Hielo'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 2.1: Lapras
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'lapras'.
    ls_captures-altura                = 25.
    ls_captures-peso                  = 2200.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 2.2: Dewgong
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'dewgong'.
    ls_captures-altura                = 17.
    ls_captures-peso                  = 1200.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " =========================================
    " 3. BROCK
    " =========================================
    CLEAR ls_trainers.
    TRY.
        ls_trainers-trainerid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_trainers-firstname             = 'Brock'.
    ls_trainers-lastname              = 'Harrison'.
    ls_trainers-email                 = 'brock@nubexx.es'.
    ls_trainers-birthdate             = '19951115'.
    ls_trainers-created_by            = sy-uname.
    ls_trainers-created_at            = lv_timestamp.
    ls_trainers-local_last_changed_by = sy-uname.
    ls_trainers-local_last_changed_at = lv_timestamp.
    ls_trainers-last_changed_at       = lv_timestamp.
    APPEND ls_trainers TO lt_trainers.

    " --- Equipo 1: Roca ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Roca'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 1.1: Golem
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'golem'.
    ls_captures-altura                = 14.
    ls_captures-peso                  = 3000.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 1.2: Onix
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'onix'.
    ls_captures-altura                = 88.
    ls_captures-peso                  = 2100.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " --- Equipo 2: Tierra ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Tierra'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 2.1: Sandslash
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'sandslash'.
    ls_captures-altura                = 10.
    ls_captures-peso                  = 295.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 2.2: Dugtrio
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'dugtrio'.
    ls_captures-altura                = 7.
    ls_captures-peso                  = 333.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " =========================================
    " 4. GARY OAK
    " =========================================
    CLEAR ls_trainers.
    TRY.
        ls_trainers-trainerid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_trainers-firstname             = 'Gary'.
    ls_trainers-lastname              = 'Oak'.
    ls_trainers-email                 = 'gary.oak@nubexx.es'.
    ls_trainers-birthdate             = '19970401'.
    ls_trainers-created_by            = sy-uname.
    ls_trainers-created_at            = lv_timestamp.
    ls_trainers-local_last_changed_by = sy-uname.
    ls_trainers-local_last_changed_at = lv_timestamp.
    ls_trainers-last_changed_at       = lv_timestamp.
    APPEND ls_trainers TO lt_trainers.

    " --- Equipo 1: Fuego ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Fuego'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 1.1: Arcanine
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'arcanine'.
    ls_captures-altura                = 19.
    ls_captures-peso                  = 1550.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 1.2: Rapidash
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'rapidash'.
    ls_captures-altura                = 17.
    ls_captures-peso                  = 950.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " --- Equipo 2: Veneno ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Veneno'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 2.1: Nidoking
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'nidoking'.
    ls_captures-altura                = 14.
    ls_captures-peso                  = 620.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 2.2: Muk
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'muk'.
    ls_captures-altura                = 12.
    ls_captures-peso                  = 300.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " =========================================
    " 5. CYNTHIA
    " =========================================
    CLEAR ls_trainers.
    TRY.
        ls_trainers-trainerid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_trainers-firstname             = 'Cynthia'.
    ls_trainers-lastname              = 'Celestic'.
    ls_trainers-email                 = 'cynthia@nubexx.es'.
    ls_trainers-birthdate             = '19900928'.
    ls_trainers-created_by            = sy-uname.
    ls_trainers-created_at            = lv_timestamp.
    ls_trainers-local_last_changed_by = sy-uname.
    ls_trainers-local_last_changed_at = lv_timestamp.
    ls_trainers-last_changed_at       = lv_timestamp.
    APPEND ls_trainers TO lt_trainers.

    " --- Equipo 1: Dragón ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Dragón'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 1.1: Dragonite
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'dragonite'.
    ls_captures-altura                = 22.
    ls_captures-peso                  = 2100.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 1.2: Dragonair
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'dragonair'.
    ls_captures-altura                = 40.
    ls_captures-peso                  = 165.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " --- Equipo 2: Fantasma ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Fantasma'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 2.1: Gengar
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'gengar'.
    ls_captures-altura                = 15.
    ls_captures-peso                  = 405.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 2.2: Haunter
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'haunter'.
    ls_captures-altura                = 16.
    ls_captures-peso                  = 1.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " =========================================
    " 6. RED
    " =========================================
    CLEAR ls_trainers.
    TRY.
        ls_trainers-trainerid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_trainers-firstname             = 'Red'.
    ls_trainers-lastname              = 'Kanto'.
    ls_trainers-email                 = 'red.legend@nubexx.es'.
    ls_trainers-birthdate             = '19960227'.
    ls_trainers-created_by            = sy-uname.
    ls_trainers-created_at            = lv_timestamp.
    ls_trainers-local_last_changed_by = sy-uname.
    ls_trainers-local_last_changed_at = lv_timestamp.
    ls_trainers-last_changed_at       = lv_timestamp.
    APPEND ls_trainers TO lt_trainers.

    " --- Equipo 1: Planta ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Planta'.
    ls_teams-status                = abap_true.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 1.1: Venusaur
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'venusaur'.
    ls_captures-altura                = 20.
    ls_captures-peso                  = 1000.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 1.2: Exeggutor
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'exeggutor'.
    ls_captures-altura                = 20.
    ls_captures-peso                  = 1200.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " --- Equipo 2: Psíquico ---
    CLEAR ls_teams.
    TRY.
        ls_teams-teamid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_teams-teamtrainer_id        = ls_trainers-trainerid.
    ls_teams-name                  = 'Equipo Psíquico'.
    ls_teams-status                = abap_false.
    ls_teams-created_by            = sy-uname.
    ls_teams-created_at            = lv_timestamp.
    ls_teams-local_last_changed_by = sy-uname.
    ls_teams-local_last_changed_at = lv_timestamp.
    ls_teams-last_changed_at       = lv_timestamp.
    APPEND ls_teams TO lt_teams.

    " Captura 2.1: Alakazam
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'alakazam'.
    ls_captures-altura                = 15.
    ls_captures-peso                  = 480.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " Captura 2.2: Mewtwo
    CLEAR ls_captures.
    TRY.
        ls_captures-captureid = xco_cp=>uuid( )->value.
      CATCH cx_uuid_error.
    ENDTRY.
    ls_captures-captureteam_id        = ls_teams-teamid.
    ls_captures-capturetrainer_id     = ls_trainers-trainerid.
    ls_captures-nombre                = 'mewtwo'.
    ls_captures-altura                = 20.
    ls_captures-peso                  = 1220.
    ls_captures-created_by            = sy-uname.
    ls_captures-created_at            = lv_timestamp.
    ls_captures-local_last_changed_by = sy-uname.
    ls_captures-local_last_changed_at = lv_timestamp.
    ls_captures-last_changed_at       = lv_timestamp.
    APPEND ls_captures TO lt_captures.

    " =========================================
    " GUARDADO FINAL EN BASE DE DATOS
    " =========================================
    MODIFY zmja_trainers FROM TABLE @lt_trainers.
    MODIFY zmja_teams FROM TABLE @lt_teams.
    MODIFY zmja_captures FROM TABLE @lt_captures.

    out->write( 'Limpieza completada y datos mock reinsertados' ).
    out->write( |Se han cargado { lines( lt_trainers ) } trainers en ZMJA_TRAINERS.| ).
    out->write( |Se han cargado { lines( lt_teams ) } teams en ZMJA_TEAMS.| ).
    out->write( |Se han cargado { lines( lt_captures ) } captures en ZMJA_CAPTURES.| ).
  ENDMETHOD.

ENDCLASS.
