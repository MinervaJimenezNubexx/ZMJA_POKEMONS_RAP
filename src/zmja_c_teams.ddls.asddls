@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for ZMJA_TEAMS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMJA_C_TEAMS
  as projection on ZMJA_R_TEAMS
{
  key Teamid,
  key TeamTrainerId,
      Name,
      Status,
      @Semantics: {
      systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      /* Associations */
      _Trainer  : redirected to parent ZMJA_C_TRAINERS,
      _Captures : redirected to composition child ZMJA_C_CAPTURES
}
