import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class LookupFormBloc extends FormBloc<String, String> {
  final TextFieldBloc zipCode = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final TextFieldBloc country = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final BooleanFieldBloc showSuccessResponse = BooleanFieldBloc();

  LookupFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        zipCode,
        country,
        showSuccessResponse,
      ],
    );
  }

  // TODO!
  @override
  void onSubmitting() async {
    print(zipCode.value);
    print(country.value);
    print(showSuccessResponse.value);

    await Future<void>.delayed(Duration(seconds: 1));

    if (showSuccessResponse.value) {
      emitSuccess();
    } else {
      emitFailure(failureResponse: 'This is an awesome error!');
    }
  }

  @override
  Future<void> close() async {
    super.close();
    zipCode.close();
    country.close();
    showSuccessResponse.close();
  }
}
