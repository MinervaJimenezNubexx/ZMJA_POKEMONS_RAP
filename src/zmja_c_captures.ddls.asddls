@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for ZMJA_CAPTURES'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMJA_C_CAPTURES
  as projection on ZMJA_R_CAPTURES
{
  key Captureid,
  key CaptureteamId,
  key CapturetrainerId,
      Nombre,
      Altura,
      Peso,
      @Semantics: {
      systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      /* Associations */
      _Teams : redirected to parent ZMJA_C_TEAMS,
      _Trainer : redirected to ZMJA_C_TRAINERS
}
