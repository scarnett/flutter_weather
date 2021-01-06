import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ForecastFormBloc extends FormBloc<String, String> {
  final TextFieldBloc postalCode = TextFieldBloc(
    name: 'postalCode',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final SelectFieldBloc country = SelectFieldBloc(
    name: 'country',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  ForecastFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        postalCode,
        country,
      ],
    );
  }

  @override
  void onSubmitting() async => emitSuccess(canSubmitAgain: true);

  @override
  Future<void> close() async {
    super.close();
    postalCode.close();
    country.close();
  }
}
