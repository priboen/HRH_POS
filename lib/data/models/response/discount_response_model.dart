import 'dart:convert';

class DiscountResponseModel {
    final int? status;
    final Discount? data;
    final String? message;

    DiscountResponseModel({
        this.status,
        this.data,
        this.message,
    });

    factory DiscountResponseModel.fromJson(String str) => DiscountResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DiscountResponseModel.fromMap(Map<String, dynamic> json) => DiscountResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Discount.fromMap(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "message": message,
    };
}

class Discount {
    final String? namaDiskon;
    final String? keterangan;
    final int? status;
    final int? diskonPersen;
    final DateTime? tanggalMulai;
    final DateTime? tanggalSelesai;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? idDiskon;

    Discount({
        this.namaDiskon,
        this.keterangan,
        this.status,
        this.diskonPersen,
        this.tanggalMulai,
        this.tanggalSelesai,
        this.updatedAt,
        this.createdAt,
        this.idDiskon,
    });

    factory Discount.fromJson(String str) => Discount.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Discount.fromMap(Map<String, dynamic> json) => Discount(
        namaDiskon: json["nama_diskon"],
        keterangan: json["keterangan"],
        status: json["status"],
        diskonPersen: json["diskon_persen"],
        tanggalMulai: json["tanggal_mulai"] == null ? null : DateTime.parse(json["tanggal_mulai"]),
        tanggalSelesai: json["tanggal_selesai"] == null ? null : DateTime.parse(json["tanggal_selesai"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        idDiskon: json["id_diskon"],
    );

    Map<String, dynamic> toMap() => {
        "nama_diskon": namaDiskon,
        "keterangan": keterangan,
        "status": status,
        "diskon_persen": diskonPersen,
        "tanggal_mulai": tanggalMulai?.toIso8601String(),
        "tanggal_selesai": tanggalSelesai?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id_diskon": idDiskon,
    };
}
