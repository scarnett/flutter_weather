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
    Cubit cubit,
    Change change,
  ) {
    // developer.log(change.toString(), name: 'AppBlocObserver');
    super.onChange(cubit, change);
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
    Cubit cubit,
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

    super.onError(cubit, error, stackTrace);
  }
}
