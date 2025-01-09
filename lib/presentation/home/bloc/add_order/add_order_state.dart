part of 'add_order_bloc.dart';

@freezed
class AddOrderState with _$AddOrderState {
  const factory AddOrderState.initial() = _Initial;
  const factory AddOrderState.loading() = _Loading;
  const factory AddOrderState.loaded(OrderRequestModel orderRequestModel) = _Loaded;
  
  const factory AddOrderState.error(String message) = _Error;
}
