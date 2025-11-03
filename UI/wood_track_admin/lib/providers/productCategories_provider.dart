import 'package:wood_track_admin/models/apiResponse.dart';
import 'package:wood_track_admin/providers/base_provider.dart';

import '../models/productCategory.dart';

class ProductCategoryProvider extends BaseProvider<ProductCategory> {
  ProductCategoryProvider() : super('ProductCategories');

  List<ProductCategory> data = <ProductCategory>[];

  @override
  Future<List<ProductCategory>> get(Map<String, String>? params) async {
    data = await super.get(params);

    return data;
  }

  @override
  Future<ApiResponse<ProductCategory>> getForPagination(Map<String, String>? params) async {
     return await super.getForPagination(params);
  }

  @override
  ProductCategory fromJson(data) {
    return ProductCategory.fromJson(data);
  }
}