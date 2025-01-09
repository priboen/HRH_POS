import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/models/response/discount_response_model.dart';
import 'package:hrh_pos/data/models/response/product_response_model.dart';
import 'package:hrh_pos/data/models/response/tax_response_model.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const _Loaded([], null, null)) {
    // on<_Started>((event, emit) {
    //   emit(const CheckoutState.initial());
    // });

    // on<_AddItem>((event, emit) {
    //   final currentState = state;

    //   if (currentState is _Loaded) {
    //     final quantities = Map<int, int>.from(currentState.quantities);
    //     final products = List<Product>.from(currentState.products);

    //     if (quantities.containsKey(event.product.idProduct)) {
    //       // Tambahkan kuantitas produk yang sudah ada
    //       quantities[event.product.idProduct!] = (quantities[event.product.idProduct] ?? 0) + 1;
    //     } else {
    //       // Tambahkan produk baru
    //       quantities[event.product.idProduct!] = 1;
    //       products.add(event.product);
    //     }

    //     emit(CheckoutState.loaded(quantities, products));
    //   } else {
    //     // State awal, tambahkan produk pertama
    //     emit(CheckoutState.loaded({event.product.idProduct!: 1}, [event.product]));
    //   }
    // });

    // on<_RemoveItem>((event, emit) {
    //   final currentState = state;

    //   if (currentState is _Loaded) {
    //     final quantities = Map<int, int>.from(currentState.quantities);
    //     final products = List<Product>.from(currentState.products);

    //     if (quantities.containsKey(event.product.idProduct)) {
    //       final currentQuantity = quantities[event.product.idProduct] ?? 0;

    //       if (currentQuantity > 1) {
    //         // Kurangi kuantitas produk
    //         quantities[event.product.idProduct!] = currentQuantity - 1;
    //       } else {
    //         // Hapus produk jika kuantitas menjadi 0
    //         quantities.remove(event.product.idProduct);
    //         products.removeWhere((p) => p.idProduct == event.product.idProduct);
    //       }

    //       emit(CheckoutState.loaded(quantities, products));
    //     }
    //   }
    // });

    on<_AddItem>((event, emit) {
      // TODO: implement event handler
      var currentState = state as _Loaded;
      List<ProductQuantity> items = [...currentState.items];
      var index = items.indexWhere(
          (element) => element.product.idProduct == event.product.idProduct);
      emit(const _Loading());
      if (index != -1) {
        items[index] = ProductQuantity(
            product: event.product, quantity: items[index].quantity + 1);
      } else {
        items.add(ProductQuantity(product: event.product, quantity: 1));
      }
      emit(_Loaded(items, currentState.discount, currentState.tax));
    });

    on<_RemoveItem>((event, emit) {
      // TODO: implement event handler
      var currentState = state as _Loaded;
      List<ProductQuantity> items = [...currentState.items];
      var index = items.indexWhere(
          (element) => element.product.idProduct == event.product.idProduct);
      emit(const _Loading());
      if (index != -1) {
        if (items[index].quantity > 1) {
          items[index] = ProductQuantity(
              product: event.product, quantity: items[index].quantity - 1);
        } else {
          items.removeAt(index);
        }
      }
      emit(_Loaded(items, currentState.discount, currentState.tax));
    });

    on<_Started>(
      (event, emit) {
        emit(const _Loaded([], null, null));
      },
    );

    on<_AddDiscount>(
      (event, emit) {
        var currentState = state as _Loaded;
        emit(_Loaded(currentState.items, event.discount, currentState.tax));
      },
    );
    on<_RemoveDiscount>((event, emit) {
      // TODO: implement event handler
      var currentState = state as _Loaded;
      emit(_Loaded(currentState.items, null, currentState.tax));
    });

    on<_AddTax>((event, emit) {
      // TODO: implement event handler
      var currentState = state as _Loaded;
      emit(_Loaded(currentState.items, currentState.discount, event.tax));
    });
  }
}
