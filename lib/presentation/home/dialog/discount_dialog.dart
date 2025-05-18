import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/constants/colors.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_discount/local_discount_bloc.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog({super.key});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  @override
  void initState() {
    context
        .read<LocalDiscountBloc>()
        .add(const LocalDiscountEvent.getDiscounts());
    super.initState();
  }

  int discountIdSelected = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'DISKON',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.cancel,
                color: AppColors.primary,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      content: BlocBuilder<LocalDiscountBloc, LocalDiscountState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (discounts) {
              final now = DateTime.now();
              final activeDiscounts = discounts.where((discount) {
                final isActive = discount.tanggalMulai != null &&
                    discount.tanggalSelesai != null &&
                    now.isAfter(discount.tanggalMulai!) &&
                    now.isBefore(discount.tanggalSelesai!);
                return isActive;
              }).toList();

              if (activeDiscounts.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada diskon aktif saat ini.',
                    style: TextStyle(color: AppColors.primary),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: activeDiscounts
                    .map(
                      (discount) => ListTile(
                        title: Text('Nama Diskon: ${discount.namaDiskon}'),
                        subtitle:
                            Text('Potongan harga (${discount.diskonPersen}%)'),
                        contentPadding: EdgeInsets.zero,
                        textColor: AppColors.primary,
                        trailing: Checkbox(
                          value: discount.idDiskon == discountIdSelected,
                          onChanged: (value) {
                            setState(() {
                              discountIdSelected = discount.idDiskon!;
                              context.read<CheckoutBloc>().add(
                                    CheckoutEvent.addDiscount(
                                      discount,
                                    ),
                                  );
                            });
                          },
                        ),
                        onTap: () {
                          // context.pop();
                        },
                      ),
                    )
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
