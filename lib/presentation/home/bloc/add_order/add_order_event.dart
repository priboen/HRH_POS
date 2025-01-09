part of 'add_order_bloc.dart';

@freezed
class AddOrderEvent with _$AddOrderEvent {
  const factory AddOrderEvent.started() = _Started;
  const factory AddOrderEvent.addOrder(
    List<ProductQuantity> items,
    int discount,
    int tax,
    int paymentAmount,
    String serviceOption,
    int paymentId,
  ) = _AddOrder;
}
