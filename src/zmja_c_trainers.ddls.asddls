@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZMJA_TRAINERS'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZMJA_C_TRAINERS
  provider contract transactional_query
  as projection on ZMJA_R_TRAINERS
  association [1..1] to ZMJA_R_TRAINERS as _Trainers on $projection.Trainerid = _Trainers.Trainerid
{
  key Trainerid,
      Firstname,
      Lastname,
      Email,
      Birthdate,
      _Teams : redirected to composition child ZMJA_C_TEAMS,
      //  @Semantics: {
      //    User.Createdby: true
      //  }
      //  CreatedBy,
      //  @Semantics: {
      //    Systemdatetime.Createdat: true
      //  }
      //  CreatedAt,
      //  @Semantics: {
      //    User.Localinstancelastchangedby: true
      //  }
      //  LocalLastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      //  @Semantics: {
      //    Systemdatetime.Lastchangedat: true
      //  }
      //  LastChangedAt,
      _Trainers
}
