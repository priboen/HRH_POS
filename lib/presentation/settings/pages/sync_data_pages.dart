import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/presentation/settings/bloc/sync_all_data/sync_all_data_bloc.dart';

class SyncDataPages extends StatefulWidget {
  const SyncDataPages({super.key});

  @override
  State<SyncDataPages> createState() => _SyncDataPagesState();
}

class _SyncDataPagesState extends State<SyncDataPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sinkronisasi Data'),
      ),
      body: Column(
        children: [
          // BlocConsumer<SyncCategoriesBloc, SyncCategoriesState>(
          //   listener: (context, state) {
          //     state.maybeWhen(
          //       orElse: () {},
          //       loading: () => const Center(
          //         child: CircularProgressIndicator(),
          //       ),
          //       error: (e) => ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(e),
          //           backgroundColor: AppColors.red,
          //         ),
          //       ),
          //       loaded: (category) {
          //         ProductLocalDatasources.instance.deleteAllCategory();
          //         ProductLocalDatasources.instance.insertCategories(category);
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(
          //             content: Text('Data kategori berhasil disinkronisasi'),
          //             backgroundColor: AppColors.green,
          //           ),
          //         );
          //       },
          //     );
          //   },
          //   builder: (context, state) {
          //     return state.maybeWhen(
          //       orElse: () {
          //         return Button.filled(
          //             onPressed: () {
          //               context
          //                   .read<SyncCategoriesBloc>()
          //                   .add(const SyncCategoriesEvent.syncCategories());
          //             },
          //             label: 'Sinkronisasi Kategori');
          //       },
          //       loading: () => const Center(
          //         child: CircularProgressIndicator(),
          //       ),
          //     );
          //   },
          // ),

          const SpaceHeight(16.0),
          BlocConsumer<SyncAllDataBloc, SyncAllDataState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                success: (product, discount, tax, payment) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil disinkronisasi'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return Button.filled(
                    onPressed: () {
                      context.read<SyncAllDataBloc>().add(
                            const SyncAllDataEvent.syncAllData(),
                          );
                    },
                    label: 'Sinkronisasi Semua Data',
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
