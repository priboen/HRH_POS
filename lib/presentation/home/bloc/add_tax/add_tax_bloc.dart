import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/tax_remote_datasources.dart';

part 'add_tax_event.dart';
part 'add_tax_state.dart';
part 'add_tax_bloc.freezed.dart';

class AddTaxBloc extends Bloc<AddTaxEvent, AddTaxState> {
  final TaxRemoteDatasources datasources;
  AddTaxBloc(this.datasources) : super(const _Initial()) {
    on<_AddTax>((event, emit) async {
      emit(const _Loading());
      final result = await datasources.addTax(
        event.namaPajak,
        event.persenPajak,
      );
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
