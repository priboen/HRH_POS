import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/remotes/tax_remote_datasources.dart';
import 'package:hrh_pos/data/models/response/tax_response_model.dart';

part 'get_tax_event.dart';
part 'get_tax_state.dart';
part 'get_tax_bloc.freezed.dart';

class GetTaxBloc extends Bloc<GetTaxEvent, GetTaxState> {
  final TaxRemoteDatasources datasources;
  GetTaxBloc(this.datasources) : super(const _Initial()) {
    on<_GetTax>((event, emit) async{
      emit(const _Loading());
      final result = await datasources.getAllTax();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
