import 'package:wood_track_admin/models/appUser.dart';
import '../models/apiResponse.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider<AppUser> {
  UserProvider() : super('Users');

  List<AppUser> items = <AppUser>[];

  @override
  Future<List<AppUser>> get(Map<String, String>? params) async {
    items = await super.get(params);
    return items;
  }

  @override
  Future<ApiResponse<AppUser>> getForPagination(Map<String, String>? params) async {
     return await super.getForPagination(params);
  }

  @override
  AppUser fromJson(data) {
    return AppUser.fromJson(data);
  }
}