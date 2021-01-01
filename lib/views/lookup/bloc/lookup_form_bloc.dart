import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class LookupFormBloc extends FormBloc<String, String> {
  final TextFieldBloc zipCode = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final SelectFieldBloc country = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  LookupFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        zipCode,
        country,
      ],
    );
  }

  // TODO!
  @override
  void onSubmitting() async {
    print(zipCode.value);
    print(country.value);

    await Future<void>.delayed(Duration(seconds: 1));

    emitSuccess(canSubmitAgain: true);

    // TODO! log this failure; sentry?
    // emitFailure();
  }

  @override
  Future<void> close() async {
    super.close();
    zipCode.close();
    country.close();
  }
}
