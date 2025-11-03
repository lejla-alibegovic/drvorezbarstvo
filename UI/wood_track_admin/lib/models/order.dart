import 'package:wood_track_admin/helpers/json_helper.dart';
import 'package:wood_track_admin/models/order_item.dart';

class Order {
  int id;
  int customerId;
  String? transactionId;
  String? fullName;
  String? address;
  String? phoneNumber;
  String? note;
  double totalAmount;
  int? status;
  DateTime? date;
  List<OrderItemModel> items;

  Order({
    required this.id,
    required this.customerId,
    this.transactionId,
    this.fullName,
    this.address,
    this.phoneNumber,
    this.note,
    required this.totalAmount,
    this.status,
    this.date,
    List<OrderItemModel>? items,
  })  : items = items ?? [];

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      transactionId: json['transactionId'],
      fullName: json['fullName'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      note: json['note'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    var obj = {
      'id': id,
      'customerId': customerId,
      'transactionId': transactionId,
      'fullName': fullName,
      'address': address,
      'phoneNumber': phoneNumber,
      'note': note,
      'totalAmount': totalAmount,
      'date': date?.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };

    if (status != null){
      obj['status'] = status;
    }

    if (note != null){
      obj['note'] = note;
    }

    return obj;
  }
}
