part of 'get_payment_bloc.dart';

@freezed
class GetPaymentState with _$GetPaymentState {
  const factory GetPaymentState.initial() = _Initial;
  const factory GetPaymentState.loading() = _Loading;
  const factory GetPaymentState.loaded(List<Payment> payments) = _Loaded;
  const factory GetPaymentState.error(String message) = _Error;
}
