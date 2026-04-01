CLASS lhc_teams DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setInactiveOnCreate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Teams~setInactiveOnCreate.
    METHODS validateActiveTeam FOR VALIDATE ON SAVE
      IMPORTING keys FOR Teams~validateActiveTeam.
    METHODS validateTeamMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR Teams~validateTeamMandatoryFields.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Teams RESULT result.

    METHODS CatchWildPokemon FOR MODIFY
      IMPORTING keys FOR ACTION Teams~CatchWildPokemon RESULT result.

ENDCLASS.

CLASS lhc_teams IMPLEMENTATION.

  METHOD setInactiveOnCreate.

    MODIFY ENTITIES OF zmja_r_trainers IN LOCAL MODE
      ENTITY Teams
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys (
                        %tky   = key-%tky
                        Status = abap_false ) ).

  ENDMETHOD.

  METHOD validateActiveTeam.

    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
    ENTITY Teams
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_teams)

    ENTITY Teams BY \_Captures
      FIELDS ( Captureid ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_captures).
    LOOP AT lt_teams INTO DATA(ls_team).

      IF ls_team-Status = abap_true.

        DATA(lv_has_captures) = abap_false.

        LOOP AT lt_captures TRANSPORTING NO FIELDS WHERE CaptureteamId = ls_team-Teamid.
          lv_has_captures = abap_true.
          EXIT.
        ENDLOOP.

        IF lv_has_captures = abap_false.
          APPEND VALUE #( %tky = ls_team-%tky ) TO failed-teams.
          APPEND VALUE #( %tky = ls_team-%tky
                          %msg = new_message(
                                   id       = 'SY'
                                   number   = '002'
                                   severity = if_abap_behv_message=>severity-error
                                   v1       = 'Un equipo vacío no puede estar Activo.' )
                          %element-status = if_abap_behv=>mk-on
                        ) TO reported-teams.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateTeamMandatoryFields.

    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
    ENTITY Teams
    FIELDS ( Name ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_teams).

    LOOP AT lt_teams INTO DATA(ls_team).

      IF ls_team-Name IS INITIAL.

        APPEND VALUE #( %tky = ls_team-%tky ) TO failed-teams.

        APPEND VALUE #( %tky = ls_team-%tky
                        %msg = new_message(
                                 id       = 'SY'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'Faltan campos obligatorios del team por rellenar.' )
                      ) TO reported-teams.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD CatchWildPokemon.

    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
      ENTITY Teams
        FIELDS ( Teamid TeamTrainerId ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_teams).

    DATA(lo_random) = cl_abap_random_int=>create( seed = cl_abap_random=>seed( )
                                                  min  = 1
                                                  max  = 151 ).

    LOOP AT lt_teams INTO DATA(ls_team).

      DATA(lv_pokedex_num) = lo_random->get_next( ).

      SELECT SINGLE * FROM zmja_pokemons
        WHERE pokedex_number = @lv_pokedex_num
        INTO @DATA(ls_wild_pokemon).

      IF sy-subrc = 0.

        MODIFY ENTITIES OF zmja_r_trainers IN LOCAL MODE
          ENTITY Teams
            CREATE BY \_Captures
            FIELDS ( Nombre Altura Peso )
          WITH VALUE #( ( %tky = ls_team-%tky
                          %target = VALUE #( ( %cid      = 'NEW_POKE'
                                               %is_draft = ls_team-%is_draft
                                               Nombre    = ls_wild_pokemon-nombre
                                               Altura    = ls_wild_pokemon-altura
                                               Peso      = ls_wild_pokemon-peso ) ) ) ).

        APPEND VALUE #( %tky = ls_team-%tky
                        %msg = new_message( id       = 'SY'
                                            number   = '002'
                                            severity = if_abap_behv_message=>severity-success
                                            v1       = |¡A wild { ls_wild_pokemon-nombre } was captured!| )
                        %action-CatchWildPokemon = if_abap_behv=>mk-on
                      ) TO reported-teams.
      ENDIF.

    ENDLOOP.

    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
      ENTITY Teams ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_teams_result).

    LOOP AT lt_teams_result INTO DATA(ls_res).
      IF NOT line_exists( failed-teams[ %tky = ls_res-%tky ] ).
        APPEND VALUE #( %tky = ls_res-%tky %param = ls_res ) TO result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.

CLASS lhc_captures DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateUniquePokemon FOR VALIDATE ON SAVE
      IMPORTING keys FOR Captures~validateUniquePokemon.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE Captures.
    METHODS validateCaptureMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR Captures~validateCaptureMandatoryFields.

ENDCLASS.

