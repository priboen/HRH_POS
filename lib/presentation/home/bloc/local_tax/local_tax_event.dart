part of 'local_tax_bloc.dart';

@freezed
class LocalTaxEvent with _$LocalTaxEvent {
  const factory LocalTaxEvent.started() = _Started;
  const factory LocalTaxEvent.getTaxes() = _GetTaxes;
}