part of 'get_payment_bloc.dart';

@freezed
class GetPaymentEvent with _$GetPaymentEvent {
  const factory GetPaymentEvent.started() = _Started;
  const factory GetPaymentEvent.getPayments() = _GetPayments;
}