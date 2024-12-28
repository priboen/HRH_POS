import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/discount_remote_datasources.dart';
import 'package:hrh_pos/data/models/response/discount_response_model.dart';

part 'get_discount_event.dart';
part 'get_discount_state.dart';
part 'get_discount_bloc.freezed.dart';

class GetDiscountBloc extends Bloc<GetDiscountEvent, GetDiscountState> {
  final DiscountRemoteDatasources datasources;
  GetDiscountBloc(this.datasources) : super(const _Initial()) {
    on<_GetDiscount>((event, emit) async {
      emit(const _Loading());
      final result = await datasources.getAllDiscount();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
