part of 'get_discount_bloc.dart';

@freezed
class GetDiscountEvent with _$GetDiscountEvent {
  const factory GetDiscountEvent.started() = _Started;
  const factory GetDiscountEvent.getDiscount() = _GetDiscount;
}