CLASS lhc_captures IMPLEMENTATION.

  METHOD validateUniquePokemon.
    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
      ENTITY Captures
        FIELDS ( captureteamid nombre ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_captures).

    LOOP AT lt_captures INTO DATA(ls_capture).

      DATA(lv_nombre) = to_lower( ls_capture-nombre ).

      DATA(lv_memory_duplicates) = 0.
      LOOP AT lt_captures INTO DATA(ls_memory)
           WHERE captureteamid = ls_capture-captureteamid
             AND captureid     <> ls_capture-captureid.

        IF to_lower( ls_memory-nombre ) = lv_nombre.
          lv_memory_duplicates += 1.
        ENDIF.
      ENDLOOP.

      SELECT COUNT( * )
        FROM zmja_captures
        WHERE captureteam_id = @ls_capture-captureteamid
          AND lower( nombre ) = @lv_nombre
          AND captureid      <> @ls_capture-captureid
        INTO @DATA(lv_db_duplicates).

      IF lv_memory_duplicates > 0 OR lv_db_duplicates > 0.

        APPEND VALUE #( %tky = ls_capture-%tky ) TO failed-captures.

        APPEND VALUE #( %tky = ls_capture-%tky
                        %msg = new_message(
                                 id       = 'SY'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = |El Pokémon { ls_capture-nombre } ya está en este equipo.| )
                        %element-nombre = if_abap_behv=>mk-on
                      ) TO reported-captures.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD precheck_delete.
    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
      ENTITY Captures
        FIELDS ( CaptureteamId CapturetrainerId ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_captures).

    LOOP AT lt_captures INTO DATA(ls_capture).

      READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
        ENTITY Teams
          FIELDS ( Status ) WITH VALUE #( ( Teamid        = ls_capture-CaptureteamId
                                            TeamTrainerId = ls_capture-CapturetrainerId
                                            %is_draft     = ls_capture-%is_draft ) )
        RESULT DATA(lt_teams).

      READ TABLE lt_teams INTO DATA(ls_team) INDEX 1.
      IF sy-subrc = 0.

        IF ls_team-Status = abap_true.

          READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
            ENTITY Teams BY \_Captures
              FIELDS ( Captureid ) WITH VALUE #( ( %tky = ls_team-%tky ) )
            RESULT DATA(lt_all_captures).

          DATA(lv_capturas_a_borrar) = 0.
          LOOP AT lt_captures INTO DATA(ls_cap_borrada) WHERE CaptureteamId = ls_team-Teamid.
            lv_capturas_a_borrar += 1.
          ENDLOOP.

          IF lines( lt_all_captures ) - lv_capturas_a_borrar <= 0.

            APPEND VALUE #( %tky = ls_capture-%tky ) TO failed-captures.

            APPEND VALUE #( %tky = ls_capture-%tky
                            %msg = new_message(
                                     id       = 'SY'
                                     number   = '002'
                                     severity = if_abap_behv_message=>severity-error
                                     v1       = 'Un equipo Activo no se puede quedar vacio.' )
                          ) TO reported-captures.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCaptureMandatoryFields.

    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
    ENTITY Captures
    FIELDS ( Nombre Altura Peso ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_captures).

    LOOP AT lt_captures INTO DATA(ls_capture).

      IF ls_capture-Nombre IS INITIAL OR
         ls_capture-Altura IS INITIAL OR
         ls_capture-Peso   IS INITIAL.

        APPEND VALUE #( %tky = ls_capture-%tky ) TO failed-captures.

        APPEND VALUE #( %tky = ls_capture-%tky
                        %msg = new_message(
                                 id       = 'SY'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'Faltan campos obligatorios de la captura por rellenar.' )
                      ) TO reported-captures.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zmja_r_trainers DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Trainers
        RESULT result,
      validateEmail FOR VALIDATE ON SAVE
        IMPORTING keys FOR Trainers~validateEmail,
      validateAge FOR VALIDATE ON SAVE
        IMPORTING keys FOR Trainers~validateAge,
      validateTrainerMandatoryFields FOR VALIDATE ON SAVE
        IMPORTING keys FOR Trainers~validateTrainerMandatoryFields.
ENDCLASS.

CLASS lhc_zmja_r_trainers IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validateEmail.
    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
      ENTITY Trainers
        FIELDS ( Email ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_trainers).

    LOOP AT lt_trainers INTO DATA(ls_trainer).

      DATA(lv_email) = to_lower( ls_trainer-Email ).

      IF lv_email IS NOT INITIAL AND
         NOT lv_email CP '*@nubexx.es' AND
         NOT lv_email CP '*@nubexx.com'.

        APPEND VALUE #( %tky = ls_trainer-%tky ) TO failed-trainers.

        APPEND VALUE #( %tky = ls_trainer-%tky
                        %msg = new_message(
                                 id       = 'SY'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'El email debe terminar en @nubexx.es o .com' )
                        %element-email = if_abap_behv=>mk-on
                      ) TO reported-trainers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateAge.
    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
      ENTITY Trainers
        FIELDS ( Birthdate ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_trainers).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_trainers INTO DATA(ls_trainer).

      IF ls_trainer-Birthdate IS NOT INITIAL.

        DATA(lv_age) = lv_today(4) - ls_trainer-Birthdate(4).

        IF lv_today+4(4) < ls_trainer-Birthdate+4(4).
          lv_age -= 1.
        ENDIF.

        IF lv_age < 18 OR lv_age > 100.

          APPEND VALUE #( %tky = ls_trainer-%tky ) TO failed-trainers.

          APPEND VALUE #( %tky = ls_trainer-%tky
                          %msg = new_message(
                                   id       = 'SY'
                                   number   = '002'
                                   severity = if_abap_behv_message=>severity-error
                                   v1       = 'El entrenador debe tener entre 18 y 100 años.' )
                          %element-birthdate = if_abap_behv=>mk-on
                        ) TO reported-trainers.
        ENDIF.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateTrainerMandatoryFields.

    READ ENTITIES OF zmja_r_trainers IN LOCAL MODE
    ENTITY Trainers
    FIELDS ( Firstname Lastname Email Birthdate ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_trainers).

    LOOP AT lt_trainers INTO DATA(ls_trainer).

      IF ls_trainer-Firstname IS INITIAL OR
         ls_trainer-Lastname  IS INITIAL OR
         ls_trainer-Email     IS INITIAL OR
         ls_trainer-Birthdate IS INITIAL.

        APPEND VALUE #( %tky = ls_trainer-%tky ) TO failed-trainers.

        APPEND VALUE #( %tky = ls_trainer-%tky
                        %msg = new_message(
                                 id       = 'SY'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'Faltan campos obligatorios del trainer por rellenar.' )
                      ) TO reported-trainers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
