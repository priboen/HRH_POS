import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hrh_pos/core/constants/variables.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/data/models/request/order_request_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDatasourcesModel {
  Future<Either<String, OrderRequestModel>> saveOrder(
      OrderRequestModel data) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/save-order');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: data.toJson(),
    );
    if (response.statusCode == 200) {
      return Right(OrderRequestModel.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }
}
