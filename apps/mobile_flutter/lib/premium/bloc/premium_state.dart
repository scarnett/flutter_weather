part of 'premium_bloc.dart';

@immutable
class PremiumState extends Equatable {
  final IAPStoreStatus status;
  final List<Product>? products;

  PremiumState({
    this.status: IAPStoreStatus.loading,
    this.products,
  });

  const PremiumState._({
    this.status: IAPStoreStatus.loading,
    this.products,
  });

  const PremiumState.initial() : this._();

  PremiumState copyWith({
    IAPStoreStatus? status,
    List<Product>? products,
  }) =>
      PremiumState._(
        status: status ?? this.status,
        products: products ?? this.products,
      );

  @override
  List<Object?> get props => [
        status,
        products,
      ];

  @override
  String toString() => 'PremiumState{status: $status, products: $products}';
}
