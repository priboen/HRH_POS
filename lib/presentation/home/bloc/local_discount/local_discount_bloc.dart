import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/local/database_local.dart';
import 'package:hrh_pos/data/models/response/discount_response_model.dart';

part 'local_discount_event.dart';
part 'local_discount_state.dart';
part 'local_discount_bloc.freezed.dart';

class LocalDiscountBloc extends Bloc<LocalDiscountEvent, LocalDiscountState> {
  final DatabaseLocal database;
  LocalDiscountBloc(this.database) : super(const _Initial()) {
    on<_GetDiscounts>((event, emit) async {
      emit(const _Loading());
      final result = await database.getDiscounts();
      emit(_Loaded(discounts: result));
    });
  }
}
