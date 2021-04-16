part of 'create_news_bloc.dart';

abstract class CreateNewsEvent extends Equatable {
  const CreateNewsEvent();

  @override
  List<Object> get props => [];
}

class SaveNewElementEvent extends CreateNewsEvent {
  final New noticia;

  SaveNewElementEvent({@required this.noticia});
  @override
  List<Object> get props => [noticia];
}

class PickImageEvent extends CreateNewsEvent {
  @override
  List<Object> get props => [];
}
