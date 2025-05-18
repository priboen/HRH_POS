import 'dart:convert';

class OrderRequestModel {
    final int? idUser;
    final String? layanan;
    final int? idPayment;
    final int? idPajak;
    final int? idDiskon;
    final int? subTotal;
    final int? totalItem;
    final int? total;
    final int? paymentAmount;
    final int? returnPayment;
    final DateTime? transaksiTime;
    final bool isSync;
    final List<OrderItem>? orderItems;

    OrderRequestModel({
        this.idUser,
        this.layanan,
        this.idPayment,
        this.idPajak,
        this.idDiskon,
        this.subTotal,
        this.totalItem,
        this.total,
        this.paymentAmount,
        this.returnPayment,
        this.transaksiTime,
        required this.isSync,
        this.orderItems,
    });

    factory OrderRequestModel.fromJson(String str) => OrderRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderRequestModel.fromMap(Map<String, dynamic> json) => OrderRequestModel(
        idUser: json["id_user"],
        layanan: json["layanan"],
        idPayment: json["id_payment"],
        idPajak: json["id_pajak"],
        idDiskon: json["id_diskon"],
        subTotal: json["sub_total"],
        totalItem: json["total_item"],
        total: json["total"],
        paymentAmount: json["payment_amount"],
        returnPayment: json["return_payment"],
        transaksiTime: json["transaksi_time"] == null ? null : DateTime.parse(json["transaksi_time"]),
        isSync: json["is_sync"],
        orderItems: json["order_items"] == null ? [] : List<OrderItem>.from(json["order_items"]!.map((x) => OrderItem.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id_user": idUser,
        "layanan": layanan,
        "id_payment": idPayment,
        "id_pajak": idPajak,
        "id_diskon": idDiskon,
        "sub_total": subTotal,
        "total_item": totalItem,
        "total": total,
        "payment_amount": paymentAmount,
        "return_payment": returnPayment,
        "transaksi_time": transaksiTime?.toIso8601String(),
        "is_sync": isSync,
        "order_items": orderItems == null ? [] : List<dynamic>.from(orderItems!.map((x) => x.toMap())),
    };
}

class OrderItem {
    final int? idProduct;
    final int? quantity;
    final int? total;

    OrderItem({
        this.idProduct,
        this.quantity,
        this.total,
    });

    factory OrderItem.fromJson(String str) => OrderItem.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderItem.fromMap(Map<String, dynamic> json) => OrderItem(
        idProduct: json["id_product"],
        quantity: json["quantity"],
        total: json["total"],
    );

    Map<String, dynamic> toMap() => {
        "id_product": idProduct,
        "quantity": quantity,
        "total": total,
    };
}
