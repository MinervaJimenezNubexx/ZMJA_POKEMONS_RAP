@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista de lectura de Pokémons'
define root view entity ZMJA_C_POKEMONS
  as select from zmja_pokemons
{
  key pokedex_number as PokedexNumber,
      nombre         as Nombre,
      altura         as Altura,
      peso           as Peso
}
