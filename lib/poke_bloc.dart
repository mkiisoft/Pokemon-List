import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poke_list/poke_service.dart';
import 'package:pokeapi/model/pokemon/pokemon-specie.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';

class PokeBlocState extends StatefulWidget {
  final Widget child;

  const PokeBlocState({Key key, @required this.child}) : super(key: key);

  static PokeBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PokeInherited>().data;
  }

  @override
  State<StatefulWidget> createState() {
    return PokeBloc();
  }
}

class PokeBloc extends State<PokeBlocState> {
  StreamSubscription<List<Pokemon>> _sub;
  Stream<List<Pokemon>> _stream;
  final _items = <Pokemon>[];

  final _pokemon = ValueNotifier<List<Pokemon>>(null);

  ValueNotifier<List<Pokemon>> get pokemon => _pokemon;

  PokeBloc() {
    _stream = PokeService.getPokemon(1, 13);
    _sub = _stream.listen(_fetchList);
  }

  void _fetchList(List<Pokemon> pokemon) {
    _items.addAll(pokemon);
    _pokemon.value = _items;
  }

  Future<bool> fetchMore(int page) async {
    final pokemon =
        await PokeService.getPokemon(page * 14, 14).first;
    _items.addAll(pokemon);
    _pokemon.value = []..addAll(_items);
    return true;
  }

  Future<Pokemon> fetchPokemon(int id) async {
    return PokeService.getDetails(id);
  }

  Future<PokemonSpecie> fetchSpecie(int id) async {
    return PokeService.getSpecie(id);
  }

  @override
  void dispose(){
    disposeItems();
    super.dispose();
  }

  void disposeItems() async {
    await _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PokeInherited(
      child: widget.child,
      data: this,
    );
  }
}

class PokeInherited extends InheritedWidget {
  final PokeBloc data;

  const PokeInherited({
    Key key,
    @required Widget child,
    @required this.data,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(PokeInherited old) {
    return true;
  }
}
