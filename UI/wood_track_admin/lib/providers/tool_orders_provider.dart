import 'dart:convert';

import 'package:wood_track_admin/models/tool_order.dart';
import 'package:wood_track_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:wood_track_admin/utils/authorization.dart';


class ToolOrderProvider extends BaseProvider<ToolOrder> {
  ToolOrderProvider() : super('ToolOrders');


  Future<void> sendOrderEmail(Map<String, dynamic> formData) async {
    var request = await http.MultipartRequest('POST', Uri.parse('${BaseProvider.apiUrl}/ToolOrders/send-email'));

    request.headers.addAll(Authorization.createHeaders(formData: true));

    formData.forEach((key, value) {
      if (value is List) {
        request.fields[key] = jsonEncode(value);
      } else {
        request.fields[key] = value.toString();
      }
    });

    if (formData.containsKey('file')) {
      request.files.add(formData['file']);
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to send email');
    }
  }

  @override
  ToolOrder fromJson(data) {
    return ToolOrder.fromJson(data);
  }
}