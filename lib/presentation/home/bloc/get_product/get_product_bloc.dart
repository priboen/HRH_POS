import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/remotes/product_remote_datasources.dart';
import 'package:hrh_pos/data/models/response/product_response_model.dart';

part 'get_product_event.dart';
part 'get_product_state.dart';
part 'get_product_bloc.freezed.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final ProductRemoteDatasources datasources;
  GetProductBloc(this.datasources) : super(const _Initial()) {
    on<_GetProduct>(
      (event, emit) async {
        emit(const _Loading());
        final result = await datasources.getProduct();
        result.fold(
          (l) => emit(_Error(l)),
          (r) => emit(_Loaded((r.data as List<Product>))),
        );
      },
    );
  }
}
