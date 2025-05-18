import 'dart:convert';

class ProductResponseModel {
  final int? status;
  final List<Product>? data;
  final String? message;

  ProductResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Product>.from(json["data"]!.map((x) => Product.fromMap(x))),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "message": message,
      };
}

class Product {
  final int? idProduct;
  final int? idCategory;
  final String? nameProduct;
  final String? description;
  final String? image;
  final String? price;
  final int? stock;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProductCategory? category;

  Product({
    this.idProduct,
    this.idCategory,
    this.nameProduct,
    this.description,
    this.image,
    this.price,
    this.stock,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        idProduct: json["id_product"],
        idCategory: json["id_category"],
        nameProduct: json["name_product"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        stock: json["stock"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        category: json["category"] == null
            ? null
            : ProductCategory.fromMap(json["category"]),
      );

  factory Product.fromOrderMap(Map<String, dynamic> json) => Product(
        idProduct: json["id_product"],
        price: json["price"].toString(),
      );

  factory Product.fromLocalMap(Map<String, dynamic> json) => Product(
      idProduct: json["id"],
      idCategory: json["id_category"],
      nameProduct: json["name_product"],
      description: json["description"],
      image: json["image"],
      price: json["price"],
      stock: json["stock"],
      status: json["status"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      category: ProductCategory(
          idCategory: json["id_category"], name: json["name_category"]));

  Map<String, dynamic> toLocalMap() => {
        "id": idProduct,
        "id_category": idCategory,
        "name_category": category?.name,
        "name_product": nameProduct,
        "description": description,
        "image": image,
        "price": price,
        "stock": stock,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  Map<String, dynamic> toMap() => {
        "id_product": idProduct,
        "id_category": idCategory,
        "name_product": nameProduct,
        "description": description,
        "image": image,
        "price": price,
        "stock": stock,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category": category?.toMap(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.idProduct == idProduct &&
        other.idCategory == idCategory &&
        other.nameProduct == nameProduct &&
        other.description == description &&
        other.image == image &&
        other.price == price &&
        other.stock == stock &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.category == category;
  }

  @override
  int get hashCode {
    return idProduct.hashCode ^
        idCategory.hashCode ^
        nameProduct.hashCode ^
        description.hashCode ^
        image.hashCode ^
        price.hashCode ^
        stock.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        category.hashCode;
  }
}

class ProductCategory {
  final int? idCategory;
  final String? name;
  final String? discription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductCategory({
    this.idCategory,
    this.name,
    this.discription,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductCategory.fromJson(String str) =>
      ProductCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductCategory.fromMap(Map<String, dynamic> json) => ProductCategory(
        idCategory: json["id_category"],
        name: json["name"],
        discription: json["discription"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  factory ProductCategory.fromProductMap(Map<String, dynamic> json) =>
      ProductCategory(
        idCategory: json["id_category"],
        name: json["name"],
      );

  factory ProductCategory.fromLocalMap(Map<String, dynamic> json) =>
      ProductCategory(
        idCategory: json["id"],
        name: json["name"],
        discription: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toLocalMap() => {
        "id": idCategory,
        "name": name,
        "description": discription,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
  Map<String, dynamic> toMap() => {
        "id_category": idCategory,
        "name": name,
        "discription": discription,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductCategory &&
        other.idCategory == idCategory &&
        other.name == name &&
        other.discription == discription &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return idCategory.hashCode ^
        name.hashCode ^
        discription.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
