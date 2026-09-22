import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserve implements BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    debugPrint('change=$change');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    debugPrint('close=$bloc');
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    debugPrint('create=$bloc');
  }

  @override
  void onDone(Bloc<dynamic, dynamic> bloc, Object? event,
      [Object? error, StackTrace? stackTrace]) {
    debugPrint('done=$bloc, event=$event');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('error=$bloc, $error');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    debugPrint('event=$bloc, $event');
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    debugPrint('transition=$transition');
  }
}
