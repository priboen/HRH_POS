import 'dart:convert';

class TaxResponseModel {
    final int? status;
    final Tax? data;
    final String? message;

    TaxResponseModel({
        this.status,
        this.data,
        this.message,
    });

    factory TaxResponseModel.fromJson(String str) => TaxResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TaxResponseModel.fromMap(Map<String, dynamic> json) => TaxResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Tax.fromMap(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
        "message": message,
    };
}

class Tax {
    final String? namaPajak;
    final int? pajakPersen;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? idPajak;

    Tax({
        this.namaPajak,
        this.pajakPersen,
        this.updatedAt,
        this.createdAt,
        this.idPajak,
    });

    factory Tax.fromJson(String str) => Tax.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Tax.fromMap(Map<String, dynamic> json) => Tax(
        namaPajak: json["nama_pajak"],
        pajakPersen: json["pajak_persen"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        idPajak: json["id_pajak"],
    );

    Map<String, dynamic> toMap() => {
        "nama_pajak": namaPajak,
        "pajak_persen": pajakPersen,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id_pajak": idPajak,
    };
}
