import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/presentation/home/bloc/get_product/get_product_bloc.dart';
import 'package:hrh_pos/presentation/widgets/custom_tab_bar.dart';
import 'package:hrh_pos/presentation/widgets/home_title.dart';
import 'package:hrh_pos/presentation/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                                                      data: filteredProducts[
                                                          index]);
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
                              Button.filled(
                                width: 120.0,
                                height: 40,
                                onPressed: () {},
                                label: 'Dine In',
                              ),
                              const SpaceWidth(16.0),
                              Button.outlined(
                                width: 150.0,
                                height: 40,
                                onPressed: () {},
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
                          
                        ],
                      ),
                    )
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
