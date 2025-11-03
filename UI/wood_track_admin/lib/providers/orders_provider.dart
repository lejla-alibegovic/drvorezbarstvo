import 'package:wood_track_admin/models/order.dart';
import 'package:wood_track_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:wood_track_admin/utils/authorization.dart';


class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super('Orders');

  Future<bool> changeOrderStatus(int appointmentId, int status) async {
    try {

      final response = await http.get(
        Uri.parse('${BaseProvider.apiUrl}/Orders/change-status/$appointmentId/${status}'),
        headers: Authorization.createHeaders(),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('User is not authenticated');
      } else {
        throw Exception('Failed to change appointment status: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error changing appointment status: $e');
    }
  }

  @override
  Order fromJson(data) {
    return Order.fromJson(data);
  }
}