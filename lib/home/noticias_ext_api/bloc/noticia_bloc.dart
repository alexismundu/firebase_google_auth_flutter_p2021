import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';

part 'noticia_event.dart';
part 'noticia_state.dart';

class NoticiaBloc extends Bloc<NoticiaEvent, NoticiaState> {
  String query;
  NoticiaBloc() : super(NoticiaInitial());

  @override
  Stream<NoticiaState> mapEventToState(
    NoticiaEvent event,
  ) async* {
    if (event is NoticiaRequested) {
      yield NoticiaLoadInProgress();
      try {
        final List<New> noticias =
            await NewsRepository().getAvailableNoticias(event.query);
        yield NoticiaLoadSuccess(noticias: noticias);
      } catch (_) {
        yield NoticiaLoadFailure();
      }
    }
  }
}
