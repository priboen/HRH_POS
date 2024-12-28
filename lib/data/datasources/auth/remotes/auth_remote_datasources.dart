import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:http/http.dart' as http;
import 'package:hrh_pos/core/constants/variables.dart';
import 'package:hrh_pos/data/models/response/auth_response_model.dart';

class AuthRemoteDatasources {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final url = Uri.parse('${Variables.baseUrl}/api/login');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }

  Future<Either<String, bool>> logout() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/logout');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      await AuthLocalDatasources().removeAuthData();
      return const Right(true);
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }
}
