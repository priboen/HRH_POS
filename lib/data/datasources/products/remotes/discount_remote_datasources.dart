import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hrh_pos/data/models/response/discount_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrh_pos/core/constants/variables.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/data/models/response/list_discount_response_model.dart';

class DiscountRemoteDatasources {
  Future<Either<String, ListDiscountResponseModel>> getAllDiscount() async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-diskon');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      return Right(ListDiscountResponseModel.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }

  // Future<Either<String, DiscountResponseModel>> getDiscountById(int id) async {
  //   final authData = await AuthLocalDatasources().getAuthData();
  //   final url = Uri.parse('${Variables.baseUrl}/api/api-diskon/$id');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer ${authData.token}',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return Right(DiscountResponseModel.fromJson(response.body));
  //   } else {
  //     return Left(
  //         jsonDecode(response.body)['message'] ?? 'Failed to process request');
  //   }
  // }

  Future<Either<String, Discount>> addDiscount(
      String namaDiskon,
      String keterangan,
      bool status,
      int diskonPersen,
      DateTime tanggalMulai,
      DateTime tanggalSelesai) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-diskon');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode(
        {
          'nama_diskon': namaDiskon,
          'keterangan': keterangan,
          'status': status,
          'diskon_persen': diskonPersen,
          'tanggal_mulai': tanggalMulai.toIso8601String(),
          'tanggal_selesai': tanggalSelesai.toIso8601String(),
        },
      ),
    );
    if (response.statusCode == 200) {
      return Right(Discount.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer ${authData?.token}'
    // };
  }

  Future<Either<String, Discount>> editDiscount(
    int? id,
    String namaDiskon,
    String keterangan,
    bool status,
    int diskonPersen,
    DateTime tanggalMulai,
    DateTime tanggalSelesai,
  ) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-diskon/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode(
        {
          'nama_diskon': namaDiskon,
          'keterangan': keterangan,
          'status': status,
          'diskon_persen': diskonPersen,
          'tanggal_mulai': tanggalMulai.toIso8601String(),
          'tanggal_selesai': tanggalSelesai.toIso8601String(),
        },
      ),
    );
    if (response.statusCode == 200) {
      return Right(Discount.fromJson(response.body));
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }

  Future<Either<String, String>> deleteDiscount(int id) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-diskon/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      return const Right('Diskon berhasil dihapus');
    } else {
      return Left(
          jsonDecode(response.body)['message'] ?? 'Failed to process request');
    }
  }
}
