import 'package:wood_track_admin/models/review.dart';
import 'base_provider.dart';

class ReviewsProvider extends BaseProvider<Review> {
  ReviewsProvider() : super('Reviews');

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }
}