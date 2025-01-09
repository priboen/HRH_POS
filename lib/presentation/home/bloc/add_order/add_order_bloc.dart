import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/core/extensions/string_ext.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/data/datasources/products/remotes/order_remote_datasources_model.dart';
import 'package:hrh_pos/data/models/request/order_request_model.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';

part 'add_order_event.dart';
part 'add_order_state.dart';
part 'add_order_bloc.freezed.dart';

class AddOrderBloc extends Bloc<AddOrderEvent, AddOrderState> {
  final OrderRemoteDatasourcesModel orderRemoteDatasourcesModel;
  AddOrderBloc(this.orderRemoteDatasourcesModel) : super(const _Initial()) {
    on<_AddOrder>((event, emit) async {
      // emit(const _Loading());
      // try {
      //   final subTotal = event.items.fold<int>(
      //     0,
      //     (previousValue, item) =>
      //         previousValue +
      //         (item.product.price!.toIntegerFromText * item.quantity),
      //   );

      //   final total = subTotal + event.tax - event.discount;

      //   final totalItem = event.items.fold<int>(
      //     0,
      //     (previousValue, item) => previousValue + item.quantity,
      //   );

      //   final userData = await AuthLocalDatasources().getAuthData();

      //   // final orderRequest = OrderRequestModel(
      //   //   idUser: userData.data?.id,
      //   //   layanan: event.serviceOption,
      //   //   idPayment: event.paymentId,
      //   //   idPajak: event.tax,
      //   //   idDiskon: event.discount,
      //   //   subTotal: subTotal,
      //   //   totalItem: totalItem,
      //   //   total: total,
      //   //   paymentAmount: event.paymentAmount,
      //   //   returnPayment: event.paymentAmount - total,
      //   //   orderItems: event.items
      //   //       .map(
      //   //         (e) => OrderItem(
      //   //           idProduct: e.product.idProduct,
      //   //           quantity: e.quantity,
      //   //           total: e.product.price!.toIntegerFromText,
      //   //         ),
      //   //       )
      //   //       .toList(),
      //   // );

      //   final result =
      //       await orderRemoteDatasourcesModel.saveOrder(orderRequest);

      //   result.fold(
      //     (errorMessage) => emit(AddOrderState.error(errorMessage)),
      //     (response) => emit(AddOrderState.loaded()),
      //   );
      // } catch (e) {
      //   emit(AddOrderState.error('Terjadi kesalahan saat memproses pesanan'));
      // }
    });
  }
}
