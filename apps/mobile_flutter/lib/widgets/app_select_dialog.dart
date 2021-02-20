// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// import 'package:flutter_weather/localization.dart';
// import 'package:flutter_weather/theme.dart';
// import 'package:iso_countries/iso_countries.dart';
// import 'package:select_dialog/select_dialog.dart';

// class AppSelectDialogFieldBlocBuilder<Value> extends StatelessWidget {
//   final SelectFieldBloc<Value, Object> selectFieldBloc;

//   const AppSelectDialogFieldBlocBuilder({
//     Key key,
//     @required this.selectFieldBloc,
//   }) : super(key: key);

//   @override
//   Widget build(
//     BuildContext context,
//   ) =>
//       BlocProvider<SelectFieldBloc>(
//         create: (BuildContext context) => SelectFieldBloc(),
//         child: BlocBuilder<SelectFieldBloc, SelectFieldBlocState>(
//           cubit: selectFieldBloc,
//           builder: (
//             BuildContext context,
//             SelectFieldBlocState<dynamic, dynamic> state,
//           ) =>
//               GestureDetector(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 10.0),
//               child: InputDecorator(
//                 isEmpty: (state?.value == null),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context).country,
//                   errorText: state.canShowError
//                       ? FieldBlocBuilder.defaultErrorBuilder(
//                           context,
//                           state.error,
//                           selectFieldBloc,
//                         )
//                       : null,
//                   prefixIcon: Icon(
//                     Icons.language,
//                     color: AppTheme.primaryColor,
//                   ),
//                 ),
//                 child: Text(state?.value ?? ''),
//               ),
//             ),
//             onTap: () async {
//               final List<String> countries = (await IsoCountries.iso_countries)
//                   .map((e) => e.name)
//                   .toList();

//               SelectDialog.showModal<Value>(
//                 context,
//                 label: AppLocalizations.of(context).selectCountry,
//                 selectedValue: state.value,
//                 items: countries.map((String name) => name as dynamic).toList(),
//                 itemBuilder: (
//                   BuildContext context,
//                   Value country,
//                   bool isSelected,
//                 ) =>
//                     Container(
//                   child: ListTile(
//                     selected: isSelected,
//                     title: Text(country as String),
//                   ),
//                 ),
//                 onChange: selectFieldBloc.updateValue,
//                 searchBoxDecoration: InputDecoration(
//                   hintText: AppLocalizations.of(context).filterCountries,
//                 ),
//               );
//             },
//           ),
//         ),
//       );
// }
