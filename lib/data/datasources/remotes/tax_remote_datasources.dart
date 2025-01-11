import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hrh_pos/data/models/response/list_tax_response_model.dart';
import 'package:hrh_pos/data/models/response/tax_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrh_pos/core/constants/variables.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';

class TaxRemoteDatasources {
  Future<Either<String, ListTaxResponseModel>> getAllTax() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-pajak');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      return Right(ListTaxResponseModel.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }

  Future<Either<String, Tax>> addTax(
    String namaPajak,
    int pajakPersen,
  ) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-pajak');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode(
        {
          'nama_pajak': namaPajak,
          'pajak_persen': pajakPersen,
        },
      ),
    );
    if (response.statusCode == 200) {
      return Right(Tax.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }

  Future<Either<String, Tax>> editTax(
    int? id,
    String namaPajak,
    int pajakPersen,
  )async{
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-pajak/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode(
        {
          'nama_pajak': namaPajak,
          'pajak_persen': pajakPersen,
        },
      ),
    );
    if (response.statusCode == 200) {
      return Right(Tax.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }

  Future<Either<String, String>> deleteTax(int id) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-pajak/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      return const Right('Berhasil menghapus pajak');
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }
}
