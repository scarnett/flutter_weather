import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class LookupCountryView extends StatefulWidget {
  final Function onTap;

  LookupCountryView({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookupCountryViewState();
}

class _LookupCountryViewState extends State<LookupCountryView> {
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
      AppUiOverlayStyle(
        themeMode: context.watch<AppBloc>().state.themeMode,
        colorTheme: (context.watch<AppBloc>().state.colorTheme ?? false),
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Theme(
          data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
              ? appDarkThemeData
              : appLightThemeData,
          child: Scaffold(
            extendBody: true,
            body: _buildListOfCountries(),
          ),
        ),
      );

  Future<void> _prepareDefaultCountries() async {
    List<Country> countries;

    try {
      countries = await IsoCountries.iso_countries_for_locale('en-en'); // TODO
    } on PlatformException {
      countries = null;
    }

    if (!mounted) {
      return;
    }

    setState(() => _countryList = countries);
  }

  Widget _buildListOfCountries() => ListView.separated(
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final Country country = _countryList[index];

          return ListTile(
            title: Text(
              country.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            subtitle: Text(
              country.countryCode,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            onTap: () => _tapCountry(country),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: (_countryList != null) ? _countryList.length : 0,
      );

  Future<void> _tapCountry(
    Country country,
  ) async {
    await _getCountryForCodeWithIdentifier(
      country.countryCode,
      'en-en', // TODO
    );

    widget.onTap(_country);
  }

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
