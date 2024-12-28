import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/tax_remote_datasources.dart';

part 'delete_tax_event.dart';
part 'delete_tax_state.dart';
part 'delete_tax_bloc.freezed.dart';

class DeleteTaxBloc extends Bloc<DeleteTaxEvent, DeleteTaxState> {
  final TaxRemoteDatasources taxRemoteDatasources;
  DeleteTaxBloc(this.taxRemoteDatasources) : super(const _Initial()) {
    on<_DeleteTax>((event, emit) async {
      emit(const _Loading());
      final result = await taxRemoteDatasources.deleteTax(event.idTax);
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
