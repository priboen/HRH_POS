import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/local/database_local.dart';
import 'package:hrh_pos/data/models/response/payment_response_model.dart';

part 'local_payment_event.dart';
part 'local_payment_state.dart';
part 'local_payment_bloc.freezed.dart';

class LocalPaymentBloc extends Bloc<LocalPaymentEvent, LocalPaymentState> {
  final DatabaseLocal database;
  LocalPaymentBloc(this.database) : super(const _Initial()) {
    on<_GetPayments>((event, emit) async {
      emit(const _Loading());
      final result = await database.getPayments();
      emit(_Loaded(payments: result));
    });
  }
}
