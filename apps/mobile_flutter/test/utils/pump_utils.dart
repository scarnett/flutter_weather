import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/bloc/forecast_form_bloc.dart';
import 'package:flutter_weather/lookup/lookup.dart';
import 'package:mocktail/mocktail.dart';

import 'test_utils.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockLookupBloc extends MockBloc<LookupEvent, LookupState>
    implements LookupBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class FakeLookupEvent extends Fake implements LookupEvent {}

class FakeLookupState extends Fake implements LookupState {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    ForecastFormBloc? forecastFormBloc,
    AppBloc? appBloc,
    LookupBloc? lookupBloc,
  }) async {
    registerFallbackValue(FakeAppEvent());
    registerFallbackValue(FakeAppState());
    registerFallbackValue(FakeLookupEvent());
    registerFallbackValue(FakeLookupState());

    return await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: forecastFormBloc ?? ForecastFormBloc()),
          BlocProvider.value(value: appBloc ?? MockAppBloc()),
          BlocProvider.value(value: lookupBloc ?? MockLookupBloc()),
        ],
        child: buildFrame(
          buildContent: (BuildContext context) => widget,
        ),
      ),
    );
  }
}
