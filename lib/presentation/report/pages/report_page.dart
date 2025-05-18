import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/components/custom_date_picker.dart';
import 'package:hrh_pos/core/components/dashed_line.dart';
import 'package:hrh_pos/core/components/spaces.dart';
import 'package:hrh_pos/core/extensions/date_time_ext.dart';
import 'package:hrh_pos/core/extensions/int_ext.dart';
import 'package:hrh_pos/presentation/report/bloc/item_sales/item_sales_bloc.dart';
import 'package:hrh_pos/presentation/report/bloc/transaction_report/transaction_report_bloc.dart';
import 'package:hrh_pos/presentation/report/pages/item_sales_report_page.dart';
import 'package:hrh_pos/presentation/report/pages/summary_sales_report_page.dart';
import 'package:hrh_pos/presentation/report/pages/transaction_report_page.dart';
import 'package:hrh_pos/presentation/report/widgets/report_menu.dart';
import 'package:hrh_pos/presentation/report/widgets/report_title.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int selectedMenu = 0;
  String title = 'Summary Sales Report';
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String searchDateFormatted =
        '${fromDate.toFormattedDate2()} to ${toDate.toFormattedDate2()}';
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          context
              .read<TransactionReportBloc>()
              .add(const TransactionReportEvent.getReport());
          return Future.value();
        },
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const ReportTitle(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: CustomDatePicker(
                                showLabel: false,
                                label: 'Form',
                                prefix: const Text('From: '),
                                initialDate: fromDate,
                                onDateSelected: (selectedDate) {
                                  fromDate = selectedDate;
                                  setState(() {});
                                },
                              ),
                            ),
                            const SpaceWidth(100.0),
                            Flexible(
                              child: CustomDatePicker(
                                showLabel: false,
                                label: 'To',
                                prefix: const Text('To: '),
                                initialDate: toDate,
                                onDateSelected: (selectedDate) {
                                  toDate = selectedDate;
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Wrap(
                          children: [
                            ReportMenu(
                              label: 'Item Sales Report',
                              onPressed: () {
                                selectedMenu = 0;
                                title = 'Item Sales Report';
                                setState(
                                  () {},
                                );
                              },
                              isActive: selectedMenu == 0,
                            ),
                            ReportMenu(
                              label: 'Daily Sales Report',
                              onPressed: () {
                                selectedMenu = 1;
                                title = 'Daily Sales Report';
                                setState(() {});
                              },
                              isActive: selectedMenu == 1,
                            ),
                            ReportMenu(
                              label: 'Summary Sales Report',
                              onPressed: () {
                                selectedMenu = 2;
                                title = 'Summary Sales Report';
                                setState(() {});
                              },
                              isActive: selectedMenu == 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Align(
            //     alignment: Alignment.topCenter,
            //     child: SingleChildScrollView(
            //       padding: const EdgeInsets.all(24.0),
            //       child:
            //           BlocBuilder<TransactionReportBloc, TransactionReportState>(
            //         builder: (context, state) {
            //           final totalRevenue = state.maybeMap(
            //             orElse: () => 0,
            //             loaded: (value) {
            //               return value.transactionReportModel.fold(
            //                 0,
            //                 (previousValue, element) =>
            //                     previousValue + element.total,
            //               );
            //             },
            //           );

            //           // final subTotal = state.maybeMap(
            //           //   orElse: () => 0,
            //           //   loaded: (value) {
            //           //     return value.transactionReportModel.fold(
            //           //       0,
            //           //       (previousValue, element) =>
            //           //           //subtotal
            //           //           previousValue + element.total,
            //           //     );
            //           //   },
            //           // );

            //           // final discount = state.maybeMap(
            //           //   orElse: () => 0,
            //           //   loaded: (value) {
            //           //     return value.transactionReportModel.fold(
            //           //       0,
            //           //       (previousValue, element) =>
            //           //           previousValue + element.diskonPersen!.toInt(),
            //           //     );
            //           //   },
            //           // );

            //           // final tax = state.maybeMap(
            //           //   orElse: () => 0,
            //           //   loaded: (value) {
            //           //     return value.transactionReportModel.fold(
            //           //       0,
            //           //       (previousValue, element) =>
            //           //           previousValue + element.pajakPersen!.toInt(),
            //           //     );
            //           //   },
            //           // );

            //           final totalPajak = state.maybeMap(
            //             orElse: () => 0,
            //             loaded: (value) {
            //               return value.transactionReportModel.fold(
            //                 0,
            //                 (previousValue, element) =>
            //                     previousValue + element.totalPajak!.toInt(),
            //               );
            //             },
            //           );

            //           final totalDiskon = state.maybeMap(
            //             orElse: () => 0,
            //             loaded: (value) {
            //               return value.transactionReportModel.fold(
            //                 0,
            //                 (previousValue, element) =>
            //                     previousValue + element.totalDiskon!.toInt(),
            //               );
            //             },
            //           );

            //           print('Total Diskon: $totalDiskon');
            //           print('Total Pajak: $totalPajak');

            //           return state.maybeWhen(
            //             orElse: () {
            //               return const Center(
            //                 child: Text('No Data'),
            //               );
            //             },
            //             loading: () {
            //               return const Center(
            //                 child: CircularProgressIndicator(),
            //               );
            //             },
            //             loaded: (transactionReport) {
            //               return Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Center(
            //                     child: Text(
            //                       title,
            //                       style: const TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                           fontSize: 16.0),
            //                     ),
            //                   ),
            //                   Center(
            //                     child: Text(
            //                       searchDateFormatted,
            //                       style: const TextStyle(fontSize: 16.0),
            //                     ),
            //                   ),
            //                   const SpaceHeight(16.0),
            //                   ...[
            //                     Text('TOTAL PENDAPATAN'),
            //                     const SpaceHeight(8.0),
            //                     const DashedLine(),
            //                     const DashedLine(),
            //                     const SpaceHeight(8.0),
            //                     Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text('Pendapatan Bersih'),
            //                         Text('${totalRevenue.currencyFormatRp}'),
            //                       ],
            //                     ),
            //                     const SpaceHeight(4.0),
            //                     Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text('Total Diskon yang diberikan'),
            //                         Text(
            //                           '${totalDiskon.currencyFormatRp}',
            //                         ),
            //                       ],
            //                     ),
            //                     const SpaceHeight(4.0),
            //                     Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text('Total Pajak yang diberikan'),
            //                         Text('${totalPajak.currencyFormatRp}'),
            //                       ],
            //                     ),
            //                     const SpaceHeight(8.0),
            //                     const DashedLine(),
            //                     const DashedLine(),
            //                   ],
            //                 ],
            //               );
            //             },
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: IndexedStack(
                    index: selectedMenu,
                    children: const [
                      ItemSalesReportPage(),
                      TransactionReportPage(),
                      SummarySalesReportPage()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
