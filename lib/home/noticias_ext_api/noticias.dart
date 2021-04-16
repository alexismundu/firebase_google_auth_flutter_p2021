import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_ext_api/bloc/noticia_bloc.dart';

import 'item_noticia.dart';

class Noticias extends StatelessWidget {
  const Noticias({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NoticiaBloc(),
        child: BlocBuilder<NoticiaBloc, NoticiaState>(
          builder: (context, state) {
            if (state is NoticiaInitial) {
              BlocProvider.of<NoticiaBloc>(context)
                  .add(NoticiaRequested(query: 'sports'));
            }
            if (state is NoticiaLoadFailure) {
              return Center(
                child: Text("Algo salio mal", style: TextStyle(fontSize: 32)),
              );
            }
            if (state is NoticiaLoadSuccess) {
              return ListView.builder(
                itemCount: state.noticias.length,
                itemBuilder: (context, index) {
                  return ItemNoticia(
                    noticia: state.noticias[index],
                  );
                },
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
