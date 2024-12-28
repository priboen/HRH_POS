import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/discount_remote_datasources.dart';

part 'delete_discount_event.dart';
part 'delete_discount_state.dart';
part 'delete_discount_bloc.freezed.dart';

class DeleteDiscountBloc extends Bloc<DeleteDiscountEvent, DeleteDiscountState> {
  final DiscountRemoteDatasources datasources;
  DeleteDiscountBloc(this.datasources) : super(const _Initial()) {
    on<_DeleteDiscount>((event, emit) async{
      final result = await datasources.deleteDiscount(event.idDiskon);
      result.fold(
        (l) => emit(_Error(l)),
        (r) {
          emit(const _Success());
          emit(const _Initial());
        }
      );
    });
  }
}
