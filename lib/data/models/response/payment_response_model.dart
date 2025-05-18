import 'dart:convert';

class PaymentResponseModel {
    final int? status;
    final List<Payment>? data;
    final String? message;

    PaymentResponseModel({
        this.status,
        this.data,
        this.message,
    });

    factory PaymentResponseModel.fromJson(String str) => PaymentResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PaymentResponseModel.fromMap(Map<String, dynamic> json) => PaymentResponseModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Payment>.from(json["data"]!.map((x) => Payment.fromMap(x))),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "message": message,
    };
}

class Payment {
    final int? idPayment;
    final String? namaPayment;
    final String? imagePayment;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Payment({
        this.idPayment,
        this.namaPayment,
        this.imagePayment,
        this.createdAt,
        this.updatedAt,
    });

    factory Payment.fromJson(String str) => Payment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Payment.fromMap(Map<String, dynamic> json) => Payment(
        idPayment: json["id_payment"],
        namaPayment: json["nama_payment"],
        imagePayment: json["image_payment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

        factory Payment.fromLocalMap(Map<String, dynamic> json) => Payment(
        idPayment: json["id_payment"],
        namaPayment: json["nama_payment"],
        imagePayment: json["image_payment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

        Map<String, dynamic> toLocalMap() => {
        "id_payment": idPayment,
        "nama_payment": namaPayment,
        "image_payment": imagePayment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };

    Map<String, dynamic> toMap() => {
        "id_payment": idPayment,
        "nama_payment": namaPayment,
        "image_payment": imagePayment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
