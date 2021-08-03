import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/premium/widgets/widgets.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry/sentry.dart';

class PremiumSubscriptionButton extends StatefulWidget {
  PremiumSubscriptionButton({
    Key? key,
  }) : super(key: key);

  @override
  _PremiumSubscriptionButtonState createState() =>
      _PremiumSubscriptionButtonState();
}

class _PremiumSubscriptionButtonState extends State<PremiumSubscriptionButton> {
  late Offerings _offerings;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      TextButton(
        onPressed: () async {
          if ((_offerings.current == null) ||
              _offerings.current!.availablePackages.isEmpty) {
            context.read<AppBloc>().add(SetShowPremiumInfo(false));

            showSnackbar(
              context,
              AppLocalizations.of(context)!.premiumNotAvailable,
            );
          } else {
            try {
              await Purchases.purchasePackage(_offerings.current!.annual!);

              // Update premium status, close premium overlay,
              // and open the success alert
              context.read<AppBloc>()
                ..add(SetIsPremium(true))
                ..add(SetShowPremiumInfo(false))
                ..add(SetShowPremiumSuccess(true));
            } on PlatformException catch (exception) {
              PurchasesErrorCode errorCode =
                  PurchasesErrorHelper.getErrorCode(exception);

              if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
                print('User cancelled');
              } else if (errorCode ==
                  PurchasesErrorCode.purchaseNotAllowedError) {
                print('User not allowed to purchase');
              }
            }
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PremiumStar(),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                AppLocalizations.of(context)!.premiumSubscribe,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _initialize() async {
    try {
      Offerings offerings = await IAPService.instance.offerings;
      setState(() => _offerings = offerings);
    } on PlatformException catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}
