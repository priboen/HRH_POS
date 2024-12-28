import 'dart:convert';

import 'package:hrh_pos/data/models/response/discount_response_model.dart';

class ListDiscountResponseModel {
    final int? status;
    final List<Discount>? data;
    final String? message;

    ListDiscountResponseModel({
        this.status,
        this.data,
        this.message,
    });

    factory ListDiscountResponseModel.fromJson(String str) => ListDiscountResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ListDiscountResponseModel.fromMap(Map<String, dynamic> json) => ListDiscountResponseModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Discount>.from(json["data"]!.map((x) => Discount.fromMap(x))),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "message": message,
    };
}