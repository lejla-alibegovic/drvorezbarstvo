import 'package:wood_track_mobile/models/review.dart';

import 'product_category.dart';

class Product {
  int id;
  String name;
  String description;
  double price;
  int stock;
  String imageUrl;
  bool isEnable;
  String? manufacturer;
  String? barcode;
  int productCategoryId;
  ProductCategory? productCategory;
  double width;
  double height;
  double length;
  List<Review> reviews = [];

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.isEnable,
    required this.width,
    required this.height,
    required this.length,
    this.manufacturer,
    this.barcode,
    required this.productCategoryId,
    this.productCategory,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      imageUrl: json['imageUrl'],
      isEnable: json['isEnable'],
      manufacturer: json['manufacturer'],
      width: json['width'],
      height: json['height'],
      length: json['length'],
      barcode: json['barcode'],
      productCategoryId: json['productCategoryId'],
      productCategory: json['productCategory'] != null ?  ProductCategory.fromJson(json['productCategory']) : null,
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => Review.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'stock': stock,
    'imageUrl': imageUrl,
    'isEnable': isEnable,
    'manufacturer': manufacturer,
    'barcode': barcode,
    'productCategoryId': productCategoryId,
    'productCategory': productCategory?.toJson(),
  };
}