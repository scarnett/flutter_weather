import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/premium/bloc/bloc.dart';

class PremiumPurchaseList extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    PremiumBloc premiumBloc = context.watch<PremiumBloc>();

    return Column(
      children: (premiumBloc.state.products == null)
          ? []
          : premiumBloc.state.products!
              .map((Product product) => _buildProduct(product))
              .toList(),
    );
  }

  Widget _buildProduct(
    Product product,
  ) {
    String title = product.details?.title ?? '';

    // if (product.status == ProductStatus.purchased) {
    //   title += ' (purchased)'; // TODO!
    // }

    return InkWell(
        onTap: () => print('PURCHASED!'), // TODO! purchases.buy(product)
        child: ListTile(
          title: Text(title),
          subtitle: Text(product.description),
          // trailing: Text(_buildTrailingText(product)),
        ));
  }

  // String _buildTrailingText(
  //   Product product,
  // ) {
  //   switch (product.status) {
  //     case ProductStatus.purchasable:
  //       return product.price;

  //     case ProductStatus.purchased:
  //       return 'purchased'; // TODO!

  //     case ProductStatus.pending:
  //       return 'buying...'; // TODO!
  //   }
  // }
}
