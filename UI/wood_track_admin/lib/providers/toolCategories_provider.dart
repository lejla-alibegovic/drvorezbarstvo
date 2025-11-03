import 'package:wood_track_admin/models/apiResponse.dart';
import 'package:wood_track_admin/models/toolCategory.dart';
import 'package:wood_track_admin/providers/base_provider.dart';

class ToolCategoryProvider extends BaseProvider<ToolCategory> {
  ToolCategoryProvider() : super('ToolCategories');

  List<ToolCategory> data = <ToolCategory>[];

  @override
  Future<List<ToolCategory>> get(Map<String, String>? params) async {
    data = await super.get(params);

    return data;
  }

  @override
  Future<ApiResponse<ToolCategory>> getForPagination(Map<String, String>? params) async {
     return await super.getForPagination(params);
  }

  @override
  ToolCategory fromJson(data) {
    return ToolCategory.fromJson(data);
  }
}