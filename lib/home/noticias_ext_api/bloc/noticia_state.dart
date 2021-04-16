part of 'noticia_bloc.dart';

abstract class NoticiaState extends Equatable {
  const NoticiaState();

  @override
  List<Object> get props => [];
}

class NoticiaInitial extends NoticiaState {}

class NoticiaLoadInProgress extends NoticiaState {}

class NoticiaLoadSuccess extends NoticiaState {
  final List<New> noticias;

  const NoticiaLoadSuccess({@required this.noticias})
      : assert(noticias != null);

  @override
  List<Object> get props => [noticias];
}

class NoticiaLoadFailure extends NoticiaState {}
