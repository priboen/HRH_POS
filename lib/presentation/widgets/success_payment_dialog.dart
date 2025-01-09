import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/data/dataoutputs/print_dataoutputs.dart';
import 'package:hrh_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class SuccessPaymentDialog extends StatefulWidget {
  const SuccessPaymentDialog({
    super.key,
    required this.products,
    required this.totalQty,
    required this.totalTagihan,
    required this.totalTax,
    required this.totalDiscount,
    required this.finalTotal,
    required this.metodeBayar,
    required this.totalBayar,
  });
  final List<ProductQuantity> products;
  final int totalQty;
  final int totalTagihan;
  final int totalTax;
  final int totalDiscount;
  final int totalBayar;
  final int finalTotal;
  final String metodeBayar;

  @override
  State<SuccessPaymentDialog> createState() => _SuccessPaymentDialogState();
}

class _SuccessPaymentDialogState extends State<SuccessPaymentDialog> {
  List<ProductQuantity> data = [];
  int totalQty = 0;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Assets.icons.success.svg()),
            const SpaceHeight(16.0),
            const Center(
              child: Text(
                'Pembayaran telah sukses dilakukan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SpaceHeight(20.0),
            const Text('METODE BAYAR'),
            const SpaceHeight(5.0),
            Text(
              widget.metodeBayar,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('TOTAL TAGIHAN'),
            const SpaceHeight(5.0),
            Text(
              // widget.totalPrice.currencyFormatRp,
              widget.totalTagihan.currencyFormatRp,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('TOTAL PEMBAYARAN'),
            const SpaceHeight(5.0),
            Text(
              // widget.paymentAmount.currencyFormatRp,
              widget.totalBayar.currencyFormatRp,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('KEMBALIAN'),
            const SpaceHeight(5.0),
            Text(
              (widget.totalBayar - widget.totalTagihan).currencyFormatRp,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceHeight(10.0),
            const Divider(),
            const SpaceHeight(8.0),
            const Text('WAKTU PEMBAYARAN'),
            const SpaceHeight(5.0),
            Text(
              DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now()),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceHeight(20.0),
            Row(
              children: [
                Flexible(
                  child: Button.outlined(
                    onPressed: () {
                      context
                          .read<CheckoutBloc>()
                          .add(const CheckoutEvent.started());
                      context.popToRoot();
                    },
                    label: 'Kembali',
                  ),
                ),
                const SpaceWidth(8.0),
                Flexible(
                  child: Button.filled(
                    onPressed: () async {
                      final printValue = await PrintDataoutputs.instance
                          .printOrder(
                              widget.products,
                              widget.totalTagihan,
                              widget.metodeBayar,
                              widget.totalBayar,
                              widget.totalDiscount,
                              widget.totalTax,
                              widget.finalTotal);
                      await PrintBluetoothThermal.writeBytes(printValue);
                    },
                    label: 'Print',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
