import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/build_context_ext.dart';
import 'package:hrh_pos/data/models/response/tax_response_model.dart';
import 'package:hrh_pos/presentation/home/bloc/edit_tax/edit_tax_bloc.dart';
import 'package:hrh_pos/presentation/home/pages/dashboard_page.dart';

class EditTaxPages extends StatefulWidget {
  final Tax tax;
  const EditTaxPages({super.key, required this.tax});

  @override
  State<EditTaxPages> createState() => _EditTaxPagesState();
}

class _EditTaxPagesState extends State<EditTaxPages> {
  late final TextEditingController namaPajak;
  late final TextEditingController persenPajak;

  @override
  void initState() {
    namaPajak = TextEditingController(text: widget.tax.namaPajak);
    persenPajak = TextEditingController(text: widget.tax.pajakPersen.toString());
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
                BlocConsumer<EditTaxBloc, EditTaxState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      success: () {
                        namaPajak.clear();
                        persenPajak.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pajak berhasil diubah'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        context.pushReplacement(const DashboardPage());
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
                              context.read<EditTaxBloc>().add(
                                    EditTaxEvent.editTax(
                                      idPajak: widget.tax.idPajak!,
                                      namaPajak: namaPajak.text,
                                      persenPajak: int.parse(persenPajak.text),
                                    ),
                                  );
                            },
                            label: 'Edit Pajak');
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