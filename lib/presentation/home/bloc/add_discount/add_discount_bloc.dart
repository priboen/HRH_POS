import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/discount_remote_datasources.dart';

part 'add_discount_event.dart';
part 'add_discount_state.dart';
part 'add_discount_bloc.freezed.dart';

class AddDiscountBloc extends Bloc<AddDiscountEvent, AddDiscountState> {
  final DiscountRemoteDatasources datasources;
  AddDiscountBloc(this.datasources) : super(const _Initial()) {
    on<_AddDiscount>((event, emit) async{
      emit(const _Loading());
      final result = await datasources.addDiscount(
        event.namaDiskon,
        event.keteranganDiskon,
        event.statusDiskon,
        event.totalDiskon,
        DateTime.parse(event.mulaiDiskon),
        DateTime.parse(event.selesaiDiskon),
      );
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
