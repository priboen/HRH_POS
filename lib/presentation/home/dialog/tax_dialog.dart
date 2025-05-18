import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_tax/get_tax_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_tax/local_tax_bloc.dart';

class TaxDialog extends StatefulWidget {
  const TaxDialog({super.key});

  @override
  State<TaxDialog> createState() => _TaxDialogState();
}

class _TaxDialogState extends State<TaxDialog> {
    @override
  void initState() {
    context.read<LocalTaxBloc>().add(const LocalTaxEvent.getTaxes());
    super.initState();
  }

  int taxIdSelected = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'PAJAK',
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
      content: BlocBuilder<LocalTaxBloc, LocalTaxState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (taxs) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: taxs
                    .map(
                      (tax) => ListTile(
                        title: Text('Nama Pajak: ${tax.namaPajak}'),
                        subtitle: Text('Tarif Pajak (${tax.pajakPersen}%)'),
                        contentPadding: EdgeInsets.zero,
                        textColor: AppColors.primary,
                        trailing: Checkbox(
                          value: tax.idPajak == taxIdSelected,
                          onChanged: (value) {
                            setState(() {
                              taxIdSelected = tax.idPajak!;
                              context.read<CheckoutBloc>().add(
                                    CheckoutEvent.addTax(
                                      tax,
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