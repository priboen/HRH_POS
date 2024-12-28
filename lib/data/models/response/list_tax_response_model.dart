import 'dart:convert';

import 'package:hrh_pos/data/models/response/tax_response_model.dart';

class ListTaxResponseModel {
    final int? status;
    final List<Tax>? data;
    final String? message;

    ListTaxResponseModel({
        this.status,
        this.data,
        this.message,
    });

    factory ListTaxResponseModel.fromJson(String str) => ListTaxResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ListTaxResponseModel.fromMap(Map<String, dynamic> json) => ListTaxResponseModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Tax>.from(json["data"]!.map((x) => Tax.fromMap(x))),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "message": message,
    };
}