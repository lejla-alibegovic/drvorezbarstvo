import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/authorization.dart';

class DashboardProvider {
  String endpoint = "Dashboard";
  String apiUrl = "";

  DashboardProvider() {
    apiUrl = dotenv.env['API_URL_DOCKER']!;
  }

  Future<Map<String, dynamic>?> getAdminData() async {
    var url = "$apiUrl/$endpoint/AdminData";
    var uri = Uri.parse(url);

    var headers = Authorization.createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
