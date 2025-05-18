part of 'local_payment_bloc.dart';

@freezed
class LocalPaymentState with _$LocalPaymentState {
  const factory LocalPaymentState.initial() = _Initial;
  const factory LocalPaymentState.loading() = _Loading;
  const factory LocalPaymentState.loaded({required List<Payment> payments}) = _Loaded;
  const factory LocalPaymentState.error({required String message}) = _Error;
}
