@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View entity for ZMJA_CAPTURES'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMJA_R_CAPTURES
  as select from zmja_captures
  association        to parent ZMJA_R_TEAMS as _Teams   on  $projection.CaptureteamId    = _Teams.Teamid
                                                        and $projection.CapturetrainerId = _Teams.TeamTrainerId
  association [1..1] to ZMJA_R_TRAINERS     as _Trainer on  $projection.CapturetrainerId = _Trainer.Trainerid
{
  key captureid             as Captureid,
  key captureteam_id        as CaptureteamId,
  key capturetrainer_id     as CapturetrainerId,
      nombre                as Nombre,
      altura                as Altura,
      peso                  as Peso,
      _Teams,
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
      _Trainer
}
