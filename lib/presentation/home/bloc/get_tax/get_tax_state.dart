part of 'get_tax_bloc.dart';

@freezed
class GetTaxState with _$GetTaxState {
  const factory GetTaxState.initial() = _Initial;
  const factory GetTaxState.loading() = _Loading;
  const factory GetTaxState.loaded(List<Tax> taxes) = _Loaded;
  const factory GetTaxState.error(String message) = _Error;
}
