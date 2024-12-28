import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/presentation/home/bloc/get_discount/get_discount_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_tax/get_tax_bloc.dart';
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
    context.read<GetDiscountBloc>().add(const GetDiscountEvent.getDiscount());
    context.read<GetTaxBloc>().add(const GetTaxEvent.getTax());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'discount page',
      child: Scaffold(
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
                              child: BlocBuilder<GetDiscountBloc,
                                  GetDiscountState>(
                                builder: (context, state) {
                                  return state.maybeWhen(
                                    orElse: () {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    loading: () => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (message) => Center(
                                      child: Text(message),
                                    ),
                                    loaded: (discount) {
                                      if (discount.isEmpty) {
                                        return Center(
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
                                          childAspectRatio: 0.85,
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 30.0,
                                          mainAxisSpacing: 30.0,
                                        ),
                                        itemBuilder: (context, index) {
                                          final discounts = discount[index];
                                          return Card(
                                            color: AppColors.card,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  discounts.namaDiskon!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${discounts.diskonPersen}%',
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
                            SizedBox(
                                child: BlocBuilder<GetTaxBloc, GetTaxState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  loading: () => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (message) => Center(
                                    child: Text(message),
                                  ),
                                  loaded: (tax) {
                                    if (tax.isEmpty) {
                                      return Center(
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
                                        childAspectRatio: 0.85,
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 30.0,
                                        mainAxisSpacing: 30.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        final taxes = tax[index];
                                        return Card(
                                          color: AppColors.card,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
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
                            ))
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
      ),
    );
  }
}
