import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/home/bloc/local_discount/local_discount_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_tax/local_tax_bloc.dart';
import 'package:hrh_pos/presentation/widgets/custom_tab_bar.dart';
import 'package:hrh_pos/presentation/widgets/home_title.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    // context.read<GetDiscountBloc>().add(const GetDiscountEvent.getDiscount());
    // context.read<GetTaxBloc>().add(const GetTaxEvent.getTax());
    context
        .read<LocalDiscountBloc>()
        .add(const LocalDiscountEvent.getDiscounts());
    context.read<LocalTaxBloc>().add(const LocalTaxEvent.getTaxes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HomeTitle(
                        controller: searchController,
                      ),
                      const SizedBox(height: 24),
                      CustomTabBar(
                        tabTitles: [
                          'Diskon',
                          'Pajak',
                        ],
                        initialTabIndex: 0,
                        tabViews: [
                          SizedBox(
                            child: BlocBuilder<LocalDiscountBloc,
                                LocalDiscountState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (message) => Center(
                                    child: Text(message),
                                  ),
                                  loaded: (discount) {
                                    if (discount.isEmpty) {
                                      return const Center(
                                        child: Text('No discount available'),
                                      );
                                    }
                                    return GridView.builder(
                                      itemCount: discount.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 3,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15.0,
                                        mainAxisSpacing: 15.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        final discounts = discount[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.black
                                                    .withOpacity(0.06),
                                                blurRadius: 10.0,
                                                blurStyle: BlurStyle.outer,
                                                offset: const Offset(0, 0),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    Assets.icons.discount.path,
                                                    height: 100,
                                                    color: AppColors.primary,
                                                  ),
                                                  const SpaceWidth(16.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        discounts.namaDiskon ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 24.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              'Total Diskon : '),
                                                          Text(
                                                            '${discounts.diskonPersen.toString()}%',
                                                            style: const TextStyle(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Berlaku Mulai : ${discounts.tanggalMulai != null ? discounts.tanggalMulai!.toFormattedDate() : 'Tidak tersedia'}',
                                                      ),
                                                      Text(
                                                        'Berakhir Pada : ${discounts.tanggalSelesai != null ? discounts.tanggalSelesai!.toFormattedDate() : 'Tidak tersedia'}',
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Chip(
                                                    label: Text(
                                                      (discounts
                                                                      .tanggalMulai !=
                                                                  null &&
                                                              discounts
                                                                      .tanggalSelesai !=
                                                                  null &&
                                                              DateTime.now()
                                                                  .isAfter(discounts
                                                                      .tanggalMulai!) &&
                                                              DateTime.now()
                                                                  .isBefore(
                                                                      discounts
                                                                          .tanggalSelesai!))
                                                          ? 'Aktif'
                                                          : 'Tidak Aktif',
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    side: BorderSide.none,
                                                    backgroundColor: (discounts
                                                                    .tanggalMulai !=
                                                                null &&
                                                            discounts
                                                                    .tanggalSelesai !=
                                                                null &&
                                                            DateTime.now()
                                                                .isAfter(discounts
                                                                    .tanggalMulai!) &&
                                                            DateTime.now()
                                                                .isBefore(discounts
                                                                    .tanggalSelesai!))
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            child: BlocBuilder<LocalTaxBloc, LocalTaxState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (message) => Center(
                                    child: Text(message),
                                  ),
                                  loaded: (tax) {
                                    if (tax.isEmpty) {
                                      return const Center(
                                        child: Text('No tax available'),
                                      );
                                    }
                                    return GridView.builder(
                                      itemCount: tax.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 1.99,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 30.0,
                                        mainAxisSpacing: 30.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        final taxes = tax[index];
                                        return Card(
                                          color: AppColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                Assets.icons.diskon.path,
                                                width: 75,
                                                height: 75,
                                              ),
                                              const SpaceHeight(32),
                                              Text(
                                                taxes.namaPajak!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                '${taxes.pajakPersen}%',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
