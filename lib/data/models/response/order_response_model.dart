import 'dart:convert';

class OrderResponseModel {
    final int? status;
    final Order? data;
    final String? message;

    OrderResponseModel({
        this.status,
        this.data,
        this.message,
    });

    factory OrderResponseModel.fromJson(String str) => OrderResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderResponseModel.fromMap(Map<String, dynamic> json) => OrderResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Order.fromMap(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "message": message,
    };
}

class Order {
    final int? idUser;
    final int? idPayment;
    final int? idPajak;
    final int? idDiskon;
    final int? subTotal;
    final int? totalItem;
    final int? total;
    final int? paymentAmount;
    final int? returnPayment;
    final DateTime? transaksiTime;
    final String? layanan;
    final int? isSync;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? idOrder;

    Order({
        this.idUser,
        this.idPayment,
        this.idPajak,
        this.idDiskon,
        this.subTotal,
        this.totalItem,
        this.total,
        this.paymentAmount,
        this.returnPayment,
        this.transaksiTime,
        this.layanan,
        this.isSync,
        this.updatedAt,
        this.createdAt,
        this.idOrder,
    });

    factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Order.fromMap(Map<String, dynamic> json) => Order(
        idUser: json["id_user"],
        idPayment: json["id_payment"],
        idPajak: json["id_pajak"],
        idDiskon: json["id_diskon"],
        subTotal: json["sub_total"],
        totalItem: json["total_item"],
        total: json["total"],
        paymentAmount: json["payment_amount"],
        returnPayment: json["return_payment"],
        transaksiTime: json["transaksi_time"] == null ? null : DateTime.parse(json["transaksi_time"]),
        layanan: json["layanan"],
        isSync: json["is_sync"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        idOrder: json["id_order"],
    );

    Map<String, dynamic> toMap() => {
        "id_user": idUser,
        "id_payment": idPayment,
        "id_pajak": idPajak,
        "id_diskon": idDiskon,
        "sub_total": subTotal,
        "total_item": totalItem,
        "total": total,
        "payment_amount": paymentAmount,
        "return_payment": returnPayment,
        "transaksi_time": transaksiTime?.toIso8601String(),
        "layanan": layanan,
        "is_sync": isSync,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id_order": idOrder,
    };
}
