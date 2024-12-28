part of 'edit_discount_bloc.dart';

@freezed
class EditDiscountState with _$EditDiscountState {
  const factory EditDiscountState.initial() = _Initial;
  const factory EditDiscountState.loading() = _Loading;
  const factory EditDiscountState.success() = _Success;
  const factory EditDiscountState.error(String message) = _Error;
}
