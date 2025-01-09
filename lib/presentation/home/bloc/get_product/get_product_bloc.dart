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
    on<_SearchProduct>((event, emit) async {
      if (event.query.isEmpty) {
        add(const GetProductEvent.getProduct());
      } else {
        final currentState = state;
        if (currentState is _Loaded) {
          final filteredProducts =
              searchProduct(currentState.products, event.query);
          emit(_Loaded(filteredProducts));
        }
      }
    });
  }

  List<Category> extractCategoriesFromProducts(List<Product> products) {
    final uniqueCategories = <Category>{};
    for (var product in products) {
      if (product.category != null) {
        uniqueCategories.add(product.category!);
      }
    }
    return uniqueCategories.toList();
  }

  //search product
  List<Product> searchProduct(List<Product> products, String query) {
    return products
        .where((element) =>
            element.nameProduct!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
