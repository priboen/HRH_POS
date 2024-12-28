part of 'edit_tax_bloc.dart';

@freezed
class EditTaxEvent with _$EditTaxEvent {
  const factory EditTaxEvent.started() = _Started;
  const factory EditTaxEvent.editTax({
    required int idPajak,
    required String namaPajak,
    required int persenPajak,
  }) = _EditTax;
}