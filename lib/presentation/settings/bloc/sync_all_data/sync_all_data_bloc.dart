import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/local/database_local.dart';
import 'package:hrh_pos/data/datasources/remotes/discount_remote_datasources.dart';
import 'package:hrh_pos/data/datasources/remotes/payment_remote_datasources.dart';
import 'package:hrh_pos/data/datasources/remotes/product_remote_datasources.dart';
import 'package:hrh_pos/data/datasources/remotes/tax_remote_datasources.dart';
import 'package:hrh_pos/data/models/response/list_discount_response_model.dart';
import 'package:hrh_pos/data/models/response/list_tax_response_model.dart';
import 'package:hrh_pos/data/models/response/payment_response_model.dart';
import 'package:hrh_pos/data/models/response/product_response_model.dart';

part 'sync_all_data_event.dart';
part 'sync_all_data_state.dart';
part 'sync_all_data_bloc.freezed.dart';

class SyncAllDataBloc extends Bloc<SyncAllDataEvent, SyncAllDataState> {
  final ProductRemoteDatasources productDatasource;
  final TaxRemoteDatasources taxDatasource;
  final DiscountRemoteDatasources discountDatasource;
  final PaymentRemoteDatasources paymentDatasource;
  final DatabaseLocal databaseLocal;
  SyncAllDataBloc({
    required this.productDatasource,
    required this.taxDatasource,
    required this.discountDatasource,
    required this.paymentDatasource,
    required this.databaseLocal,
  }) : super(const _Initial()) {
    on<_SyncAllData>((event, emit) async {
      await event.when(
        started: () async {
          emit(const SyncAllDataState.initial());
        },
        syncAllData: () async {
          emit(const SyncAllDataState.loading());
          try {
            final productResult = await productDatasource.getProduct();
            final taxResult = await taxDatasource.getAllTax();
            final discountResult = await discountDatasource.getAllDiscount();
            final paymentResult = await paymentDatasource.getPayments();

            // 2. Handle errors if any request fails
            final errors = <String>[];
            productResult.fold((error) => errors.add(error), (_) {});
            discountResult.fold((error) => errors.add(error), (_) {});
            taxResult.fold((error) => errors.add(error), (_) {});
            paymentResult.fold((error) => errors.add(error), (_) {});

            if (errors.isNotEmpty) {
              emit(SyncAllDataState.error(errors.join(', ')));
              return;
            }

            // 3. Save data to local database
            final productData = productResult
                .getOrElse(() => throw Exception('No product data'));
            // final taxData =
            //     taxResult.getOrElse(() => throw Exception('No tax data'));
            final discountData = discountResult
                .getOrElse(() => throw Exception('No discount data'));
            final taxData =
                taxResult.getOrElse(() => throw Exception('No tax data'));
            final paymentData = paymentResult
                .getOrElse(() => throw Exception('No payment data'));

            await databaseLocal.deleteAllProduct();
            await databaseLocal.insertProducts(productData.data!);

            await databaseLocal.deleteAllDiscount();
            await databaseLocal.insertDiscount(discountData.data!);

            await databaseLocal.deleteAllTax();
            await databaseLocal.insertTax(taxData.data!);

            await databaseLocal.deleteAllPayment();
            await databaseLocal.insertPayment(paymentData.data!);

            // 4. Emit success state
            emit(SyncAllDataState.success(
              productData,
              discountData,
              taxData,
              paymentData,
            ));
          } catch (e) {
            emit(SyncAllDataState.error(e.toString()));
          }
        },
      );
    });
  }
}
