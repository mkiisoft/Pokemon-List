import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:poke_list/details.dart';
import 'package:poke_list/location.dart';
import 'package:poke_list/poke_bloc.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';

void main() => runApp(PokeApp());

class PokeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PokeBlocState(
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<Location> _location = ValueNotifier(null);
  ScrollController _scrollController;
  PokeBloc _bloc;

  ValueNotifier<bool> _loading = ValueNotifier(false);
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchLocation().then((location) => _location.value = location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokemon List')),
      body: ValueListenableBuilder<List<Pokemon>>(
        valueListenable: _bloc.pokemon,
        builder: (context, pokemon, child) {
          if (pokemon == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ValueListenableBuilder(
              valueListenable: _loading,
              builder: (context, loading, child) {
                return Column(
                  children: [
                    ValueListenableBuilder<Location>(
                      valueListenable: _location,
                      builder: (context, location, child) {
                        return location != null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    top: 16,
                                    bottom: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Welcome trainer from:'),
                                      SizedBox(height: 4),
                                      Text(
                                        '${location.countryName} - ${location.city}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox();
                      },
                    ),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 16,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final poke = pokemon[index];
                          return GestureDetector(
                            onTap: () => _goToDetails(poke.id),
                            child: Card(
                              elevation: 12,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      poke.sprites.frontDefault,
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        poke.name,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: pokemon.length,
                      ),
                    ),
                    SafeArea(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _loading.value ? 40 : 0,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Loading more...',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_loading.value) {
        _loading.value = true;
        _bloc.fetchMore(_page).then((value) {
          _page += 1;
          _loading.value = false;
        });
      }
    }
  }

  void _goToDetails(int id) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PokeBlocState(child: DetailScreen(id: id)),
    ));
  }

  Future<Location> _fetchLocation() async {
    final response = await http.get('https://freegeoip.app/json/');
    final json = await jsonDecode(response.body);
    return Location.fromJson(json);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = PokeBlocState.of(context);
    }
  }
}
