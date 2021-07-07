import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/enums/iap_store_status.dart';
import 'package:flutter_weather/premium/bloc/bloc.dart';
import 'package:flutter_weather/premium/widgets/widgets.dart';

class PremiumPurchase extends StatelessWidget {
  const PremiumPurchase({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<PremiumBloc, PremiumState>(
        builder: (
          BuildContext context,
          PremiumState state,
        ) =>
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContent(state),
          ],
        ),
      );

  Widget _buildContent(
    PremiumState state,
  ) {
    switch (state.status) {
      case IAPStoreStatus.available:
        return PremiumPurchaseList();

      case IAPStoreStatus.notAvailable:
        return const Center(child: Text('Store not available'));

      case IAPStoreStatus.loading:
      default:
        return const Center(child: Text('Store is loading'));
    }
  }
}
