import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_keys.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ForecastCountryPicker extends StatefulWidget {
  final String? selectedCountryCode;

  final Function(
    Country country,
  )? onTap;

  ForecastCountryPicker({
    Key? key,
    this.selectedCountryCode,
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastCountryPickerState();
}

class _ForecastCountryPickerState extends State<ForecastCountryPicker> {
  List<Country>? _countryList;
  List<Country>? _filteredCountryList;

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
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Theme(
          data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
              ? appDarkThemeData
              : appLightThemeData,
          child: _buildBody(),
        ),
      );

  Future<void> _prepareCountries() async {
    List<Country>? countries;

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

  Widget _buildBody() => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: StickyHeader(
          header: Column(
            children: [
              AppUiSafeArea(
                bottom: false,
                child: _buildCountryFilter(),
              ),
            ],
          ),
          content: AppUiSafeArea(
            top: false,
            child: _buildListOfCountries(),
          ),
        ),
      );

  Widget _buildCountryFilter() => Container(
        color: Theme.of(context).appBarTheme.color,
        child: TextField(
          key: Key(AppKeys.locationCountryFilterKey),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.filterCountries,
            prefixIcon: Icon(
              Icons.filter_alt,
              color: AppTheme.primaryColor,
            ),
          ),
          onChanged: (String criteria) {
            setState(() {
              _filteredCountryList = _countryList!
                  .where((Country country) => (country.name
                          .toLowerCase()
                          .contains(criteria.toLowerCase()) ||
                      country.countryCode
                          .toLowerCase()
                          .contains(criteria.toLowerCase())))
                  .toList();
            });
          },
        ),
      );

  Widget _buildListOfCountries() => Container(
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            final Country country = _filteredCountryList![index];

            return ListTile(
              key: Key(country.countryCode),
              title: Text(
                country.name,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: _getCountryColor(country),
                    ),
              ),
              subtitle: Text(
                country.countryCode,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              onTap: () => _tapCountry(country),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          padding: const EdgeInsets.all(0.0),
          itemCount:
              (_filteredCountryList != null) ? _filteredCountryList!.length : 0,
        ),
      );

  void _tapCountry(
    Country country,
  ) async {
    closeKeyboard(context);
    widget.onTap!(country);
  }

  Color? _getCountryColor(
    Country country,
  ) {
    if (widget.selectedCountryCode == country.countryCode) {
      return AppTheme.primaryColor;
    }

    return null;
  }
}
