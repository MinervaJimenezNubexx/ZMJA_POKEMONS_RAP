@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZMJA_R_TEAMS
  as select from zmja_teams

  association to parent ZMJA_R_TRAINERS as _Trainer on $projection.TeamTrainerId = _Trainer.Trainerid
  composition [0..*] of ZMJA_R_CAPTURES as _Captures
{
  key teamid                as Teamid,
  key teamtrainer_id        as TeamTrainerId,
      name                  as Name,
      status                as Status,
      _Trainer,
      _Captures,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt
}
