import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(
    Bloc bloc,
    Object? event,
  ) {
    print(event.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onChange(
    BlocBase base,
    Change change,
  ) {
    print(change.toString());
    super.onChange(base, change);
  }

  @override
  void onTransition(
    Bloc bloc,
    Transition transition,
  ) {
    print(transition.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(
    BlocBase base,
    Object error,
    StackTrace stackTrace,
  ) {
    print(error);
    print(stackTrace);
    super.onError(base, error, stackTrace);
  }
}
