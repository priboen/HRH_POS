import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/tax_remote_datasources.dart';

part 'edit_tax_event.dart';
part 'edit_tax_state.dart';
part 'edit_tax_bloc.freezed.dart';

class EditTaxBloc extends Bloc<EditTaxEvent, EditTaxState> {
  final TaxRemoteDatasources datasources;
  EditTaxBloc(this.datasources) : super(const _Initial()) {
    on<_EditTax>((event, emit) async{
      emit(const _Loading());
      final result = await datasources.editTax(
        event.idPajak,
        event.namaPajak,
        event.persenPajak,
      );
      result.fold(
        (l) => emit(_Error(l)),
        (r) {
          emit(const _Success());
          emit(const _Initial());
        },
      );
    });
  }
}
