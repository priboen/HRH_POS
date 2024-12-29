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
}
