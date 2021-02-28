import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class ForecastCountryPicker extends StatefulWidget {
  final String selectedCountryCode;

  final Function(
    Country country,
  ) onTap;

  ForecastCountryPicker({
    Key key,
    this.selectedCountryCode,
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastCountryPickerState();
}

class _ForecastCountryPickerState extends State<ForecastCountryPicker> {
  List<Country> _countryList;
  List<Country> _filteredCountryList;

  @override
  void initState() {
    super.initState();
    _prepareCountries();
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
            body: _buildBody(),
          ),
        ),
      );

  Future<void> _prepareCountries() async {
    List<Country> countries;

    try {
      countries = await IsoCountries.iso_countries_for_locale('en-en'); // TODO
    } on PlatformException {
      countries = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _countryList = countries;
      _filteredCountryList = countries;
    });
  }

  Widget _buildBody() => Column(
        children: <Widget>[
          _buildCountryFilter(),
          Expanded(child: _buildListOfCountries()),
        ],
      );

  Widget _buildCountryFilter() => TextField(
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).filterCountries,
          prefixIcon: Icon(
            Icons.filter_alt,
            color: AppTheme.primaryColor,
          ),
        ),
        onChanged: (String criteria) {
          setState(() {
            _filteredCountryList = _countryList
                .where((Country country) => (country.name
                        .toLowerCase()
                        .contains(criteria.toLowerCase()) ||
                    country.countryCode
                        .toLowerCase()
                        .contains(criteria.toLowerCase())))
                .toList();
          });
        },
      );

  Widget _buildListOfCountries() => ListView.separated(
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final Country country = _filteredCountryList[index];

          return ListTile(
            title: Text(
              country.name,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: _getCountryColor(country),
                  ),
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
        itemCount:
            (_filteredCountryList != null) ? _filteredCountryList.length : 0,
      );

  void _tapCountry(
    Country country,
  ) async {
    closeKeyboard(context);
    widget.onTap(country);
  }

  Color _getCountryColor(
    Country country,
  ) {
    if (widget.selectedCountryCode == country.countryCode) {
      return AppTheme.primaryColor;
    }

    return null;
  }
}