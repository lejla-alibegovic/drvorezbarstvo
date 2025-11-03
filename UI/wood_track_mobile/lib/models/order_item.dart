import 'package:wood_track_mobile/models/product.dart';

class OrderItemModel {
  int id;
  int orderId;
  int productId;
  Product? product;
  int quantity;
  double unitPrice;
  String? notes;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.notes,
    this.product
  });

  double get totalPrice => quantity * unitPrice;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      quantity: json['quantity'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'notes': notes,
    };
  }
}
