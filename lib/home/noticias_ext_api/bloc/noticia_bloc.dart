import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';
import 'package:hive/hive.dart';

part 'noticia_event.dart';
part 'noticia_state.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  String query;
  Box _newsBox = Hive.box("Noticias");

  NoticiaBloc() : super(NoticiaInitial());

  @override
  Stream<NoticiaState> mapEventToState(
    NoticiaEvent event,
  ) async* {
    if (event is NoticiaRequested) {
      yield NoticiaLoadInProgress();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          final List<New> noticias =
              await NewsRepository().getAvailableNoticias(event.query);
          // Guardamos las noticias en el cache para la siguiente ocasión que no
          // haya internet entonces podemos devolver esas como default
          await _newsBox.put("lista", noticias);
          yield NoticiaLoadSuccess(noticias: noticias);
        } catch (_) {
          yield NoticiaLoadFailure();
        }
      } else {
        try {
          final List<New> noticias =
              List<New>.from(_newsBox.get("lista", defaultValue: []));
          yield NoticiaLoadSuccess(noticias: noticias);
        } catch (_) {
          yield NoticiaLoadFailure();
        }
      }
    }
  }

  Stream<NoticiaState> getNoticiasInternet(NoticiaRequested event) async* {
    try {
      final List<New> noticias =
          await NewsRepository().getAvailableNoticias(event.query);
      // Guardamos las noticias en el cache para la siguiente ocasión que no
      // haya internet entonces podemos devolver esas como default
      await _newsBox.put("noticias", noticias);
      yield NoticiaLoadSuccess(noticias: noticias);
    } catch (_) {
      yield NoticiaLoadFailure();
    }
  }

  Stream<NoticiaState> getNoticiasCache() async* {
    try {
      final List<New> noticias = _newsBox.get("noticias", defaultValue: []);
      yield NoticiaLoadSuccess(noticias: noticias);
    } catch (_) {
      yield NoticiaLoadFailure();
    }
  }
}
