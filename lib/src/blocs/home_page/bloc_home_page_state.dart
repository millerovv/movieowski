import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {
  HomePageState([List props = const []]);
}

class HomePageNotLoaded extends HomePageState {}

class HomePageIsLoading extends HomePageState {}

class HomePageIsLoaded extends HomePageState {}

class HomePageLoadingFailed extends HomePageState {
  final String errorMessage;

  HomePageLoadingFailed(this.errorMessage) : super([errorMessage]);

}