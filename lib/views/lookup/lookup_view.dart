import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/lookup/bloc/bloc.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:flutter_weather/widgets/app_select_dialog.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class LookupView extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => LookupView());

  const LookupView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<LookupFormBloc>(
        create: (BuildContext context) => LookupFormBloc(),
        child: LookupPageView(),
      );
}

class LookupPageView extends StatefulWidget {
  LookupPageView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookupPageViewState();
}

class _LookupPageViewState extends State<LookupPageView> {
  bool submitting = false;

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        bloc: context.watch<AppBloc>(),
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).addLocation),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _buildContent(),
        ),
      );

  Widget _buildContent() => SafeArea(
        child: FormBlocListener<LookupFormBloc, String, String>(
          onSubmitting: _onSubmitting,
          onSuccess: _onSuccess,
          onFailure: _onFailure,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFieldBlocBuilder(
                  textFieldBloc: context.watch<LookupFormBloc>().zipCode,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).postalCode,
                    prefixIcon: Icon(
                      Icons.place,
                      color: Colors.deepPurple[400],
                    ),
                  ),
                ),
                AppSelectDialogFieldBlocBuilder(
                  selectFieldBloc: context.watch<LookupFormBloc>().country,
                ),
                AppFormButton(
                  text: submitting ? null : AppLocalizations.of(context).lookup,
                  icon: submitting
                      ? SizedBox(
                          height: 25.0,
                          width: 25.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.search),
                  onTap: submitting ? null : _tapLookup,
                ),
              ],
            ),
          ),
        ),
      );

  void _tapLookup() => context.read<LookupFormBloc>().submit();

  void _onSubmitting(
    BuildContext context,
    FormBlocSubmitting<String, String> state,
  ) =>
      setState(() {
        submitting = true;
      });

  void _onSuccess(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  ) {
    setState(() {
      submitting = false;
    });

    FocusScope.of(context).unfocus();
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).lookupSuccess)));
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    setState(() {
      submitting = false;
    });

    FocusScope.of(context).unfocus();
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).lookupFailure)));
  }
}
