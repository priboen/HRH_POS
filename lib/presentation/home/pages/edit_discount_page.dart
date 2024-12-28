import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/components/custom_date_picker.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/data/models/response/discount_response_model.dart';
import 'package:hrh_pos/presentation/home/bloc/edit_discount/edit_discount_bloc.dart';
import 'package:hrh_pos/presentation/home/pages/dashboard_page.dart';
import 'package:intl/intl.dart';

class EditDiscountPage extends StatefulWidget {
  final Discount discount;
  const EditDiscountPage({super.key, required this.discount});

  @override
  State<EditDiscountPage> createState() => _EditDiscountPageState();
}

class _EditDiscountPageState extends State<EditDiscountPage> {
  late final TextEditingController namaDiskon;
  late final TextEditingController keteranganDiskon;
  late final TextEditingController totalDiskon;
  late final TextEditingController tanggalMulaiDiskon;
  late final TextEditingController tanggalSelesaiDiskon;

  @override
  void initState() {
    namaDiskon = TextEditingController(text: widget.discount.namaDiskon);
    keteranganDiskon = TextEditingController(text: widget.discount.keterangan);
    totalDiskon = TextEditingController(text: widget.discount.diskonPersen.toString());
    tanggalMulaiDiskon = TextEditingController(text: widget.discount.tanggalMulai.toString());
    tanggalSelesaiDiskon = TextEditingController(text: widget.discount.tanggalSelesai.toString());
    super.initState();
  }

  @override
  void dispose() {
    namaDiskon.dispose();
    keteranganDiskon.dispose();
    totalDiskon.dispose();
    tanggalMulaiDiskon.dispose();
    tanggalSelesaiDiskon.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return dateFormatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Diskon'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(controller: namaDiskon, label: 'Nama Diskon'),
                const SpaceHeight(16),
                CustomTextField(
                    controller: keteranganDiskon, label: 'Keterangan Diskon'),
                const SpaceHeight(16),
                CustomTextField(controller: totalDiskon, label: 'Total Diskon'),
                const SpaceHeight(16),
                CustomDatePicker(
                  label: 'Tanggal Mulai',
                  onDateSelected: (selectedDate) => tanggalMulaiDiskon.text =
                      formatDate(selectedDate).toString(),
                ),
                const SpaceHeight(16),
                CustomDatePicker(
                  label: 'Tanggal Selesai',
                  onDateSelected: (selectedDate) => tanggalSelesaiDiskon.text =
                      formatDate(selectedDate).toString(),
                ),
                const SpaceHeight(32),
                BlocConsumer<EditDiscountBloc, EditDiscountState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      success: () {
                        namaDiskon.clear();
                        keteranganDiskon.clear();
                        tanggalMulaiDiskon.clear();
                        tanggalSelesaiDiskon.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Diskon berhasil diubah'),
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
                            // Validasi input dan tanggal
                            if (namaDiskon.text.isEmpty ||
                                keteranganDiskon.text.isEmpty ||
                                totalDiskon.text.isEmpty ||
                                tanggalMulaiDiskon.text.isEmpty ||
                                tanggalSelesaiDiskon.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Semua field harus diisi')),
                              );
                              return;
                            }

                            try {
                              final DateFormat formatter =
                                  DateFormat('yyyy-MM-dd');
                              final DateTime mulai =
                                  formatter.parse(tanggalMulaiDiskon.text);
                              final DateTime selesai =
                                  formatter.parse(tanggalSelesaiDiskon.text);
                              final DateTime sekarang = DateTime.now();

                              if (mulai.isAfter(selesai)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Tanggal mulai harus sebelum tanggal selesai'),
                                  ),
                                );
                                return;
                              }

                              final bool statusDiskon =
                                  sekarang.isAfter(mulai) &&
                                      sekarang.isBefore(selesai);

                              // Kirim event ke BLoC
                              context.read<EditDiscountBloc>().add(
                                    EditDiscountEvent.editDiscount(
                                      idDiskon: widget.discount.idDiskon!,
                                      namaDiskon: namaDiskon.text,
                                      keteranganDiskon: keteranganDiskon.text,
                                      statusDiskon: statusDiskon,
                                      totalDiskon: int.parse(totalDiskon.text),
                                      mulaiDiskon: tanggalMulaiDiskon.text,
                                      selesaiDiskon: tanggalSelesaiDiskon.text,
                                    ),
                                  );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Format tanggal tidak valid: ${e.toString()}')),
                              );
                            }
                          },
                          label: 'Edit Diskon',
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
          ),
        ),
      ),
    );
  }
}
