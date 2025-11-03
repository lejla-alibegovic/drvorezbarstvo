import 'package:wood_track_admin/models/apiResponse.dart';
import 'package:wood_track_admin/providers/base_provider.dart';
import '../models/tool.dart';

class ToolProvider extends BaseProvider<Tool> {
  ToolProvider() : super('Tools');

  List<Tool> data = <Tool>[];

  @override
  Future<List<Tool>> get(Map<String, String>? params) async {
    data = await super.get(params);

    return data;
  }

  @override
  Future<ApiResponse<Tool>> getForPagination(Map<String, String>? params) async {
     return await super.getForPagination(params);
  }

  @override
  Tool fromJson(data) {
    return Tool.fromJson(data);
  }
}