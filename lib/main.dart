import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/data/datasources/auth/remotes/auth_remote_datasources.dart';
import 'package:hrh_pos/data/datasources/local/database_local.dart';
import 'package:hrh_pos/data/datasources/remotes/discount_remote_datasources.dart';
import 'package:hrh_pos/data/datasources/remotes/order_remote_datasources_model.dart';
import 'package:hrh_pos/data/datasources/remotes/payment_remote_datasources.dart';
import 'package:hrh_pos/data/datasources/remotes/product_remote_datasources.dart';
import 'package:hrh_pos/data/datasources/remotes/tax_remote_datasources.dart';
import 'package:hrh_pos/presentation/auth/bloc/login_bloc/login_bloc.dart';
import 'package:hrh_pos/presentation/auth/bloc/logout_bloc/logout_bloc.dart';
import 'package:hrh_pos/presentation/auth/pages/login_page.dart';
import 'package:hrh_pos/presentation/home/bloc/add_order/add_order_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_discount/get_discount_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_payment/get_payment_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_product/get_product_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/get_tax/get_tax_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_discount/local_discount_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_payment/local_payment_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_product/local_product_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/local_tax/local_tax_bloc.dart';
import 'package:hrh_pos/presentation/home/bloc/order/order_bloc.dart';
import 'package:hrh_pos/presentation/home/pages/dashboard_page.dart';
import 'package:hrh_pos/presentation/report/bloc/item_sales/item_sales_bloc.dart';
import 'package:hrh_pos/presentation/report/bloc/transaction_report/transaction_report_bloc.dart';
import 'package:hrh_pos/presentation/settings/bloc/sync_all_data/sync_all_data_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasources()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasources()),
        ),
        BlocProvider(
          create: (context) => GetProductBloc(ProductRemoteDatasources()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => GetDiscountBloc(DiscountRemoteDatasources()),
        ),
        BlocProvider(
          create: (context) => GetTaxBloc(TaxRemoteDatasources()),
        ),
        BlocProvider(
          create: (context) => GetPaymentBloc(PaymentRemoteDatasources()),
        ),
        BlocProvider(
          create: (context) => AddOrderBloc(OrderRemoteDatasourcesModel()),
        ),
        // BlocProvider(
        //   create: (context) => OrderBloc(OrderRemoteDatasourcesModel()),
        // ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => LocalProductBloc(
            DatabaseLocal.instance,
          ),
        ),
        BlocProvider(
          create: (context) => LocalDiscountBloc(
            DatabaseLocal.instance,
          ),
        ),
        BlocProvider(
          create: (context) => LocalTaxBloc(
            DatabaseLocal.instance,
          ),
        ),
        BlocProvider(
          create: (context) => LocalPaymentBloc(
            DatabaseLocal.instance,
          ),
        ),
        BlocProvider(
          create: (context) => TransactionReportBloc(
            DatabaseLocal.instance,
          ),
        ),
        BlocProvider(
          create: (context) => ItemSalesBloc(
            DatabaseLocal.instance,
          ),
        ),
        BlocProvider(
          create: (context) => SyncAllDataBloc(
            productDatasource: ProductRemoteDatasources(),
            taxDatasource: TaxRemoteDatasources(),
            discountDatasource: DiscountRemoteDatasources(),
            paymentDatasource: PaymentRemoteDatasources(),
            databaseLocal: DatabaseLocal.instance,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: AuthLocalDatasources().isUserLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return const DashboardPage();
              } else {
                return const LoginPage();
              }
            }
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          },
        ),
      ),
    );
  }
}
