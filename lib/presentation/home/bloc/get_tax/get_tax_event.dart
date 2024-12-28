part of 'get_tax_bloc.dart';

@freezed
class GetTaxEvent with _$GetTaxEvent {
  const factory GetTaxEvent.started() = _Started;
  const factory GetTaxEvent.getTax() = _GetTax;
}