part of 'get_discount_bloc.dart';

@freezed
class GetDiscountState with _$GetDiscountState {
  const factory GetDiscountState.initial() = _Initial;
  const factory GetDiscountState.loading() = _Loading;
  const factory GetDiscountState.loaded(List<Discount> discounts) = _Loaded;
  const factory GetDiscountState.error(String message) = _Error;
}
