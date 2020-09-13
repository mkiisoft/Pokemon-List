import 'dart:async';
import 'package:pokeapi/model/pokemon/pokemon-specie.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';
import 'package:pokeapi/pokeapi.dart';

class PokeService {
  static Stream<List<Pokemon>> getPokemon(int offset, int limit) {
    return Stream.fromFuture(_getPokemon(offset, limit));
  }

  static Future<List<Pokemon>> _getPokemon(int offset, int limit) async {
    return await PokeAPI.getObjectList<Pokemon>(offset, limit);
  }

  static Future<Pokemon> getDetails(int id) async {
    return PokeAPI.getObject<Pokemon>(id);
  }

  static Future<PokemonSpecie> getSpecie(int id) async {
    return PokeAPI.getObject<PokemonSpecie>(id);
  }
}