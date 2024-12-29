import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/build_context_ext.dart';
import 'package:hrh_pos/core/extensions/int_ext.dart';
import 'package:hrh_pos/core/extensions/string_ext.dart';
import 'package:hrh_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_product/get_product_bloc.dart';
import 'package:hrh_pos/presentation/home/dialog/discount_dialog.dart';
import 'package:hrh_pos/presentation/home/dialog/tax_dialog.dart';
import 'package:hrh_pos/presentation/home/pages/confirm_payment_page.dart';
import 'package:hrh_pos/presentation/widgets/column_button.dart';
import 'package:hrh_pos/presentation/widgets/custom_tab_bar.dart';
import 'package:hrh_pos/presentation/widgets/home_title.dart';
import 'package:hrh_pos/presentation/widgets/order_menu.dart';
import 'package:hrh_pos/presentation/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  final searchController = TextEditingController();

  @override
  void initState() {
    context.read<GetProductBloc>().add(const GetProductEvent.getProduct());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'confirmation_screen',
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
                        BlocBuilder<GetProductBloc, GetProductState>(
                          builder: (context, state) {
                            return state.when(
                              initial: () => const Center(
                                  child: CircularProgressIndicator()),
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              loaded: (products) {
                                final categories = context
                                    .read<GetProductBloc>()
                                    .extractCategoriesFromProducts(products)
                                    .map((category) => category.name)
                                    .where((name) => name != null)
                                    .toSet()
                                    .toList();
                                final tabTitles = ['Semua', ...categories];
                                return CustomTabBar(
                                  tabTitles:
                                      tabTitles.whereType<String>().toList(),
                                  initialTabIndex: 0,
                                  tabViews: List.generate(
                                    tabTitles.length,
                                    (index) {
                                      if (index == 0) {
                                        return GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 0.85,
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 30.0,
                                            mainAxisSpacing: 30.0,
                                          ),
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            return ProductCard(
                                                data: products[index]);
                                          },
                                        );
                                      } else {
                                        final filteredProducts = products
                                            .where((product) =>
                                                product.category?.name ==
                                                tabTitles[index])
                                            .toList();

                                        return filteredProducts.isEmpty
                                            ? const Center(
                                                child: Text('Data Kosong'))
                                            : GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 0.85,
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 30.0,
                                                  mainAxisSpacing: 30.0,
                                                ),
                                                itemCount:
                                                    filteredProducts.length,
                                                itemBuilder: (context, index) {
                                                  return ProductCard(
                                                    data:
                                                        filteredProducts[index],
                                                  );
                                                },
                                              );
                                      }
                                    },
                                  ),
                                );
                              },
                              error: (e) {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e),
                                      ),
                                    );
                                  },
                                );
                                return const Center(
                                  child: Text('Terjadi Kesalahan'),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order #1',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SpaceHeight(8.0),
                          Row(
                            children: [
                              selectedCategory == 'Dine In'
                                  ? Button.filled(
                                      width: 120.0,
                                      height: 40,
                                      onPressed: () {
                                        setState(() {
                                          selectedCategory = 'Dine In';
                                        });
                                      },
                                      label: 'Dine In',
                                    )
                                  : Button.outlined(
                                      width: 120.0,
                                      height: 40,
                                      onPressed: () {
                                        setState(() {
                                          selectedCategory = 'Dine In';
                                        });
                                      },
                                      label: 'Dine In',
                                    ),
                              const SpaceWidth(16.0),
                              selectedCategory == 'Take Away'
                                  ? Button.filled(
                                      width: 150.0,
                                      height: 40,
                                      onPressed: () {
                                        setState(() {
                                          selectedCategory = 'Take Away';
                                        });
                                      },
                                      label: 'Take Away',
                                    )
                                  : Button.outlined(
                                      width: 150.0,
                                      height: 40,
                                      onPressed: () {
                                        setState(() {
                                          selectedCategory = 'Take Away';
                                        });
                                      },
                                      label: 'Take Away',
                                    ),
                            ],
                          ),
                          const SpaceHeight(16.0),
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
                                width: 130,
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                          const SpaceHeight(16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ColumnButton(
                                label: 'Diskon',
                                svgGenImage: Assets.icons.pajak,
                                onPressed: () => showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const DiscountDialog(),
                                ),
                              ),
                              ColumnButton(
                                label: 'Pajak',
                                svgGenImage: Assets.icons.diskon,
                                onPressed: () => showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const TaxDialog(),
                                ),
                              ),
                            ],
                          ),
                          const SpaceHeight(8.0),
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
                                    loaded: (items, discount, tax) {
                                      if (tax == null) {
                                        return 0;
                                      }
                                      return tax.pajakPersen!;
                                    },
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
                                      loaded: (items, discount, tax) {
                                        if (discount == null) {
                                          return 0;
                                        }
                                        return discount.diskonPersen!;
                                      });
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
                                'Sub total',
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
                                      final totalPajak =
                                          (tax?.pajakPersen ?? 0) *
                                              (total - totalDiskon) /
                                              100;
                                      return total - totalDiskon + totalPajak;
                                    },
                                  );
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
                              horizontal: 24.0, vertical: 16.0),
                          child: Button.filled(
                            onPressed: () {
                              if(selectedCategory == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pilih salah satu layanan'),
                                    backgroundColor: AppColors.red,
                                  ),
                                );
                              }
                              context.push(ConfirmPaymentPage(
                                selectedOption: selectedCategory!,
                              ));
                            },
                            label: 'Lanjutkan Pembayaran',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
