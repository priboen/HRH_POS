import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/components/dashed_line.dart';
import 'package:hrh_pos/core/components/spaces.dart';
import 'package:hrh_pos/core/extensions/int_ext.dart';
import 'package:hrh_pos/presentation/report/bloc/transaction_report/transaction_report_bloc.dart';

class TransactionReportPage extends StatefulWidget {
  const TransactionReportPage({super.key});

  @override
  State<TransactionReportPage> createState() => _TransactionReportPageState();
}

class _TransactionReportPageState extends State<TransactionReportPage> {
  @override
  void initState() {
    context.read<TransactionReportBloc>().add(const TransactionReportEvent.getReport());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<TransactionReportBloc, TransactionReportState>(
            builder: (context, state) {
              final totalRevenue = state.maybeMap(
                orElse: () => 0,
                loaded: (value) {
                  return value.transactionReportModel.fold(
                    0,
                    (previousValue, element) => previousValue + element.total,
                  );
                },
              );
              final totalPajak = state.maybeMap(
                orElse: () => 0,
                loaded: (value) {
                  return value.transactionReportModel.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.totalPajak!.toInt(),
                  );
                },
              );
              final totalDiskon = state.maybeMap(
                orElse: () => 0,
                loaded: (value) {
                  return value.transactionReportModel.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.totalDiskon!.toInt(),
                  );
                },
              );
              return state.maybeWhen(
                orElse: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                loaded: (transactionReportModel) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Penjualan Hari Ini',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                      ),
                      const SpaceHeight(16.0),
                      ...[
                        const Text('TOTAL PENDAPATAN'),
                        const SpaceHeight(8.0),
                        const DashedLine(),
                        const DashedLine(),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Pendapatan Bersih'),
                            Text(totalRevenue.currencyFormatRp),
                          ],
                        ),
                        const SpaceHeight(4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Diskon yang diberikan'),
                            Text(
                              totalDiskon.currencyFormatRp,
                            ),
                          ],
                        ),
                        const SpaceHeight(4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Pajak yang diberikan'),
                            Text(totalPajak.currencyFormatRp),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        const DashedLine(),
                        const DashedLine(),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
