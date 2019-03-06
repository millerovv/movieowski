import 'package:rxdart/rxdart.dart';

/// Bloc responsible for handling user preferences
//TODO: implement
class PreferencesBloc {
  /// Streams related to this BLoC
  BehaviorSubject<String> _controller = BehaviorSubject<String>();

  Function(String) get push => _controller.sink.add;

  Stream<String> get stream => _controller;

  /// Singleton factory
  static final PreferencesBloc _bloc = new PreferencesBloc._internal();

  factory PreferencesBloc() {
    return _bloc;
  }

  PreferencesBloc._internal();

  /// Resource disposal
  void dispose() {
    _controller?.close();
  }
}

PreferencesBloc globalBloc = PreferencesBloc();
