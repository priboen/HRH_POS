import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/core/extensions/string_ext.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/data/datasources/local/database_local.dart';
import 'package:hrh_pos/presentation/home/models/order_model.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';
import 'package:intl/intl.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // final OrderRemoteDatasourcesModel datasource;
  OrderBloc() : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());
      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.toIntegerFromText * element.quantity));
      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);
      final diskonPersen = event.diskonPersen;
      final pajakPersen = event.pajakPersen;
      final totalDiskon = (subTotal * event.diskonPersen / 100).toInt();
      print('ini dari bloc order : $totalDiskon');
      final totalPajak = (subTotal * pajakPersen / 100).toInt();
      print('ini dari bloc order : $totalPajak');
      final total = subTotal - totalDiskon + totalPajak;
      final returnPayment = event.paymentAmount - total;
      final userData = await AuthLocalDatasources().getAuthData();
      final dataInput = OrderModel(
        diskonPersen: diskonPersen.toInt(),
        pajakPersen: pajakPersen.toInt(),
        idKasir: userData.data!.id,
        layanan: event.layananMethod,
        idPembayaran: event.paymentMethod,
        idPajak: event.tax,
        totalDiskon: totalDiskon,
        totalPajak: totalPajak,
        idDiskon: event.discount,
        subtotal: subTotal,
        totalItem: totalItem,
        total: total,
        totalPembayaran: event.paymentAmount,
        kembalian: returnPayment,
        namaKasir: userData.data!.name!,
        tglTransaksi: DateFormat.yMd().format(DateTime.now()),
        isSync: 0,
        orderItems: event.items,
      );
      print('ini dari order model : $totalDiskon');
      print('ini dari order model : $totalPajak');

      ///Server
      // final result = await datasource.saveOrder(dataInput);
      // result.fold((l) {
      //   print('Error : $l');
      //   emit(_Error(l));
      // }, (r) => emit(_Loaded(r)));

      ///Local
      await DatabaseLocal.instance.saveOrder(dataInput);
      print('Data Saved : $dataInput');
      emit(_Loaded(dataInput));
    });
  }
}
