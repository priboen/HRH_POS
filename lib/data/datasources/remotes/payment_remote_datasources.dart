import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:hrh_pos/core/constants/variables.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/data/models/response/payment_response_model.dart';

class PaymentRemoteDatasources {
  Future<Either<String, PaymentResponseModel>> getPayments() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-payment');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      return Right(PaymentResponseModel.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }

}