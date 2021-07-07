part of 'premium_bloc.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends PremiumEvent {
  final ProductSource source;

  const FetchProducts(
    this.source,
  );

  @override
  List<Object> get props => [source];

  @override
  String toString() => 'ProductSource{source: $source}';
}

class ProductsUpdated extends PremiumEvent {
  final List<Product> products;

  const ProductsUpdated(
    this.products,
  );

  @override
  List<Object> get props => [products];

  @override
  String toString() => 'ProductsUpdated{products: $products}';
}

class StreamIAPResult extends PremiumEvent {
  final BuildContext context;

  const StreamIAPResult(
    this.context,
  );

  @override
  List<Object?> get props => [context];

  @override
  String toString() => 'StreamIAPResult{}';
}

class OnIAPPurchaseUpdate extends PremiumEvent {
  final List<PurchaseDetails>? purchaseDetailList;

  const OnIAPPurchaseUpdate(
    this.purchaseDetailList,
  );

  @override
  List<Object?> get props => [purchaseDetailList];

  @override
  String toString() =>
      'OnIAPPurchaseUpdate{purchaseDetailList: $purchaseDetailList}';
}

class OnIAPPurchaseDone extends PremiumEvent {
  @override
  List<Object?> get props => [];
}

class OnIAPPurchaseError extends PremiumEvent {
  final BuildContext context;
  final dynamic error;

  const OnIAPPurchaseError(
    this.context,
    this.error,
  );

  @override
  List<Object?> get props => [context, error];

  @override
  String toString() => 'OnIAPPurchaseError{error: $error}';
}
