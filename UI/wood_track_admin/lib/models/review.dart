import 'package:wood_track_admin/models/product.dart';
import 'package:wood_track_admin/models/user_model.dart';

class Review {
  final int id;
  final int clientId;
  final UserModel? client;
  final int? productId;
  final Product? product;
  final int rating;
  final String? comment;
  final DateTime? dateCreated;

  Review({
    required this.id,
    required this.clientId,
    this.client,
    this.productId,
    this.product,
    required this.rating,
    this.comment,
    this.dateCreated
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as int,
    clientId: json['clientId'] as int,
    client: json['client'] != null ? UserModel.fromJson(json['client']) : null,
    productId: json['productId'] as int?,
    product: json['product'] != null ? Product.fromJson(json['product']) : null,
    rating: json['rating'] as int,
    comment: json['comment'] as String?,
    dateCreated: json['dateCreated'] != null ? DateTime.parse(json['dateCreated']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientId': clientId,
    'productId': productId,
    'rating': rating,
    'comment': comment,
  };
}
