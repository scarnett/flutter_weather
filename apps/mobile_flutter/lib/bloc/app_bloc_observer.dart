// import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(
    Bloc bloc,
    Object event,
  ) {
    // developer.log(event.toString(), name: 'AppBlocObserver');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(
    BlocBase base,
    Change change,
  ) {
    // developer.log(change.toString(), name: 'AppBlocObserver');
    super.onChange(base, change);
  }

  @override
  void onTransition(
    Bloc bloc,
    Transition transition,
  ) {
    // developer.log(transition.toString(), name: 'AppBlocObserver');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(
    BlocBase base,
    Object error,
    StackTrace stackTrace,
  ) {
    /*
    developer.log(
      error.toString(),
      name: 'AppBlocObserver',
      error: error,
      stackTrace: stackTrace,
    );
    */

    super.onError(base, error, stackTrace);
  }
}
