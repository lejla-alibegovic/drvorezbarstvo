import 'package:wood_track_admin/models/tool.dart';
import 'package:wood_track_admin/models/user_model.dart';

class ToolOrder {
  int id;
  int toolId;
  Tool? tool;
  int quantity;
  int userId;
  UserModel? user;
  DateTime deliveryDate;

  ToolOrder({
    required this.id,
    required this.toolId,
    this.tool,
    required this.quantity,
    required this.userId,
    this.user,
    required this.deliveryDate,
  });

  factory ToolOrder.fromJson(Map<String, dynamic> json) => ToolOrder(
    id: json['id'] as int,
    toolId: json['toolId'] as int,
    tool: json['tool'] != null ? Tool.fromJson(json['tool']) : null,
    quantity: json['quantity'] as int,
    userId: json['userId'] as int,
    user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    deliveryDate: DateTime.parse(json['deliveryDate']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'toolId': toolId,
    'quantity': quantity,
    'userId': userId,
    'deliveryDate': deliveryDate.toIso8601String(),
  };
}
