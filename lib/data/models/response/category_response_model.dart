// import 'dart:convert';

// import 'package:hrh_pos/presentation/home/models/category_model.dart';

// class CategoryResponseModel {
//   final int? status;
//   final List<ProductCategory>? data;
//   final String? message;

//   CategoryResponseModel({
//     this.status,
//     this.data,
//     this.message,
//   });

//   factory CategoryResponseModel.fromJson(String str) =>
//       CategoryResponseModel.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory CategoryResponseModel.fromMap(Map<String, dynamic> json) =>
//       CategoryResponseModel(
//         status: json["status"],
//         data: json["data"] == null
//             ? []
//             : List<ProductCategory>.from(
//                 json["data"]!.map((x) => ProductCategory.fromMap(x))),
//         message: json["message"],
//       );

//   Map<String, dynamic> toMap() => {
//         "status": status,
//         "data":
//             data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
//         "message": message,
//       };
// }
