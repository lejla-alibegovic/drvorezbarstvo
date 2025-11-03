import 'package:wood_track_mobile/models/order.dart';
import 'package:wood_track_mobile/utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super('ProductOrders');

  Future<bool> cancelOrder(int orderId) async {
    var uri = Uri.parse('${BaseProvider.apiUrl}/$endpoint/cancel-order/$orderId');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to change status');
    }
  }

  @override
  Order fromJson(data) {
    return Order.fromJson(data);
  }
}