import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/local/database_local.dart';
import 'package:hrh_pos/data/models/response/tax_response_model.dart';

part 'local_tax_event.dart';
part 'local_tax_state.dart';
part 'local_tax_bloc.freezed.dart';

class LocalTaxBloc extends Bloc<LocalTaxEvent, LocalTaxState> {
  final DatabaseLocal database;
  LocalTaxBloc(this.database) : super(const _Initial()) {
    on<_GetTaxes>((event, emit) async {
      emit(const _Loading());
      final result = await database.getTaxs();
      emit(_Loaded(taxes: result));
    });
  }
}
