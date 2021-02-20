import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/lookup/bloc/bloc.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class LookupCountryView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => LookupCountryView());

  const LookupCountryView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<LookupBloc>(
        create: (BuildContext context) => LookupBloc(),
        child: LookupCountryPageView(),
      );
}

class LookupCountryPageView extends StatefulWidget {
  LookupCountryPageView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookupCountryPageViewState();
}

class _LookupCountryPageViewState extends State<LookupCountryPageView> {
  List<Country> _countryList;
  Country _country;

  @override
  void initState() {
    super.initState();
    _prepareDefaultCountries();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<LookupBloc, LookupState>(
        builder: (
          BuildContext context,
          LookupState state,
        ) =>
            AppUiOverlayStyle(
          themeMode: context.watch<AppBloc>().state.themeMode,
          colorTheme: (context.watch<AppBloc>().state.colorTheme ?? false),
          systemNavigationBarIconBrightness:
              context.watch<AppBloc>().state.colorTheme
                  ? Brightness.dark
                  : null,
          child: Theme(
            data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
                ? appDarkThemeData
                : appLightThemeData,
            child: Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).country),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _handleBack(state),
                ),
              ),
              body: SafeArea(
                child: _buildContent(),
              ),
            ),
          ),
        ),
      );

  Widget _buildContent() => SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: _buildListOfCountries(),
      );

  void _handleBack(
    LookupState state,
  ) {
    Navigator.of(context).pop();
  }

  Future<void> _prepareDefaultCountries() async {
    List<Country> countries;

    try {
      countries = await IsoCountries.iso_countries;
    } on PlatformException {
      countries = null;
    }

    if (!mounted) {
      return;
    }

    setState(() => _countryList = countries);
  }

  Widget _buildListOfCountries() => ListView.builder(
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final Country country = _countryList[index];

          return ListTile(
            title: Text(country.name),
            subtitle: Text(country.countryCode),
            onTap: () => _getCountryForCodeWithIdentifier(
              country.countryCode,
              'de-de',
            ),
          );
        },
        itemCount: (_countryList != null) ? _countryList.length : 0,
      );

  Future<void> _getCountryForCodeWithIdentifier(
    String code,
    String localeIdentifier,
  ) async {
    try {
      _country = await IsoCountries.iso_country_for_code_for_locale(
        code,
        locale_identifier: localeIdentifier,
      );
    } on PlatformException {
      _country = null;
    }

    if (!mounted) {
      return;
    }
  }
}
