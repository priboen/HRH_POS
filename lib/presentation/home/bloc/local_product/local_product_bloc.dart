import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/products/local/product_local_datasources.dart';
import 'package:hrh_pos/data/models/response/product_response_model.dart';
import 'package:hrh_pos/presentation/home/models/category_model.dart';
import 'package:hrh_pos/presentation/home/models/product_model.dart';

part 'local_product_event.dart';
part 'local_product_state.dart';
part 'local_product_bloc.freezed.dart';

class LocalProductBloc extends Bloc<LocalProductEvent, LocalProductState> {
  final ProductLocalDatasources datasources;
  LocalProductBloc(this.datasources) : super(const _Initial()) {
    on<_GetProducts>((event, emit) async {
      emit(const _Loading());
      final result = await datasources.getProducts();
      emit(_Loaded(products: result));
    });
    on<_SearchProduct>((event, emit) async {
      if (event.query.isEmpty) {
        add(const LocalProductEvent.getProducts());
      } else {
        final currentState = state;
        if (currentState is _Loaded) {
          final filteredProducts =
              searchProduct(currentState.products, event.query);
          emit(
            _Loaded(products: filteredProducts),
          );
        }
      }
    });
  }

  List<String?> extractCategoriesFromProducts(List<Product> products) {
    final categories = products
        .map((product) => product.category?.name) // Ambil nama kategori
        .where((name) => name != null) // Hilangkan kategori yang null
        .toSet(); // Pastikan tidak ada duplikasi
    return categories.toList();
  }

  List<Product> searchProduct(List<Product> products, String query) {
    return products
        .where((element) =>
            element.nameProduct!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
