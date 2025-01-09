part of 'checkout_bloc.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial() = _Initial;
  const factory CheckoutState.loading() = _Loading;
  const factory CheckoutState.loaded(
      // Map<int, int> quantities, List<Product> products
      List<ProductQuantity> items,
      Discount? discount,
      Tax? tax,
      ) = _Loaded;
  const factory CheckoutState.error(String message) = _Error;
}
