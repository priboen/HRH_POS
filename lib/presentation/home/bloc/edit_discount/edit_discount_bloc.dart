import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/discount_remote_datasources.dart';

part 'edit_discount_event.dart';
part 'edit_discount_state.dart';
part 'edit_discount_bloc.freezed.dart';

class EditDiscountBloc extends Bloc<EditDiscountEvent, EditDiscountState> {
  final DiscountRemoteDatasources datasources;
  EditDiscountBloc(this.datasources) : super(const _Initial()) {
    on<_EditDiscount>((event, emit) async {
      emit(const _Loading());
      final result = await datasources.editDiscount(
        event.idDiskon,
        event.namaDiskon,
        event.keteranganDiskon,
        event.statusDiskon,
        event.totalDiskon,
        DateTime.parse(event.mulaiDiskon),
        DateTime.parse(event.selesaiDiskon),
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
