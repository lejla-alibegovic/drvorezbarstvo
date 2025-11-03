import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../utils/authorization.dart';

class ReportsProvider with ChangeNotifier {
  static String apiUrl = "";
  final Dio _dio = Dio();

  ReportsProvider() {
    apiUrl = dotenv.env['API_URL_DOCKER']!;
  }

  Future<Uint8List> downloadClientsReport({
    String? searchFilter,
    bool? isClient,
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/reports/clients').replace(
        queryParameters: {
          if (searchFilter != null) 'SearchFilter': searchFilter,
          if (isClient != null) 'IsClient': isClient.toString(),
          if (pageNumber != null) 'PageNumber': pageNumber.toString(),
          if (pageSize != null) 'PageSize': pageSize.toString(),
        },
      );

      final response = await _dio.getUri<Uint8List>(
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          headers: Authorization.createHeaders(),
        ),
      );

      return response.data!;
    } catch (e) {
      throw Exception('Greška pri preuzimanju izvještaja: ${e.toString()}');
    }
  }

  Future<Uint8List> downloadOrdersReport({
    String? searchFilter,
    String? status,
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/reports/orders').replace(
        queryParameters: {
          if (searchFilter != null) 'SearchFilter': searchFilter,
          if (status != null) 'Status': status,
          if (pageNumber != null) 'PageNumber': pageNumber.toString(),
          if (pageSize != null) 'PageSize': pageSize.toString(),
        },
      );

      final response = await _dio.getUri<Uint8List>(
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          headers: Authorization.createHeaders(),
        ),
      );

      return response.data!;
    } catch (e) {
      throw Exception('Greška pri preuzimanju izvještaja: ${e.toString()}');
    }
  }

  Future<Uint8List> downloadToolsReport({
    String? searchFilter,
    int? categoryId,
    String? lastServiceDate,
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/reports/tools').replace(
        queryParameters: {
          if (searchFilter != null) 'SearchFilter': searchFilter,
          if (categoryId != null) 'CategoryId': categoryId.toString(),
          if (lastServiceDate != null) 'LastServiceDate': lastServiceDate,
          if (pageNumber != null) 'PageNumber': pageNumber.toString(),
          if (pageSize != null) 'PageSize': pageSize.toString(),
        },
      );

      final response = await _dio.getUri<Uint8List>(
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          headers: Authorization.createHeaders(),
        ),
      );

      return response.data!;
    } catch (e) {
      throw Exception('Greška pri preuzimanju izvještaja: ${e.toString()}');
    }
  }
}