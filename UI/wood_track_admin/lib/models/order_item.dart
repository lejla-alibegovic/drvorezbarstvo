import 'package:wood_track_admin/helpers/json_helper.dart';
import 'package:wood_track_admin/models/product.dart';

class OrderItemModel {
  int id;
  int orderId;
  int productId;
  Product? product;
  double quantity;
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
      quantity: JsonHelper.toDouble(json['quantity']),
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      unitPrice: JsonHelper.toDouble(json['unitPrice']),
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
