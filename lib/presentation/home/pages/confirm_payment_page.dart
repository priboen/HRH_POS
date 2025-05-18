import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_payment/get_payment_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_payment/local_payment_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/order/order_bloc.dart';
import 'package:hrh_pos/presentation/home/controllers/confirm_payment_controller.dart';
import 'package:hrh_pos/presentation/home/dialog/qris_dialog_page.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';
import 'package:hrh_pos/presentation/widgets/order_menu.dart';
import 'package:hrh_pos/presentation/widgets/success_payment_dialog.dart';

class ConfirmPaymentPage extends StatefulWidget {
  final String selectedOption;
  const ConfirmPaymentPage({super.key, required this.selectedOption});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  late ConfirmPaymentController paymentController;
  late final TextEditingController totalPriceController;
  String? selectedPayment;
  int? selectedIdPayment;

  @override
  void initState() {
    totalPriceController = TextEditingController();
    paymentController = ConfirmPaymentController(totalPriceController);
    context.read<LocalPaymentBloc>().add(const LocalPaymentEvent.getPayments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'confirmation_screen',
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Konfirmasi Pesanan',
            ),
          ),
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Konfirmasi',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Order #1',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Text(
                                widget.selectedOption,
                                style: const TextStyle(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        const Divider(),
                        const SpaceHeight(24.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Item',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 160,
                            ),
                            SizedBox(
                              width: 50.0,
                              child: Text(
                                'Qty',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                'Harga',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8),
                        const Divider(),
                        const SpaceHeight(8),
                        BlocBuilder<CheckoutBloc, CheckoutState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () => const Center(
                                child: Text('No Items'),
                              ),
                              loaded: (products, discount, tax) {
                                if (products.isEmpty) {
                                  return const Center(
                                    child: Text('No Items'),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      OrderMenu(data: products[index]),
                                  separatorBuilder: (context, index) =>
                                      const SpaceHeight(1.0),
                                  itemCount: products.length,
                                );
                              },
                            );
                          },
                        ),
                        const SpaceHeight(24.0),
                        const Divider(),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pajak',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final tax = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (items, discount, tax) =>
                                      tax?.pajakPersen ?? 0,
                                );
                                return Text(
                                  '$tax %',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Diskon',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final discount = state.maybeWhen(
                                    orElse: () => 0,
                                    loaded: (items, discount, tax) =>
                                        discount?.diskonPersen ?? 0);
                                return Text(
                                  '$discount %',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                // final subtotal = state.maybeWhen(
                                //   orElse: () => 0,
                                //   loaded: (items, discount, tax) {
                                //     final total = items.isNotEmpty
                                //         ? items
                                //             .map((e) =>
                                //                 e.product.price!
                                //                     .toIntegerFromText *
                                //                 e.quantity)
                                //             .reduce((value, element) =>
                                //                 value + element)
                                //         : 0;
                                //     return total;
                                //   },
                                // );
                                final subtotal = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (items, discount, tax) {
                                    final total = items.isNotEmpty
                                        ? items
                                            .map((e) =>
                                                e.product.price!
                                                    .toIntegerFromText *
                                                e.quantity)
                                            .reduce((value, element) =>
                                                value + element)
                                        : 0;
                                    // final totalDiskon =
                                    //     (discount?.diskonPersen ?? 0) *
                                    //         total /
                                    //         100;
                                    final totalDiskon =
                                        (discount?.diskonPersen ?? 0) *
                                            total /
                                            100;

                                    // final totalPajak = (tax?.pajakPersen ?? 0) *
                                    // (total - totalDiskon) /
                                    // 100;
                                    final totalPajak = (tax?.pajakPersen ?? 0) *
                                        (total - totalDiskon) /
                                        100;

                                    return total - totalDiskon + totalPajak;
                                  },
                                );
                                paymentController.subtotal = subtotal.toInt();
                                return Flexible(
                                  child: Text(
                                    subtotal.toInt().currencyFormatRp,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pembayaran',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            BlocBuilder<LocalPaymentBloc, LocalPaymentState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () => const Text('No Payment Method'),
                                  loading: () =>
                                      const Text('Loading Payment Methods...'),
                                  loaded: (payments) {
                                    final paymentCount = payments.length;
                                    return Text(
                                      '$paymentCount ${paymentCount == 1 ? "Opsi Pembayaran Tersedia" : "Opsi Pembayaran Tersedia"}',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SpaceHeight(8.0),
                            const Divider(),
                            const SpaceHeight(8.0),
                            const Text(
                              'Metode Bayar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SpaceHeight(12.0),
                            BlocBuilder<LocalPaymentBloc, LocalPaymentState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () => const Center(
                                    child: Text('No Payment Method'),
                                  ),
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  loaded: (payments) {
                                    if (payments.isEmpty) {
                                      return const Center(
                                        child:
                                            Text('Tidak ada metode pembayaran'),
                                      );
                                    }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: payments.map((payment) {
                                        final isSelected = selectedPayment ==
                                            payment.namaPayment;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: isSelected
                                              ? Button.filled(
                                                  width: 120.0,
                                                  onPressed: () {
                                                    if (payment.namaPayment
                                                            ?.toLowerCase() ==
                                                        'qris') {
                                                      setState(() {
                                                        selectedIdPayment =
                                                            payment.idPayment;
                                                        selectedPayment =
                                                            payment.namaPayment;
                                                      });
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            QrisDialogPage(
                                                          imageUrl: payment
                                                                  .imagePayment ??
                                                              '',
                                                          onPayPressed: () {
                                                            paymentController
                                                                .setExactTotal();
                                                          },
                                                        ),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        selectedPayment =
                                                            payment.namaPayment;
                                                        selectedIdPayment =
                                                            payment.idPayment;
                                                      });
                                                    }
                                                  },
                                                  label:
                                                      payment.namaPayment ?? '',
                                                )
                                              : Button.outlined(
                                                  width: 120.0,
                                                  onPressed: () async {
                                                    setState(() {
                                                      selectedPayment =
                                                          payment.namaPayment;
                                                      selectedIdPayment =
                                                          payment.idPayment;
                                                    });
                                                  },
                                                  label:
                                                      payment.namaPayment ?? '',
                                                ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                  error: (message) => Center(
                                    child: Text(message),
                                  ),
                                );
                              },
                            ),
                            const SpaceHeight(8.0),
                            const Divider(),
                            const SpaceHeight(8.0),
                            const Text(
                              'Total Bayar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SpaceHeight(12.0),
                            TextFormField(
                              controller: totalPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                hintText: 'Total pembayaran',
                              ),
                            ),
                            const SpaceHeight(45.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    paymentController.setExactTotal();
                                  },
                                  label: 'UANG PAS',
                                ),
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    paymentController.updateTotal(20000);
                                  },
                                  label: 'Rp 20.000',
                                ),
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    paymentController.updateTotal(50000);
                                  },
                                  label: 'Rp 50.000',
                                ),
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    paymentController.updateTotal(100000);
                                  },
                                  label: 'Rp 100.000',
                                ),
                              ],
                            ),
                            const SpaceHeight(100.0),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ColoredBox(
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Button.outlined(
                                    width: 150.0,
                                    onPressed: () => context.pop(),
                                    label: 'Batalkan',
                                  ),
                                ),
                                const SpaceWidth(16.0),
                                BlocBuilder<CheckoutBloc, CheckoutState>(
                                  builder: (context, state) {
                                    final discount = state.maybeWhen(
                                        orElse: () => 0,
                                        loaded: (products, discount, tax) {
                                          if (discount == null) {
                                            return 0;
                                          }
                                          return discount.diskonPersen;
                                        });
                                    final idDiskon = state.maybeWhen(
                                      orElse: () {},
                                      loaded: (items, discount, tax) =>
                                          discount?.idDiskon,
                                    );
                                    final diskonPersen = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (items, discount, tax) =>
                                          discount?.diskonPersen,
                                    );
                                    final totalDiskon = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (items, discount, tax) =>
                                          items.fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  (element.product.price!
                                                          .toIntegerFromText *
                                                      element.quantity)) *
                                          diskonPersen! /
                                          100,
                                    );
                                    print('id diskon :$idDiskon');
                                    print('diskon persen : $diskonPersen');
                                    print('total diskon : $totalDiskon');
                                    final tax = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (items, discount, tax) {
                                        if (tax == null) {
                                          return 0;
                                        }
                                        return tax.pajakPersen;
                                      },
                                    );
                                    final idPajak = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (items, discount, tax) =>
                                          tax?.idPajak,
                                    );
                                    final pajakPersen = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (items, discount, tax) =>
                                          tax?.pajakPersen,
                                    );
                                    final totalPajak = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (items, discount, tax) =>
                                          items.fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  (element.product.price!
                                                          .toIntegerFromText *
                                                      element.quantity)) *
                                          pajakPersen! /
                                          100,
                                    );
                                    print(' id pajak : $idPajak');
                                    print('persen pajak : $pajakPersen');
                                    print('total Pajak : $totalPajak');

                                    List<ProductQuantity> items =
                                        state.maybeWhen(
                                      orElse: () => [],
                                      loaded: (products, discount, tax) =>
                                          products,
                                    );

                                    return Flexible(
                                      child: Button.filled(
                                        width: 150.0,
                                        onPressed: () async {
                                          context
                                              .read<OrderBloc>()
                                              .add(OrderEvent.order(
                                                items,
                                                idDiskon,
                                                idPajak,
                                                totalPriceController
                                                    .text.toIntegerFromText,
                                                selectedIdPayment!,
                                                widget.selectedOption,
                                                pajakPersen ?? 0,
                                                diskonPersen ?? 0,
                                                totalPajak.toInt(),
                                                totalDiskon.toInt(),
                                              ));
                                          print('Total Diskon Order Bloc: $totalDiskon');
                                          print('Total Pajak Order Bloc: $totalPajak');
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                // SuccessPaymentDialog(
                                                //   paymentAmount:
                                                //       totalPriceController
                                                //           .text
                                                //           .toIntegerFromText,
                                                //   selectedPayment:
                                                //       selectedPayment ?? '',
                                                //   data: items,
                                                //   totalQty: items.fold(
                                                //       0,
                                                //       (previousValue,
                                                //               element) =>
                                                //           previousValue +
                                                //           element.quantity),
                                                //   totalPrice:
                                                //       paymentController
                                                //           .subtotal,
                                                //   totalTax: tax!,
                                                //   totalDiscount: discount!,
                                                //   subTotal: paymentController
                                                //       .subtotal,
                                                // )
                                                SuccessPaymentDialog(
                                              products: items,
                                              totalQty: items.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      element.quantity),
                                              totalTagihan:
                                                  paymentController.subtotal,
                                              totalTax: tax ?? 0,
                                              totalDiscount: discount ?? 0,
                                              finalTotal: items.fold(
                                                0,
                                                (total, element) =>
                                                    total +
                                                    (element.product.price!
                                                            .toIntegerFromText *
                                                        element.quantity),
                                              ),
                                              // paymentController.subtotal,
                                              metodeBayar:
                                                  selectedPayment ?? '',
                                              totalBayar: totalPriceController
                                                  .text.toIntegerFromText,
                                            ),
                                          );
                                        },
                                        label: 'Bayar',
                                      ),
                                    );
                                  },
                                ),
                                const SpaceWidth(8.0),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
