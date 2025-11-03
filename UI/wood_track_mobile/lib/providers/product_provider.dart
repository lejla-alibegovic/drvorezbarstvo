import 'package:wood_track_mobile/models/product.dart';
import 'base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super('Products');

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}