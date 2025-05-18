import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hrh_pos/presentation/home/models/product_quantity.dart';

class OrderModel {
  final int? id;
  final int? idKasir;
  final String layanan;
  final int idPembayaran;
  final int? idPajak;
  final int? pajakPersen;
  final int? totalPajak;
  final int? idDiskon;
  final int? diskonPersen;
  final int? totalDiskon;
  final int subtotal;
  final int totalItem;
  final int total;
  final int totalPembayaran;
  final int kembalian;
  final String namaKasir;
  final String tglTransaksi;
  final int isSync;
  final List<ProductQuantity> orderItems;

  OrderModel({
    this.id,
    required this.idKasir,
    required this.layanan,
    required this.idPembayaran,
    required this.idPajak,
    this.pajakPersen,
    this.totalDiskon,
    required this.idDiskon,
    this.diskonPersen,
    this.totalPajak,
    required this.subtotal,
    required this.totalItem,
    required this.total,
    required this.totalPembayaran,
    required this.kembalian,
    required this.namaKasir,
    required this.tglTransaksi,
    required this.isSync,
    required this.orderItems,
  });

  Map<String, dynamic> toServerMap() {
    return {
      "id_user": idKasir,
      "layanan": layanan,
      "id_payment": idPembayaran,
      "id_pajak": idPajak,
      "id_diskon": idDiskon,
      "sub_total": subtotal,
      "total_item": totalItem,
      "total": total,
      "payment_amount": totalPembayaran,
      "return_payment": kembalian,
      "transaksi_time": tglTransaksi,
      "order_items": orderItems.map((item) => item.toLocalMap(id!)).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "id_order": id,
      "id_user": idKasir,
      "nama_kasir": namaKasir,
      "layanan": layanan,
      "id_payment": idPembayaran,
      "id_pajak": idPajak,
      "pajak_persen": pajakPersen,
      "total_pajak": totalPajak,
      "id_diskon": idDiskon,
      "diskon_persen": diskonPersen,
      "total_diskon": totalDiskon,
      "sub_total": subtotal,
      "total_item": totalItem,
      "total": total,
      "payment_amount": totalPembayaran,
      "return_payment": kembalian,
      "transaksi_time": tglTransaksi,
      "is_sync": isSync,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id_order']?.toInt(),
      idKasir: map['id_user']?.toInt() ?? 0,
      layanan: map['layanan'] ?? '',
      idPembayaran: map['id_payment']?.toInt() ?? 0,
      idPajak: map['id_pajak']?.toInt() ?? 0,
      pajakPersen: map['pajak_persen']?.toInt() ?? 0,
      diskonPersen: map['diskon_persen']?.toInt() ?? 0,
      totalDiskon: map['total_diskon']?.toInt() ?? 0,
      totalPajak: map['total_pajak']?.toInt() ?? 0,
      idDiskon: map['id_diskon']?.toInt() ?? 0,
      subtotal: map['sub_total']?.toInt() ?? 0,
      totalItem: map['total_item']?.toInt() ?? 0,
      total: map['total']?.toInt() ?? 0,
      totalPembayaran: map['payment_amount']?.toInt() ?? 0,
      kembalian: map['return_payment']?.toInt() ?? 0,
      namaKasir: map['nama_kasir'] ?? '',
      tglTransaksi: map['transaksi_time'] ?? '',
      isSync: map['is_sync']?.toInt() ?? 0,
      orderItems: [],
    );
  }

  String toJson() => json.encode(toServerMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  OrderModel copyWith({
    ValueGetter<int?>? id,
    int? idKasir,
    String? layanan,
    int? idPembayaran,
    int? idPajak,
    int? idDiskon,
    int? subtotal,
    int? totalItem,
    int? total,
    int? totalPembayaran,
    int? kembalian,
    String? namaKasir,
    String? tglTransaksi,
    int? isSync,
    List<ProductQuantity>? orderItems,
  }) {
    return OrderModel(
      id: id != null ? id() : this.id,
      idKasir: idKasir ?? this.idKasir,
      layanan: layanan ?? this.layanan,
      idPembayaran: idPembayaran ?? this.idPembayaran,
      idPajak: idPajak ?? this.idPajak,
      idDiskon: idDiskon ?? this.idDiskon,
      subtotal: subtotal ?? this.subtotal,
      totalItem: totalItem ?? this.totalItem,
      total: total ?? this.total,
      totalPembayaran: totalPembayaran ?? this.totalPembayaran,
      kembalian: kembalian ?? this.kembalian,
      namaKasir: namaKasir ?? this.namaKasir,
      tglTransaksi: tglTransaksi ?? this.tglTransaksi,
      isSync: isSync ?? this.isSync,
      orderItems: orderItems ?? this.orderItems,
    );
  }
}
