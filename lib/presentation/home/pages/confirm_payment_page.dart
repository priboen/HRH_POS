import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_payment/get_payment_bloc.dart';
import 'package:hrh_pos/presentation/home/controllers/confirm_payment_controller.dart';
import 'package:hrh_pos/presentation/home/dialog/qris_dialog_page.dart';
import 'package:hrh_pos/presentation/widgets/order_menu.dart';

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

  @override
  void initState() {
    totalPriceController = TextEditingController();
    paymentController = ConfirmPaymentController(totalPriceController);
    context.read<GetPaymentBloc>().add(const GetPaymentEvent.getPayments());
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
                                    final totalDiskon =
                                        (discount?.diskonPersen ?? 0) *
                                            total /
                                            100;
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
                            BlocBuilder<GetPaymentBloc, GetPaymentState>(
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
                            BlocBuilder<GetPaymentBloc, GetPaymentState>(
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
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            QrisDialogPage(
                                                                imageUrl: payment
                                                                        .imagePayment ??
                                                                    ''),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        selectedPayment =
                                                            payment.namaPayment;
                                                      });
                                                    }
                                                  },
                                                  label:
                                                      payment.namaPayment ?? '',
                                                )
                                              : Button.outlined(
                                                  width: 120.0,
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedPayment =
                                                          payment.namaPayment;
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
                                hintText: 'Total harga',
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Button.outlined(
                                    width: 150.0,
                                    onPressed: () => context.pop(),
                                    label: 'Batalkan',
                                  ),
                                ),
                                const SpaceWidth(8.0),
                                Flexible(
                                  child: Button.filled(
                                    width: 150.0,
                                    onPressed: () {},
                                    label: 'Bayar',
                                  ),
                                ),
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
