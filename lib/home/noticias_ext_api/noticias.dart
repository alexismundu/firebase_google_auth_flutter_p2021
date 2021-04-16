import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_ext_api/bloc/noticia_bloc.dart';
import 'package:google_login/models/new.dart';

import 'item_noticia.dart';

class Noticias extends StatelessWidget {
  const Noticias({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            NoticiaBloc()..add(NoticiaRequested(query: 'futbol')),
        child: BlocBuilder<NoticiaBloc, NoticiaState>(
          builder: (context, state) {
            if (state is NoticiaLoadFailure) {
              return Center(
                child: Text("Algo salio mal", style: TextStyle(fontSize: 32)),
              );
            }
            if (state is NoticiaLoadSuccess) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    onFieldSubmitted: (value) {
                      BlocProvider.of<NoticiaBloc>(context)
                          .add(NoticiaRequested(query: value));
                    },
                    decoration: InputDecoration(
                      labelText: 'Buscar...',
                      hintText: 'Deportes',
                    ),
                  ),
                  ListaNoticias(noticias: state.noticias),
                ],
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          },
        ));
  }
}

class ListaNoticias extends StatelessWidget {
  final List<New> noticias;
  const ListaNoticias({Key key, @required this.noticias}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: this.noticias.length,
        itemBuilder: (context, index) {
          return ItemNoticia(
            noticia: this.noticias[index],
          );
        },
      ),
    );
  }
}
