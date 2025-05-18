part of 'sync_all_data_bloc.dart';

@freezed
class SyncAllDataState with _$SyncAllDataState {
  const factory SyncAllDataState.initial() = _Initial;
  const factory SyncAllDataState.loading() = _Loading;
  const factory SyncAllDataState.success(
    ProductResponseModel product,
    ListDiscountResponseModel discount,
    ListTaxResponseModel tax,
    PaymentResponseModel payment,
  ) = _Success;
  const factory SyncAllDataState.error(String message) = _Error;
}
