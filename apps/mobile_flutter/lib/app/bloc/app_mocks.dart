import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@test
@Injectable(as: AppBloc)
class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}
