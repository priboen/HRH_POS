part of 'edit_discount_bloc.dart';

@freezed
class EditDiscountEvent with _$EditDiscountEvent {
  const factory EditDiscountEvent.started() = _Started;
  const factory EditDiscountEvent.editDiscount({
    required int idDiskon,
    required String namaDiskon,
    required String keteranganDiskon,
    required bool statusDiskon,
    required int totalDiskon,
    required String mulaiDiskon,
    required String selesaiDiskon,
  }) = _EditDiscount;
}