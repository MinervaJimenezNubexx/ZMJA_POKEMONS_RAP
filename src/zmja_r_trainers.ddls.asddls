@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZMJA_TRAINERS'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZMJA_R_TRAINERS
  as select from zmja_trainers as Trainers

  composition [0..*] of ZMJA_R_TEAMS as _Teams
{
  key trainerid             as Trainerid,
      firstname             as Firstname,
      lastname              as Lastname,
      email                 as Email,
      birthdate             as Birthdate,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _Teams
}
