import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/enums/iap_store_status.dart';
import 'package:flutter_weather/enums/message_type.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/premium/premium.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sentry/sentry.dart';

part 'premium_events.dart';
part 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  StreamSubscription<List<Product>>? _productSubscription;

  final Stream<List<PurchaseDetails>> iapPurchaseUpdated =
      IAPConnection.instance.purchaseStream;

  StreamSubscription<List<PurchaseDetails>>? _iapSubscription;

  PremiumBloc() : super(PremiumState.initial());

  PremiumState get initialState => PremiumState.initial();

  @override
  Stream<PremiumState> mapEventToState(
    PremiumEvent event,
  ) async* {
    if (event is FetchProducts) {
      yield* _mapFetchProductsToState(event);
    } else if (event is ProductsUpdated) {
      yield* _mapProductsUpdatedToState(event);
    } else if (event is StreamIAPResult) {
      yield* _mapStreamIAPResultToState(event);
    } else if (event is StreamIAPResult) {
      yield* _mapStreamIAPResultToState(event);
    } else if (event is OnIAPPurchaseUpdate) {
      yield _mapOnIAPPurchaseUpdateToState(event);
    } else if (event is OnIAPPurchaseDone) {
      yield _mapOnIAPPurchaseDoneToState(event);
    } else if (event is OnIAPPurchaseError) {
      yield* _mapOnIAPPurchaseErrorToState(event);
    }
  }

  @override
  Future<void> close() {
    _iapSubscription?.cancel();
    return super.close();
  }

  Stream<PremiumState> _mapFetchProductsToState(
    FetchProducts event,
  ) async* {
    _productSubscription?.cancel();
    _productSubscription = PremiumService().fetchProducts(event.source).listen(
          (List<Product> products) => add(ProductsUpdated(products)),
        );
  }

  Stream<PremiumState> _mapProductsUpdatedToState(
    ProductsUpdated event,
  ) async* {
    yield state.copyWith(
      products: event.products,
    );
  }

  Stream<PremiumState> _mapStreamIAPResultToState(
    StreamIAPResult event,
  ) async* {
    _iapSubscription?.cancel();
    _iapSubscription = iapPurchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetails) =>
          add(OnIAPPurchaseUpdate(purchaseDetails)),
      onDone: () => add(OnIAPPurchaseDone()),
      onError: (dynamic error) => add(OnIAPPurchaseError(event.context, error)),
    );

    yield state;
  }

  PremiumState _mapOnIAPPurchaseUpdateToState(
    OnIAPPurchaseUpdate event,
  ) {
    event.purchaseDetailList!.forEach((PurchaseDetails purchaseDetails) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // TODO!
      }

      if (purchaseDetails.pendingCompletePurchase) {
        IAPConnection.instance.completePurchase(purchaseDetails);
      }
    });

    return state;
  }

  PremiumState _mapOnIAPPurchaseDoneToState(
    OnIAPPurchaseDone event,
  ) {
    _iapSubscription?.cancel();
    return state;
  }

  Stream<PremiumState> _mapOnIAPPurchaseErrorToState(
    OnIAPPurchaseError event,
  ) async* {
    await Sentry.captureException(event.error);

    showSnackbar(
      event.context,
      AppLocalizations.of(event.context)!.refreshFailure,
      messageType: MessageType.danger,
    );

    yield state;
  }
}
