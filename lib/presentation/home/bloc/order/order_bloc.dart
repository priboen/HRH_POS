import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/core/extensions/string_ext.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/data/datasources/products/remotes/order_remote_datasources_model.dart';
import 'package:hrh_pos/data/models/request/order_request_model.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteDatasourcesModel datasource;
  OrderBloc(this.datasource) : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());
      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.toIntegerFromText * element.quantity));
      final total = subTotal + event.tax - event.discount;
      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);
      final returnPayment = event.paymentAmount - total;
      final userData = await AuthLocalDatasources().getAuthData();
      final dataInput = OrderRequestModel(
          idUser: userData.data!.id,
          layanan: event.layananMethod,
          idPayment: event.paymentMethod,
          idPajak: event.tax,
          idDiskon: event.discount,
          subTotal: subTotal,
          totalItem: totalItem,
          total: total,
          paymentAmount: event.paymentAmount,
          returnPayment: returnPayment,
          transaksiTime: DateTime.now(),
          orderItems: event.items
              .map(
                (e) => OrderItem(
                  idProduct: e.product.idProduct,
                  quantity: e.quantity,
                  total: e.quantity * e.product.price!.toIntegerFromText,
                ),
              )
              .toList());
      final result = await datasource.saveOrder(dataInput);
      result.fold((l) {
        print('Error : $l');
        emit(_Error(l));
      }, (r) => emit(_Loaded(r)));
    });
  }
}
