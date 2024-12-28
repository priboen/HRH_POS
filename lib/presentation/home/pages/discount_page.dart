import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/home/bloc/delete_discount/delete_discount_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_discount/get_discount_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_tax/get_tax_bloc.dart';
import 'package:hrh_pos/presentation/home/pages/add_discount_page.dart';
import 'package:hrh_pos/presentation/home/pages/dashboard_page.dart';
import 'package:hrh_pos/presentation/home/pages/edit_discount_page.dart';
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
                            child:
                                BlocBuilder<GetDiscountBloc, GetDiscountState>(
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
                                        childAspectRatio: 1.99,
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
                                                        discounts.namaDiskon!,
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
                                                          'Berlaku Mulai : ${discounts.tanggalMulai!.toFormattedDate()}'),
                                                      Text(
                                                          'Berakhir Pada : ${discounts.tanggalSelesai!.toFormattedDate()}'),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Chip(
                                                    label: Text(
                                                      discounts.status != null
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
                                                    backgroundColor:
                                                        discounts.status != null
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                                ],
                                              ),
                                              const SpaceHeight(64.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          const Size(150, 50),
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      context.push(
                                                          EditDiscountPage(
                                                              discount:
                                                                  discounts));
                                                    },
                                                    child: const Text(
                                                        'Edit Diskon',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        )),
                                                  ),
                                                  const SpaceWidth(16.0),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          const Size(150, 50),
                                                      backgroundColor:
                                                          AppColors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Hapus Diskon'),
                                                              content: const Text(
                                                                  'Apakah anda yakin ingin menghapus diskon ini?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .read<
                                                                            DeleteDiscountBloc>()
                                                                        .add(DeleteDiscountEvent.deleteDiscount(
                                                                            idDiskon:
                                                                                discounts.idDiskon!));
                                                                    context
                                                                        .read<
                                                                            DeleteDiscountBloc>()
                                                                        .stream
                                                                        .listen(
                                                                            (state) {
                                                                      state
                                                                          .maybeWhen(
                                                                        orElse:
                                                                            () {},
                                                                        success:
                                                                            () {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Diskon berhasil dihapus'),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                          ));
                                                                          context
                                                                              .pushReplacement(const DashboardPage());
                                                                        },
                                                                        error:
                                                                            (message) {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text(message),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                          ));
                                                                        },
                                                                      );
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Ya'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Tidak'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: const Text(
                                                      'Hapus Diskon',
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.white),
                                                    ),
                                                  )
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Tambah Data'),
                content: const Text('Pilih jenis data yang ingin ditambahkan'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.push(AddDiscountPage());
                        },
                        child: Text("Diskon"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Pajak"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }
}
