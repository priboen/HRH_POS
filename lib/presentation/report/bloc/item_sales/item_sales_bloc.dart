import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/local/database_local.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';

part 'item_sales_event.dart';
part 'item_sales_state.dart';
part 'item_sales_bloc.freezed.dart';

class ItemSalesBloc extends Bloc<ItemSalesEvent, ItemSalesState> {
  final DatabaseLocal datasource;
  ItemSalesBloc(this.datasource) : super(const _Initial()) {
    on<_GetReport>(
      (event, emit) async {
        emit(const _Loading());
        final result = await datasource.getItemOrder(
          event.startDate,
          event.endDate,
        );
        emit(_Loaded(result));
      },
    );
  }
}
