import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/bloc/auth_bloc.dart';
import 'package:google_login/home/noticias_firebase/my_news.dart';
import 'noticias_ext_api/noticias.dart';
import 'package:google_login/home/noticias_firebase/create_news.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final _titulosList = [
    "Noticias",
    "Mis noticias",
    "Crear noticia",
  ];
  final _pagesList = [
    Noticias(),
    MisNoticias(),
    CrearNoticia(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_titulosList[_currentPageIndex]}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                SignOutAuthenticationEvent(),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pagesList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_new),
            label: "${_titulosList[0]}",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "${_titulosList[1]}",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_upload),
            label: "${_titulosList[2]}",
          ),
        ],
      ),
    );
  }
}
