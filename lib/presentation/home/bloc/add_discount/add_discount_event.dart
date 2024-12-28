part of 'add_discount_bloc.dart';

@freezed
class AddDiscountEvent with _$AddDiscountEvent {
  const factory AddDiscountEvent.started() = _Started;
  const factory AddDiscountEvent.addDiscount({
    required String namaDiskon,
    required String keteranganDiskon,
    required bool statusDiskon,
    required int totalDiskon,
    required String mulaiDiskon,
    required String selesaiDiskon,
  }) = _AddDiscount;
}