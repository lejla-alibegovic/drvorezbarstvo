import 'package:wood_track_mobile/models/product.dart';
import 'package:wood_track_mobile/providers/base_provider.dart';
import 'package:wood_track_mobile/utils/authorization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationProvider extends BaseProvider<Product> {
  RecommendationProvider() : super('Recommendations');

  Future<List<Product>> getRecommendations({int topN = 4}) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseProvider.apiUrl}/Recommendations/${Authorization.id}/${topN}'),
        headers: Authorization.createHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => fromJson(item)).toList();
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}