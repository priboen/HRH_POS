part of 'local_tax_bloc.dart';

@freezed
class LocalTaxState with _$LocalTaxState {
  const factory LocalTaxState.initial() = _Initial;
  const factory LocalTaxState.loading() = _Loading;
  const factory LocalTaxState.loaded({required List<Tax> taxes}) = _Loaded;
  const factory LocalTaxState.error({required String message}) = _Error;
}
