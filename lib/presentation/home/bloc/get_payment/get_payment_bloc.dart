import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/remotes/payment_remote_datasources.dart';
import 'package:hrh_pos/data/models/response/payment_response_model.dart';

part 'get_payment_event.dart';
part 'get_payment_state.dart';
part 'get_payment_bloc.freezed.dart';

class GetPaymentBloc extends Bloc<GetPaymentEvent, GetPaymentState> {
  final PaymentRemoteDatasources datasources;
  GetPaymentBloc(this.datasources) : super(const _Initial()) {
    on<_GetPayments>((event, emit) async{
      emit(const _Loading());
      final result = await datasources.getPayments();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
