import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/home/bloc/add_tax/add_tax_bloc.dart';
import 'package:hrh_pos/presentation/home/pages/dashboard_page.dart';

class AddTaxPage extends StatefulWidget {
  const AddTaxPage({super.key});

  @override
  State<AddTaxPage> createState() => _AddTaxPageState();
}

class _AddTaxPageState extends State<AddTaxPage> {
  late final TextEditingController namaPajak;
  late final TextEditingController persenPajak;

  @override
  void initState() {
    namaPajak = TextEditingController();
    persenPajak = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    namaPajak.dispose();
    persenPajak.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pajak'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(controller: namaPajak, label: 'Nama Pajak'),
                const SpaceHeight(16),
                CustomTextField(controller: persenPajak, label: 'Persen Pajak'),
                const SpaceHeight(32),
                BlocConsumer<AddTaxBloc, AddTaxState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      success: () {
                        namaPajak.clear();
                        persenPajak.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pajak berhasil ditambahkan'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        context.pushReplacement(DashboardPage());
                      },
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
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
                              context.read<AddTaxBloc>().add(
                                    AddTaxEvent.addTax(
                                      namaPajak: namaPajak.text,
                                      persenPajak: int.parse(persenPajak.text),
                                    ),
                                  );
                            },
                            label: 'Tambah Pajak');
                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
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
    );
  }
}
