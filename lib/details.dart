import 'package:flutter/material.dart';
import 'package:poke_list/gen/assets.gen.dart';
import 'package:poke_list/poke_bloc.dart';
import 'package:poke_list/utils.dart';
import 'package:pokeapi/model/pokemon/pokemon-specie.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({Key key, this.id}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  PokeBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
        leading: InkResponse(
          child: Icon(Icons.arrow_back),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<Pokemon>(
          future: _bloc.fetchPokemon(widget.id),
          builder: (context, pokemon) {
            if (pokemon.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      height: 280,
                      child: FadeInImage.assetNetwork(
                        placeholder: Assets.images.loading.path,
                        image: pokemon.data.sprites.frontDefault,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(pokemon.data.name, style: TextStyle(fontSize: 30)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pokemon.data.types
                          .map(
                            (type) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                color: Utils.colorType(type.type.name),
                                elevation: 15,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    type.type.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 40),
                    FutureBuilder<PokemonSpecie>(
                      future: _bloc.fetchSpecie(widget.id),
                      builder: (context, specie) {
                        if (specie.hasData) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              specie.data.flavorTextEntries
                                  .where((item) => item.language.name == 'en')
                                  .toList()
                                  .first
                                  .flavorText
                                  .replaceAll('\n', ' ')
                                  .replaceAll('\f', ' '),
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = PokeBlocState.of(context);
  }
}
