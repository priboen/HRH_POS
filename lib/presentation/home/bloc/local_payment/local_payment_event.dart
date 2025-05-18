part of 'local_payment_bloc.dart';

@freezed
class LocalPaymentEvent with _$LocalPaymentEvent {
  const factory LocalPaymentEvent.started() = _Started;
  const factory LocalPaymentEvent.getPayments() = _GetPayments;
}