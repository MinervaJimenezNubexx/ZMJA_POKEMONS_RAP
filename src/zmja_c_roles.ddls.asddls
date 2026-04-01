@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista de lectura de Roles'
define root view entity ZMJA_C_ROLES 
    as select from zmja_roles
{
    key rolid as Rolid,
    key rolname as Rolname,
    edit as Edit,
    viewer as Viewer,
    admin as Admin,
    capturepokemon as Capturepokemon
}
