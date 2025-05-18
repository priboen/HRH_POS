part of 'item_sales_bloc.dart';

@freezed
class ItemSalesState with _$ItemSalesState {
  const factory ItemSalesState.initial() = _Initial;
  const factory ItemSalesState.loading() = _Loading;
  const factory ItemSalesState.loaded(List<ProductQuantity> soldProducts) =
      _Loaded;
  const factory ItemSalesState.error(String message) = _Error;
}
