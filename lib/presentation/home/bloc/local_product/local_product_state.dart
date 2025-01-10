part of 'local_product_bloc.dart';

@freezed
class LocalProductState with _$LocalProductState {
  const factory LocalProductState.initial() = _Initial;
  const factory LocalProductState.loading() = _Loading;
  const factory LocalProductState.loaded({required List<Product> products}) = _Loaded;
  const factory LocalProductState.error({required String message}) = _Error;
}
