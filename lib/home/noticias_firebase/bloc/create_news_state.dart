part of 'create_news_bloc.dart';

abstract class CreateNewsState extends Equatable {
  const CreateNewsState();

  @override
  List<Object> get props => [];
}

class CreateNewsInitial extends CreateNewsState {}

class LoadingState extends CreateNewsState {}

class PickedImageState extends CreateNewsState {
  final File image;

  PickedImageState({@required this.image});
  @override
  List<Object> get props => [image];
}

class SavedNewState extends CreateNewsState {
  List<Object> get props => [];
}

class ErrorMessageState extends CreateNewsState {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
