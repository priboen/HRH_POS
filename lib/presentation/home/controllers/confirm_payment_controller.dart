import 'package:flutter/material.dart';
import 'package:hrh_pos/core/extensions/int_ext.dart';

class ConfirmPaymentController {
  final TextEditingController totalPriceController;
  int subtotal = 0;

  ConfirmPaymentController(this.totalPriceController);

  void updateTotal(int amount) {
    int currentTotal = int.tryParse(
          totalPriceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    int newTotal = currentTotal + amount;

    totalPriceController.text = newTotal.currencyFormatRp;
  }

  void setExactTotal() {
    totalPriceController.text = subtotal.currencyFormatRp;
  }

  // Future<void> submitOrder({
  //   required String selectedOption,
  //   required int? selectedPaymentId,
  //   required int? selectedDiscountId,
  //   required int? selectedTaxId,
  //   required List<OrderItem> orderItems,
  //   required BuildContext context,
  // }) async {
  //   final authData = await AuthLocalDatasources().getAuthData();
  //   final idUser = authData.data?.id;

  //   final paymentAmount = int.tryParse(
  //         totalPriceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
  //       ) ??
  //       0;

  //   final returnPayment = paymentAmount - subtotal;

  //   final totalItem = orderItems.fold<int>(
  //     0,
  //     (previousValue, item) => previousValue + (item.quantity ?? 0),
  //   );

  //   final orderRequest = OrderRequestModel(
  //     idUser: idUser,
  //     layanan: selectedOption,
  //     idPayment: selectedPaymentId,
  //     idPajak: selectedTaxId,
  //     idDiskon: selectedDiscountId,
  //     subTotal: subtotal,
  //     totalItem: totalItem,
  //     total: subtotal,
  //     paymentAmount: paymentAmount,
  //     returnPayment: returnPayment,
  //     transaksiTime: DateTime.now(),
  //     orderItems: orderItems,
  //   );

  //   context.read<AddOrderBloc>().add(AddOrderEvent.addOrder(orderRequest.idDiskon,
  //       orderRequest.idPajak, orderRequest.paymentAmount, orderRequest.layanan, orderRequest.idPayment, orderRequest.orderItems));
  // }
}
