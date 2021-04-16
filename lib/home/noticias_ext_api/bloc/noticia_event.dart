part of 'noticia_bloc.dart';

abstract class NoticiaEvent extends Equatable {
  const NoticiaEvent();

  @override
  List<Object> get props => [];
}

class NoticiaRequested extends NoticiaEvent {
  final String query;

  const NoticiaRequested({@required this.query}) : assert(query != null);

  @override
  List<Object> get props => [query];
}
